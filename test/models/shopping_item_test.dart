import 'package:flutter_test/flutter_test.dart';
import 'package:shoppinglist/models/shopping_item.dart';

void main() {
  group('ShoppingItem', () {
    test('should create a shopping item with required fields', () {
      const item = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
      );

      expect(item.id, '1');
      expect(item.name, 'Milk');
      expect(item.quantity, '2 liters');
      expect(item.isCompleted, false);
    });

    test('should create a shopping item with completion status', () {
      const item = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
        isCompleted: true,
      );

      expect(item.isCompleted, true);
    });

    test('should create a copy with updated fields', () {
      const original = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
      );

      final updated = original.copyWith(
        name: 'Whole Milk',
        isCompleted: true,
      );

      expect(updated.id, '1');
      expect(updated.name, 'Whole Milk');
      expect(updated.quantity, '2 liters');
      expect(updated.isCompleted, true);
    });

    test('should convert to and from map', () {
      const item = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
        isCompleted: true,
      );

      final map = item.toMap();
      final fromMap = ShoppingItem.fromMap(map);

      expect(fromMap, item);
    });

    test('should handle equality correctly', () {
      const item1 = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
      );

      const item2 = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
      );

      const item3 = ShoppingItem(
        id: '2',
        name: 'Milk',
        quantity: '2 liters',
      );

      expect(item1, item2);
      expect(item1 == item3, false);
    });
  });
}
