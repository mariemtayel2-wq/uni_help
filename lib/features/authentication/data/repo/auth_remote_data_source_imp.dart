import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/authentication/data/model/auth_model.dart';
import 'package:uni_help/features/authentication/domain/entities/forget_entity.dart';
import 'package:uni_help/features/authentication/domain/entities/login_entity.dart';
import 'package:uni_help/features/authentication/domain/entities/register_entity.dart';
import 'package:uni_help/features/authentication/domain/repo/auth_remote_data_source.dart';

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const _usersCollection = 'users';
  static const _universityIdsCollection = 'university_ids'; // مجموعة جديدة للربط

 @override
Future<void> login(LoginEntity entity) async {
  try {
    final input = entity.emailOrUniversityId.trim();
    var email = input;

    // إذا كان المدخل ليس إيميل (أي أنه University ID)
    if (!input.contains('@')) {
      final cleanId = input.toLowerCase();

      // 1. المحاولة الأولى: البحث بالـ Document ID مباشرة
      var docSnapshot = await _firestore
          .collection(_universityIdsCollection)
          .doc(cleanId)
          .get();

      String? userEmail;

      if (docSnapshot.exists) {
        userEmail = docSnapshot.data()?['email'];
      } else {
        // 2. المحاولة الثانية (للحسابات القديمة): البحث داخل مجموعة users
        // ملحوظة: users محتاجة تسجيل دخول في الـ Rules، فالـ query ده هيتمنع قبل الـ login.
        // بنتجاهل الخطأ هنا عشان تظهر رسالة "No account found" بدل رسالة الصلاحيات.
        try {
          final userQuery = await _firestore
              .collection(_usersCollection)
              .where('universityId', isEqualTo: input)
              .limit(1)
              .get();

          if (userQuery.docs.isNotEmpty) {
            userEmail = userQuery.docs.first.data()['email'];
          }
        } on FirebaseException catch (_) {
          // نكمل ونعتبره مش لاقيه.
        }
      }

      if (userEmail == null || userEmail.trim().isEmpty) {
        throw Exception('No account found for this university ID');
      }

      email = userEmail.trim();
    }

    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: entity.password,
    );

    if (credential.user != null && !credential.user!.emailVerified) {
      await _firebaseAuth.signOut();
      throw Exception(
        'Please verify your email before logging in. Check your inbox for the verification link.',
      );
    }
  } on FirebaseAuthException catch (e) {
    throw Exception(_mapFirebaseError(e));
  } on FirebaseException catch (e) {
    throw Exception(_mapFirestoreError(e));
  }
}
  @override
  Future<void> register(RegisterEntity entity) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: entity.email.trim(),
        password: entity.password,
      );

      await credential.user?.updateDisplayName(entity.fullName);
      await credential.user?.sendEmailVerification();

      final userModel = UserModel.fromEntity(entity, uid: credential.user!.uid);

      // 1. حفظ بيانات المستخدم الكاملة
      await _firestore
          .collection(_usersCollection)
          .doc(userModel.uid)
          .set(userModel.toMap());

      // 2. حفظ رابط الـ University ID بالأيميل والـ UID للمستقبل
      // (مرة واحدة بس، بحروف صغيرة عشان الـ login بيدور بنفس الشكل)
      final universityId = entity.universityId?.trim() ?? '';
      if (universityId.isNotEmpty) {
        await _firestore
            .collection(_universityIdsCollection)
            .doc(universityId.toLowerCase())
            .set({
          'email': entity.email.trim(),
          'uid': credential.user!.uid,
        });
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    } on FirebaseException catch (e) {
      // خطأ Firestore بعد ما الحساب اتكريت في Auth.
      throw Exception('Failed to save your account data: ${e.message ?? e.code}');
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordEntity entity) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: entity.email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();

      final GoogleSignInAccount googleUser;
      try {
        googleUser = await GoogleSignIn.instance.authenticate();
      } on GoogleSignInException catch (e) {
        if (e.code == GoogleSignInExceptionCode.canceled) return;
        throw Exception('Google sign-in failed: ${e.description ?? e.code}');
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        final user = userCredential.user!;
        await _firestore.collection(_usersCollection).doc(user.uid).set({
          'fullName': user.displayName ?? '',
          'university': '',
          'email': user.email ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('No account is currently signed in');
    }

    if (user.emailVerified) {
      throw Exception('This email is already verified');
    }

    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e));
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found for this email or ID';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email/ID or password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'The password is too weak';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return e.message ?? 'Something went wrong. Please try again';
    }
  }

  String _mapFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Unable to look up your university ID. Check your connection or Firebase permissions';
      case 'unavailable':
        return 'The service is temporarily unavailable. Please try again';
      default:
        return e.message ?? 'Unable to look up your university ID';
    }
  }
}