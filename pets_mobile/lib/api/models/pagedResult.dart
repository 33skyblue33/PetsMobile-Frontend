class PagedResult<T> {
  final List<T> items;
  final int? nextPointer;
  final bool hasNextPage;

  const PagedResult({
    required this.items,
    this.nextPointer,
    required this.hasNextPage,
  });

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final itemsJson = json['items'] as List;
    final itemsList = itemsJson.map((itemJson) => fromJsonT(itemJson as Map<String, dynamic>)).toList();

    return PagedResult<T>(
      items: itemsList,
      nextPointer: json['nextPointer'],
      hasNextPage: json['hasNextPage'],
    );
  }
}