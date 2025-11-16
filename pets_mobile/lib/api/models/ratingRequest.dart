class RatingRequest {
  final String comment;
  final int value;

  const RatingRequest({
    required this.comment,
    required this.value,
  });

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'value': value,
    };
  }
}