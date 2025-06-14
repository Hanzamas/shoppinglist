import '../models/shopping_item.dart';
import 'shopping_list_repository.dart';

/// In-memory implementation of shopping list repository
/// This can be easily replaced with a database implementation later
class InMemoryShoppingListRepository implements ShoppingListRepository {
  final List<ShoppingItem> _items = [];

  @override
  Future<List<ShoppingItem>> getAllItems() async {
    // Return a copy to prevent external modifications
    return List.from(_items);
  }

  @override
  Future<void> addItem(ShoppingItem item) async {
    _items.add(item);
  }

  @override
  Future<void> updateItem(ShoppingItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> clearCompletedItems() async {
    _items.removeWhere((item) => item.isCompleted);
  }
}
