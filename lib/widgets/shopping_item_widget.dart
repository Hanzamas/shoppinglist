import 'package:flutter/material.dart';
import '../models/shopping_item.dart';

/// Widget for displaying a single shopping item in the list
class ShoppingItemWidget extends StatelessWidget {
  final ShoppingItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const ShoppingItemWidget({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: item.isCompleted ? 1 : 2,
      child: ListTile(
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (_) => onTap(),
          activeColor: Theme.of(context).primaryColor,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted
                ? Theme.of(context).disabledColor
                : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: item.isCompleted ? FontWeight.normal : FontWeight.w500,
          ),
        ),
        subtitle: Text(
          item.quantity,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted
                ? Theme.of(context).disabledColor
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null && !item.isCompleted)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
                tooltip: 'Edit item',
              ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Delete item',
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
