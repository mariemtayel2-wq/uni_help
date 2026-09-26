class CurrentUserEntity {
  const CurrentUserEntity({
    required this.fullName,
    required this.initials,
    this.rating = 0,
    this.ratingCount = 0,
    this.avatarUrl,
  });

  final String fullName;
  final String initials;
  final double rating;       // ⬅️ هيتحتاج للبروفايل + استخدمناه في RequestEntity.requesterRating
  final int ratingCount;     // ⬅️ هيتحتاج للبروفايل + استخدمناه في RequestEntity.requesterRatingCount
  final String? avatarUrl;   // ⬅️ هيتحتاج للبروفايل + أي مكان بيعرض صورة اليوزر

  factory CurrentUserEntity.fromFullName(
    String fullName, {
    double rating = 0,
    int ratingCount = 0,
    String? avatarUrl,
  }) {
    final parts = fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();

    final initials = switch (parts.length) {
      0 => '?',
      1 => parts[0].substring(0, 1).toUpperCase(),
      _ => (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase(),
    };

    return CurrentUserEntity(
      fullName: fullName.trim().isEmpty ? 'there' : fullName.trim(),
      initials: initials,
      rating: rating,
      ratingCount: ratingCount,
      avatarUrl: avatarUrl,
    );
  }
}