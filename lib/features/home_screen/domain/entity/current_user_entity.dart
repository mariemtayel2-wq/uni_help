class CurrentUserEntity {
  const CurrentUserEntity({required this.fullName, required this.initials});

  final String fullName;
  final String initials;

  factory CurrentUserEntity.fromFullName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();

    final initials = switch (parts.length) {
      0 => '?',
      1 => parts[0].substring(0, 1).toUpperCase(),
      _ => (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase(),
    };

    return CurrentUserEntity(fullName: fullName.trim().isEmpty ? 'there' : fullName.trim(), initials: initials);
  }
}