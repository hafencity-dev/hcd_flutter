import 'package:flutter_test/flutter_test.dart';
import 'package:hcd/utils/extensions/iterable_extensions.dart';

void main() {
  group('IterableExtensions', () {
    test('removeDuplicates() should remove duplicate elements', () {
      final list = [1, 2, 2, 3, 3, 3, 4, 5, 5];
      final result = list.removeDuplicates();
      expect(result, [1, 2, 3, 4, 5]);
    });

    test('removeDuplicates() should maintain order of first occurrence', () {
      final list = ['a', 'b', 'c', 'b', 'd', 'a', 'e'];
      final result = list.removeDuplicates();
      expect(result, ['a', 'b', 'c', 'd', 'e']);
    });

    test('removeDuplicates() should work with empty list', () {
      final list = <int>[];
      final result = list.removeDuplicates();
      expect(result, isEmpty);
    });

    test('removeDuplicates() should work with single element list', () {
      final list = [42];
      final result = list.removeDuplicates();
      expect(result, [42]);
    });

    test('removeDuplicates() should work with custom objects', () {
      final list = [
        TestObject(1),
        TestObject(2),
        TestObject(1),
        TestObject(3),
        TestObject(2),
      ];
      final result = list.removeDuplicates();
      expect(result.length, 3);
      expect(result.map((e) => e.value), [1, 2, 3]);
    });
  });
}

class TestObject {
  final int value;

  TestObject(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestObject &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
