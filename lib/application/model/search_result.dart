import 'package:scrcpy_buddy/routes.dart';

class SearchResult {
  final String label;
  final String title;
  final String description;
  final String argument;
  final String category;
  final String route;

  const SearchResult({
    required this.label,
    required this.title,
    required this.description,
    required this.argument,
    required this.category,
    required this.route,
  });

  static const _categoryToRoute = {
    'audio': AppRoute.audio,
    'camera': AppRoute.camera,
    'control': AppRoute.control,
    'device': AppRoute.device,
    'recording': AppRoute.recording,
    'v4l2': AppRoute.v4l2,
    'video': AppRoute.video,
    'virtualDisplay': AppRoute.virtualDisplay,
    'window': AppRoute.window,
  };

  static String? routeForCategory(String category) => _categoryToRoute[category];

  bool matches(String query) {
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        description.toLowerCase().contains(lowerQuery) ||
        argument.toLowerCase().contains(lowerQuery);
  }

  @override
  String toString() => 'SearchResult(label: $label, title: $title, argument: $argument)';
}
