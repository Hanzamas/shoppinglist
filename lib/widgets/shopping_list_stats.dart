import 'package:flutter/material.dart';

/// Widget that displays statistics about the shopping list
class ShoppingListStats extends StatelessWidget {
  final int totalItems;
  final int completedItems;
  final int remainingItems;

  const ShoppingListStats({
    super.key,
    required this.totalItems,
    required this.completedItems,
    required this.remainingItems,
  });

  @override
  Widget build(BuildContext context) {
    if (totalItems == 0) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final completionPercentage = totalItems > 0 ? (completedItems / totalItems) : 0.0;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                label: 'Total',
                value: totalItems.toString(),
                color: theme.colorScheme.primary,
              ),
              _StatItem(
                label: 'Completed',
                value: completedItems.toString(),
                color: theme.colorScheme.tertiary,
              ),
              _StatItem(
                label: 'Remaining',
                value: remainingItems.toString(),
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: completionPercentage,
            backgroundColor: theme.colorScheme.outline.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.tertiary),
          ),
          const SizedBox(height: 8),
          Text(
            '${(completionPercentage * 100).round()}% Complete',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
