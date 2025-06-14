import 'package:flutter_test/flutter_test.dart';
import 'package:shoppinglist/models/shopping_item.dart';
import 'package:shoppinglist/repositories/in_memory_shopping_list_repository.dart';

void main() {
  group('InMemoryShoppingListRepository', () {
    late InMemoryShoppingListRepository repository;

    setUp(() {
      repository = InMemoryShoppingListRepository();
    });

    test('should start with empty list', () async {
      final items = await repository.getAllItems();
      expect(items, isEmpty);
    });

    test('should add item successfully', () async {
      const item = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
      );

      await repository.addItem(item);
      final items = await repository.getAllItems();

      expect(items.length, 1);
      expect(items.first, item);
    });

    test('should update item successfully', () async {
      const item = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
      );

      await repository.addItem(item);

      final updatedItem = item.copyWith(name: 'Whole Milk');
      await repository.updateItem(updatedItem);

      final items = await repository.getAllItems();
      expect(items.length, 1);
      expect(items.first.name, 'Whole Milk');
    });

    test('should delete item successfully', () async {
      const item = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
      );

      await repository.addItem(item);
      await repository.deleteItem('1');

      final items = await repository.getAllItems();
      expect(items, isEmpty);
    });

    test('should clear completed items only', () async {
      const item1 = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
        isCompleted: true,
      );

      const item2 = ShoppingItem(
        id: '2',
        name: 'Bread',
        quantity: '1 loaf',
        isCompleted: false,
      );

      await repository.addItem(item1);
      await repository.addItem(item2);
      await repository.clearCompletedItems();

      final items = await repository.getAllItems();
      expect(items.length, 1);
      expect(items.first.id, '2');
    });

    test('should return copy of items to prevent external modification', () async {
      const item = ShoppingItem(
        id: '1',
        name: 'Milk',
        quantity: '2 liters',
      );

      await repository.addItem(item);
      final items1 = await repository.getAllItems();
      final items2 = await repository.getAllItems();

      expect(identical(items1, items2), false);
    });
  });
}
