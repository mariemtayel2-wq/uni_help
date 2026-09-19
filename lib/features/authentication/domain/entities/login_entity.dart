class LoginEntity {
  const LoginEntity({
    required this.emailOrUniversityId,
    required this.password,
  });

  final String emailOrUniversityId;
  final String password;
}