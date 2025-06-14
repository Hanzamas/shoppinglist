import 'package:flutter_test/flutter_test.dart';
import 'package:shoppinglist/repositories/in_memory_shopping_list_repository.dart';
import 'package:shoppinglist/services/shopping_list_service.dart';

void main() {
  group('ShoppingListService', () {
    late ShoppingListService service;
    late InMemoryShoppingListRepository repository;

    setUp(() {
      repository = InMemoryShoppingListRepository();
      service = ShoppingListService(repository);
    });

    group('addItem', () {
      test('should add item with valid name and quantity', () async {
        await service.addItem(name: 'Milk', quantity: '2 liters');

        final items = await service.getAllItems();
        expect(items.length, 1);
        expect(items.first.name, 'Milk');
        expect(items.first.quantity, '2 liters');
        expect(items.first.isCompleted, false);
      });

      test('should trim whitespace from name and quantity', () async {
        await service.addItem(name: '  Milk  ', quantity: '  2 liters  ');

        final items = await service.getAllItems();
        expect(items.first.name, 'Milk');
        expect(items.first.quantity, '2 liters');
      });

      test('should throw ArgumentError for empty name', () async {
        expect(
          () => service.addItem(name: '', quantity: '2 liters'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for empty quantity', () async {
        expect(
          () => service.addItem(name: 'Milk', quantity: ''),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for whitespace-only name', () async {
        expect(
          () => service.addItem(name: '   ', quantity: '2 liters'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('getAllItems', () {
      test('should return items sorted by completion status and name', () async {
        await service.addItem(name: 'Zebra food', quantity: '1 bag');
        await service.addItem(name: 'Apple', quantity: '5 pieces');
        await service.addItem(name: 'Milk', quantity: '2 liters');

        // Complete the Apple item
        final items = await service.getAllItems();
        await service.toggleItemCompletion(items[0].id); // Apple

        final sortedItems = await service.getAllItems();

        // Should have incomplete items first (Milk, Zebra food), then completed (Apple)
        expect(sortedItems[0].name, 'Milk');
        expect(sortedItems[0].isCompleted, false);
        expect(sortedItems[1].name, 'Zebra food');
        expect(sortedItems[1].isCompleted, false);
        expect(sortedItems[2].name, 'Apple');
        expect(sortedItems[2].isCompleted, true);
      });
    });

    group('toggleItemCompletion', () {
      test('should toggle completion status', () async {
        await service.addItem(name: 'Milk', quantity: '2 liters');
        final items = await service.getAllItems();
        final itemId = items.first.id;

        await service.toggleItemCompletion(itemId);
        final updatedItems = await service.getAllItems();
        expect(updatedItems.first.isCompleted, true);

        await service.toggleItemCompletion(itemId);
        final againUpdatedItems = await service.getAllItems();
        expect(againUpdatedItems.first.isCompleted, false);
      });

      test('should throw ArgumentError for non-existent item', () async {
        expect(
          () => service.toggleItemCompletion('non-existent'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('updateItem', () {
      test('should update item with valid data', () async {
        await service.addItem(name: 'Milk', quantity: '2 liters');
        final items = await service.getAllItems();
        final itemId = items.first.id;

        await service.updateItem(
          id: itemId,
          name: 'Whole Milk',
          quantity: '3 liters',
        );

        final updatedItems = await service.getAllItems();
        expect(updatedItems.first.name, 'Whole Milk');
        expect(updatedItems.first.quantity, '3 liters');
      });

      test('should throw ArgumentError for empty name in update', () async {
        await service.addItem(name: 'Milk', quantity: '2 liters');
        final items = await service.getAllItems();
        final itemId = items.first.id;

        expect(
          () => service.updateItem(id: itemId, name: '', quantity: '2 liters'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for non-existent item update', () async {
        expect(
          () => service.updateItem(
            id: 'non-existent',
            name: 'Milk',
            quantity: '2 liters',
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('deleteItem', () {
      test('should delete item successfully', () async {
        await service.addItem(name: 'Milk', quantity: '2 liters');
        final items = await service.getAllItems();
        final itemId = items.first.id;

        await service.deleteItem(itemId);
        final updatedItems = await service.getAllItems();
        expect(updatedItems, isEmpty);
      });
    });

    group('clearCompletedItems', () {
      test('should clear only completed items', () async {
        await service.addItem(name: 'Milk', quantity: '2 liters');
        await service.addItem(name: 'Bread', quantity: '1 loaf');
        
        final items = await service.getAllItems();
        await service.toggleItemCompletion(items[0].id);

        await service.clearCompletedItems();
        final remainingItems = await service.getAllItems();
        
        expect(remainingItems.length, 1);
        expect(remainingItems.first.isCompleted, false);
      });
    });

    group('getStatistics', () {
      test('should return correct statistics', () async {
        await service.addItem(name: 'Milk', quantity: '2 liters');
        await service.addItem(name: 'Bread', quantity: '1 loaf');
        await service.addItem(name: 'Eggs', quantity: '12 pieces');

        final items = await service.getAllItems();
        await service.toggleItemCompletion(items[0].id);

        final stats = await service.getStatistics();
        expect(stats['total'], 3);
        expect(stats['completed'], 1);
        expect(stats['remaining'], 2);
      });

      test('should return zero statistics for empty list', () async {
        final stats = await service.getStatistics();
        expect(stats['total'], 0);
        expect(stats['completed'], 0);
        expect(stats['remaining'], 0);
      });
    });
  });
}
