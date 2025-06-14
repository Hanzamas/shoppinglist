# Shopping List App

A clean, modular, and intuitive shopping list application built with Flutter following clean architecture principles.

## Features

- ✅ Add items with name and quantity
- ✅ Mark items as completed/uncompleted
- ✅ Edit existing items
- ✅ Delete individual items
- ✅ Clear all completed items
- ✅ View shopping statistics (total, completed, remaining)
- ✅ Progress indicator
- ✅ Beautiful Material Design 3 UI
- ✅ Dark mode support
- ✅ Pull-to-refresh functionality

## Architecture

This application follows clean architecture principles with clear separation of concerns:

### Models
- `ShoppingItem`: Core data model representing a shopping list item

### Repositories
- `ShoppingListRepository`: Abstract interface for data operations
- `InMemoryShoppingListRepository`: In-memory implementation (easily replaceable with database)

### Services
- `ShoppingListService`: Business logic layer handling validation, sorting, and operations

### UI Components
- `ShoppingListScreen`: Main application screen
- `ShoppingItemWidget`: Individual item display widget
- `AddEditItemDialog`: Dialog for adding/editing items
- `ShoppingListStats`: Statistics display widget

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/
│   └── shopping_item.dart              # Data model
├── repositories/
│   ├── shopping_list_repository.dart   # Repository interface
│   └── in_memory_shopping_list_repository.dart # In-memory implementation
├── services/
│   └── shopping_list_service.dart      # Business logic
├── screens/
│   └── shopping_list_screen.dart       # Main screen
└── widgets/
    ├── shopping_item_widget.dart       # Item display widget
    ├── add_edit_item_dialog.dart       # Add/edit dialog
    └── shopping_list_stats.dart        # Statistics widget

test/
├── widget_test.dart                    # Widget tests
├── models/
│   └── shopping_item_test.dart         # Model tests
├── repositories/
│   └── in_memory_shopping_list_repository_test.dart # Repository tests
└── services/
    └── shopping_list_service_test.dart # Service tests
```

## Key Design Principles

1. **Clean Architecture**: Clear separation between data, business logic, and UI layers
2. **Dependency Injection**: Services and repositories are injected, making testing easy
3. **Single Responsibility**: Each class has a single, well-defined purpose
4. **Immutable Models**: Data models are immutable with copy methods for updates
5. **Interface Segregation**: Repository interface allows easy swapping of implementations
6. **Comprehensive Testing**: Unit tests for all business logic components

## Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK

### Running the App
```bash
flutter pub get
flutter run
```

### Running Tests
```bash
flutter test
```

## Usage

1. **Adding Items**: Tap the floating action button (+) to add a new item
2. **Completing Items**: Tap the checkbox next to an item to mark it as completed
3. **Editing Items**: Tap the edit icon on incomplete items to modify them
4. **Deleting Items**: Tap the delete icon to remove items
5. **Clearing Completed**: Use the clear all button in the app bar to remove completed items
6. **Refreshing**: Pull down on the list to refresh

## Future Enhancements

- [ ] Local database persistence (SQLite)
- [ ] Categories for items
- [ ] Multiple shopping lists
- [ ] Sharing lists
- [ ] Barcode scanning
- [ ] Voice input
- [ ] Cloud synchronization

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).