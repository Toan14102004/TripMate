class HashtagModel {
  final int hashtagId;
  final String name;
  final DateTime createDate;

  HashtagModel({
    required this.hashtagId,
    required this.name,
    required this.createDate,
  });

  factory HashtagModel.fromJson(Map<String, dynamic> json) {
    return HashtagModel(
      hashtagId: json['hashtagId'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      createDate: DateTime.tryParse(json['createDate'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
