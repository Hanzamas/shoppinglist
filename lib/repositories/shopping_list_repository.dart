import '../models/shopping_item.dart';

/// Repository interface for shopping list data operations
abstract class ShoppingListRepository {
  /// Gets all shopping items
  Future<List<ShoppingItem>> getAllItems();
  
  /// Adds a new shopping item
  Future<void> addItem(ShoppingItem item);
  
  /// Updates an existing shopping item
  Future<void> updateItem(ShoppingItem item);
  
  /// Deletes a shopping item by ID
  Future<void> deleteItem(String id);
  
  /// Clears all completed items
  Future<void> clearCompletedItems();
}
