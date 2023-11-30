class Track {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String previewUrl;

  Track({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.previewUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      title: json['track']['title'] ?? '',
      subtitle: json['track']['subtitle'] ?? '',
      imageUrl: json['track']['images']['coverarthq'] ?? '',
      previewUrl: json['track']['hub']['actions'][1]['uri'] ?? '',
    );
  }
}
