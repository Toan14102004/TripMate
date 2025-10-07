class Trip {
  final String id;
  final String title;
  final String location;
  final String subtitle;
  final String imageUrl;
  final double rating;
  final int days;
  final String description;
  final double pricePerNight;

  Trip({
    required this.id,
    required this.title,
    required this.location,
    required this.subtitle,
    required this.imageUrl,
    required this.rating,
    required this.days,
    required this.description,
    required this.pricePerNight,
  });
}
