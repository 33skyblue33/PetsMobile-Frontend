class Rating {
  final int id;
  final int userId;
  final int value;
  final String comment;

  const Rating({
    required this.id,
    required this.userId,
    required this.value,
    required this.comment,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      userId: json['userId'],
      value: json['value'],
      comment: json['comment'],
    );
  }
}