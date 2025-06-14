import 'package:flutter/material.dart';
import '../models/shopping_item.dart';
import '../services/shopping_list_service.dart';
import '../widgets/shopping_item_widget.dart';
import '../widgets/add_edit_item_dialog.dart';
import '../widgets/shopping_list_stats.dart';

/// Main screen for the shopping list application
class ShoppingListScreen extends StatefulWidget {
  final ShoppingListService shoppingListService;

  const ShoppingListScreen({
    super.key,
    required this.shoppingListService,
  });

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<ShoppingItem> _items = [];
  Map<String, int> _stats = {'total': 0, 'completed': 0, 'remaining': 0};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    
    try {
      final items = await widget.shoppingListService.getAllItems();
      final stats = await widget.shoppingListService.getStatistics();
      
      setState(() {
        _items = items;
        _stats = stats;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to load items: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addItem() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddEditItemDialog(title: 'Add New Item'),
    );

    if (result != null) {
      try {
        await widget.shoppingListService.addItem(
          name: result['name']!,
          quantity: result['quantity']!,
        );
        await _loadItems();
        _showSuccessSnackBar('Item added successfully');
      } catch (e) {
        _showErrorSnackBar('Failed to add item: $e');
      }
    }
  }

  Future<void> _editItem(ShoppingItem item) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AddEditItemDialog(
        title: 'Edit Item',
        initialName: item.name,
        initialQuantity: item.quantity,
      ),
    );

    if (result != null) {
      try {
        await widget.shoppingListService.updateItem(
          id: item.id,
          name: result['name']!,
          quantity: result['quantity']!,
        );
        await _loadItems();
        _showSuccessSnackBar('Item updated successfully');
      } catch (e) {
        _showErrorSnackBar('Failed to update item: $e');
      }
    }
  }

  Future<void> _toggleItem(String id) async {
    try {
      await widget.shoppingListService.toggleItemCompletion(id);
      await _loadItems();
    } catch (e) {
      _showErrorSnackBar('Failed to update item: $e');
    }
  }

  Future<void> _deleteItem(ShoppingItem item) async {
    final confirmed = await _showDeleteConfirmation(item.name);
    if (confirmed) {
      try {
        await widget.shoppingListService.deleteItem(item.id);
        await _loadItems();
        _showSuccessSnackBar('Item deleted successfully');
      } catch (e) {
        _showErrorSnackBar('Failed to delete item: $e');
      }
    }
  }

  Future<void> _clearCompletedItems() async {
    final confirmed = await _showClearCompletedConfirmation();
    if (confirmed) {
      try {
        await widget.shoppingListService.clearCompletedItems();
        await _loadItems();
        _showSuccessSnackBar('Completed items cleared');
      } catch (e) {
        _showErrorSnackBar('Failed to clear completed items: $e');
      }
    }
  }

  Future<bool> _showDeleteConfirmation(String itemName) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "$itemName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<bool> _showClearCompletedConfirmation() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed Items'),
        content: const Text('Are you sure you want to remove all completed items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          if (_stats['completed']! > 0)
            IconButton(
              onPressed: _clearCompletedItems,
              icon: const Icon(Icons.clear_all),
              tooltip: 'Clear completed items',
            ),
          IconButton(
            onPressed: _loadItems,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ShoppingListStats(
                  totalItems: _stats['total']!,
                  completedItems: _stats['completed']!,
                  remainingItems: _stats['remaining']!,
                ),
                Expanded(
                  child: _items.isEmpty
                      ? _buildEmptyState()
                      : _buildItemList(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Your shopping list is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first item',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemList() {
    return RefreshIndicator(
      onRefresh: _loadItems,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return ShoppingItemWidget(
            item: item,
            onTap: () => _toggleItem(item.id),
            onDelete: () => _deleteItem(item),
            onEdit: () => _editItem(item),
          );
        },
      ),
    );
  }
}
