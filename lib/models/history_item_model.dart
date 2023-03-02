class HistoryItem {
  String text;
  List<String> keywords;

  HistoryItem({
    required this.text,
    required this.keywords,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    final keywords = <String>[];

    for (var keyword in json['keywords']) {
      keywords.add(keyword);
    }

    return HistoryItem(
      text: json['text'],
      keywords: keywords,
    );
  }
}
