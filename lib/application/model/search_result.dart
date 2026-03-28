

class SearchResult {
  final String label;
  final String title;
  final String description;
  final String argument;
  final String category;

  const SearchResult({
    required this.label,
    required this.title,
    required this.description,
    required this.argument,
    required this.category,
  });

  bool matches(String query) {
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        description.toLowerCase().contains(lowerQuery) ||
        argument.toLowerCase().contains(lowerQuery);
  }

  @override
  String toString() => 'SearchResult(label: $label, title: $title, argument: $argument)';
}
