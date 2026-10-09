class RegisterEntity {
  const RegisterEntity({
    required this.fullName,
    required this.university,
    required this.email,
    required this.password,
    this.universityId,
  });

  final String fullName;
  final String university;
  final String email;
  final String password;
  final String? universityId;
}