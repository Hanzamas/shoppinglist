import '../models/shopping_item.dart';
import '../repositories/shopping_list_repository.dart';

/// Service class that handles business logic for shopping list operations
class ShoppingListService {
  final ShoppingListRepository _repository;

  ShoppingListService(this._repository);

  /// Gets all shopping items sorted by completion status and name
  Future<List<ShoppingItem>> getAllItems() async {
    final items = await _repository.getAllItems();
    
    // Sort items: incomplete items first, then by name
    items.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    
    return items;
  }

  /// Adds a new shopping item with validation
  Future<void> addItem({
    required String name,
    required String quantity,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Item name cannot be empty');
    }
    
    if (quantity.trim().isEmpty) {
      throw ArgumentError('Item quantity cannot be empty');
    }

    final item = ShoppingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      quantity: quantity.trim(),
    );

    await _repository.addItem(item);
  }

  /// Toggles the completion status of an item
  Future<void> toggleItemCompletion(String id) async {
    final items = await _repository.getAllItems();
    final item = items.firstWhere(
      (item) => item.id == id,
      orElse: () => throw ArgumentError('Item not found'),
    );

    final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
    await _repository.updateItem(updatedItem);
  }

  /// Updates an existing shopping item
  Future<void> updateItem({
    required String id,
    required String name,
    required String quantity,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Item name cannot be empty');
    }
    
    if (quantity.trim().isEmpty) {
      throw ArgumentError('Item quantity cannot be empty');
    }

    final items = await _repository.getAllItems();
    final item = items.firstWhere(
      (item) => item.id == id,
      orElse: () => throw ArgumentError('Item not found'),
    );

    final updatedItem = item.copyWith(
      name: name.trim(),
      quantity: quantity.trim(),
    );

    await _repository.updateItem(updatedItem);
  }

  /// Deletes a shopping item
  Future<void> deleteItem(String id) async {
    await _repository.deleteItem(id);
  }

  /// Clears all completed items
  Future<void> clearCompletedItems() async {
    await _repository.clearCompletedItems();
  }

  /// Gets statistics about the shopping list
  Future<Map<String, int>> getStatistics() async {
    final items = await _repository.getAllItems();
    final completedCount = items.where((item) => item.isCompleted).length;
    final totalCount = items.length;
    
    return {
      'total': totalCount,
      'completed': completedCount,
      'remaining': totalCount - completedCount,
    };
  }
}
