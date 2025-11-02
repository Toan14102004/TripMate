class ImageModel {
  int? imageId;
  int? tourId;
  String? imageURL;
  String? description;
  DateTime? uploadDate;

  ImageModel({
    this.imageId,
    this.tourId,
    this.imageURL,
    this.description,
    this.uploadDate,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedUploadDate;
    if (json['uploadDate'] != null) {
      parsedUploadDate = DateTime.tryParse(json['uploadDate'] as String);
    }

    return ImageModel(
      imageId: json['imageId'] as int?,
      tourId: json['tourId'] as int?,
      imageURL: json['imageURL'] as String?,
      description: json['description'] as String?,
      uploadDate: parsedUploadDate,
    );
  }
}
