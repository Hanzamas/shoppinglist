import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shoppinglist/main.dart';
import 'package:shoppinglist/repositories/in_memory_shopping_list_repository.dart';
import 'package:shoppinglist/services/shopping_list_service.dart';
import 'package:shoppinglist/screens/shopping_list_screen.dart';

void main() {
  group('Shopping List App Tests', () {
    testWidgets('App starts with empty shopping list', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ShoppingListApp());

      // Verify that the app starts with an empty state message.
      expect(find.text('Your shopping list is empty'), findsOneWidget);
      expect(find.text('Tap the + button to add your first item'), findsOneWidget);
      
      // Verify that the floating action button is present.
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Can add a new item to shopping list', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ShoppingListApp());

      // Tap the floating action button to open add item dialog.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify the dialog opened.
      expect(find.text('Add New Item'), findsOneWidget);
      expect(find.text('Item Name'), findsOneWidget);
      expect(find.text('Quantity'), findsOneWidget);

      // Enter item details.
      await tester.enterText(find.byType(TextFormField).first, 'Milk');
      await tester.enterText(find.byType(TextFormField).last, '2 liters');

      // Tap the Add button.
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify the item was added to the list.
      expect(find.text('Milk'), findsOneWidget);
      expect(find.text('2 liters'), findsOneWidget);
    });

    testWidgets('Shows shopping list statistics', (WidgetTester tester) async {
      // Create a service with pre-populated data.
      final repository = InMemoryShoppingListRepository();
      final service = ShoppingListService(repository);
      
      // Add some test data.
      await service.addItem(name: 'Eggs', quantity: '12 pieces');
      await service.addItem(name: 'Bread', quantity: '1 loaf');

      // Build the shopping list screen with our service.
      await tester.pumpWidget(
        MaterialApp(
          home: ShoppingListScreen(shoppingListService: service),
        ),
      );

      // Wait for the data to load.
      await tester.pumpAndSettle();

      // Verify statistics are shown.
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Remaining'), findsOneWidget);
      expect(find.text('2'), findsOneWidget); // Total count
    });
  });
}
