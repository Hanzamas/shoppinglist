/// Shopping item model representing a single item in the shopping list
class ShoppingItem {
  final String id;
  final String name;
  final String quantity;
  final bool isCompleted;

  const ShoppingItem({
    required this.id,
    required this.name,
    required this.quantity,
    this.isCompleted = false,
  });

  /// Creates a copy of this shopping item with the given fields replaced
  ShoppingItem copyWith({
    String? id,
    String? name,
    String? quantity,
    bool? isCompleted,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Converts the shopping item to a map for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'isCompleted': isCompleted,
    };
  }

  /// Creates a shopping item from a map
  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem &&
        other.id == id &&
        other.name == name &&
        other.quantity == quantity &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        quantity.hashCode ^
        isCompleted.hashCode;
  }

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, quantity: $quantity, isCompleted: $isCompleted)';
  }
}
