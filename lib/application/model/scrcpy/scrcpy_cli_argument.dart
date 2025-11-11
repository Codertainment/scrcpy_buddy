abstract class ScrcpyCliArgument<V> {
  abstract List<String>? values;
  abstract String argument;
  abstract String label;

  List<String> toArgs(V value);
}