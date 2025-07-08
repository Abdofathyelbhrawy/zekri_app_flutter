class Dhikr {
  final String text;
  final int count;
  final String reference;
  int currentCount;
  bool isCompleted;
  final String category;
  final String benefit;
  final DateTime? lastCompleted;

  Dhikr({
    required this.text,
    required this.count,
    required this.reference,
    this.currentCount = 0,
    this.isCompleted = false,
    this.category = 'عام',
    this.benefit = '',
    this.lastCompleted,
  });

  Dhikr copyWith({
    String? text,
    int? count,
    String? reference,
    int? currentCount,
    bool? isCompleted,
    String? category,
    String? benefit,
    DateTime? lastCompleted,
  }) {
    return Dhikr(
      text: text ?? this.text,
      count: count ?? this.count,
      reference: reference ?? this.reference,
      currentCount: currentCount ?? this.currentCount,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      benefit: benefit ?? this.benefit,
      lastCompleted: lastCompleted ?? this.lastCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'count': count,
      'reference': reference,
      'currentCount': currentCount,
      'isCompleted': isCompleted,
      'category': category,
      'benefit': benefit,
      'lastCompleted': lastCompleted?.toIso8601String(),
    };
  }

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      text: json['text'],
      count: json['count'],
      reference: json['reference'],
      currentCount: json['currentCount'],
      isCompleted: json['isCompleted'],
      category: json['category'],
      benefit: json['benefit'],
      lastCompleted:
          json['lastCompleted'] != null
              ? DateTime.parse(json['lastCompleted'])
              : null,
    );
  }
}
