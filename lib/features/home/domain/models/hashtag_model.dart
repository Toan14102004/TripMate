class HashtagModel {
  final int hashtagId;
  final String name;
  final String description;
  final DateTime createDate;

  HashtagModel({
    required this.hashtagId,
    required this.name,
    required this.description,
    required this.createDate,
  });

  factory HashtagModel.fromJson(Map<String, dynamic> json) {
    return HashtagModel(
      hashtagId: json['hashtag']['hashtagId'] as int? ?? 0,
      name: json['hashtag']['name'] as String? ?? '',
      description: json['hashtag']['description']as String? ?? '',
      createDate: DateTime.tryParse(json['createDate'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
