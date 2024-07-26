/// Extension methods for [Iterable] objects.
extension IterableExtensions<T> on Iterable<T> {
  /// Removes duplicate elements from the iterable.
  ///
  /// This method converts the iterable to a [Set] to remove duplicates,
  /// and then converts it back to a [List]. The order of elements in the
  /// resulting list is not guaranteed to be the same as the original iterable.
  ///
  /// Returns a new [List] containing the unique elements from the iterable.
  ///
  /// Example:
  /// ```dart
  /// final numbers = [1, 2, 2, 3, 3, 4];
  /// final uniqueNumbers = numbers.removeDuplicates();
  /// print(uniqueNumbers); // [1, 2, 3, 4]
  /// ```
  List<T> removeDuplicates() {
    return toSet().toList();
  }
}
