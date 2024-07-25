extension IterableExtensions<T> on Iterable<T> {
  List<T> removeDuplicates() {
    return toSet().toList();
  }
}
