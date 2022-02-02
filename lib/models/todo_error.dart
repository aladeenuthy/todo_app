class TodoException implements Exception {
  final String message;
  TodoException(this.message);

  @override
  String toString() {
    return message;
  }
}
