class CacheEntry<T> {
  CacheEntry({required this.value, required this.expiry});

  factory CacheEntry.fromJson(Map<String, dynamic> json) {
    return CacheEntry<T>(
      value: json['value'] as T,
      expiry: DateTime.parse(json['expiry'] as String),
    );
  }
  final T value;
  final DateTime expiry;

  bool get isExpired => DateTime.now().isAfter(expiry);

  Map<String, dynamic> toJson() => {
    'value': value,
    'expiry': expiry.toIso8601String(),
  };
}
