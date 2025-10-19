class TimelineItem {
  final int timeLineId;
  final String tlTitle;
  final String tlDescription;
  final String? imageTimeLine;

  TimelineItem({
    required this.timeLineId,
    required this.tlTitle,
    required this.tlDescription,
    this.imageTimeLine,
  });

  factory TimelineItem.fromJson(Map<String, dynamic> json) {
    return TimelineItem(
      timeLineId: json['timeLineId'],
      tlTitle: json['tl_title'],
      tlDescription: json['tl_description'],
      imageTimeLine: json['imageTimeLine'] as String?,
    );
  }
}