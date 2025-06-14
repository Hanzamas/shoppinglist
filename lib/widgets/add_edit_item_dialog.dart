import 'package:flutter/material.dart';

/// Dialog for adding or editing a shopping item
class AddEditItemDialog extends StatefulWidget {
  final String? initialName;
  final String? initialQuantity;
  final String? title;

  const AddEditItemDialog({
    super.key,
    this.initialName,
    this.initialQuantity,
    this.title,
  });

  @override
  State<AddEditItemDialog> createState() => _AddEditItemDialogState();
}

class _AddEditItemDialogState extends State<AddEditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialName ?? '';
    _quantityController.text = widget.initialQuantity ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop({
        'name': _nameController.text.trim(),
        'quantity': _quantityController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? 'Add Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                hintText: 'e.g., Eggs, Milk, Bread',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an item name';
                }
                return null;
              },
              autofocus: true,
              onFieldSubmitted: (_) => _submitForm(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                hintText: 'e.g., 12 pieces, 2 kg, 1 liter',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the quantity';
                }
                return null;
              },
              onFieldSubmitted: (_) => _submitForm(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.initialName != null ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
