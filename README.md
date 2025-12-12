# Flutter Task Systems 📱

A **production-ready** Flutter app showcasing a complete product management system with listing, details, favorites, and unit testing. Built with **GetX**, **Hive**, and **Clean Architecture**.

## ✨ Features

 **Product Listing** - Grid/List view with product cards  
 **Product Details** - Full product information page  
 **Favorites System** - Save/unsave products locally with Hive  
 **Pull-to-Refresh** - Refresh product list with gestures  
 **Pagination** - Load more products on scroll  
 **Offline Support** - Cached data for offline viewing  
 **Dark Mode** - Light/Dark theme support  
 **Error Handling** - Comprehensive error states  
 **Loading States** - Visual feedback during data fetch  
 **GetX State Management** - Fast, reactive state management  
 **Dependency Injection** - get_it service locator  
 **Unit Tests** - 2+ comprehensive tests with Mockito

---

## 🏗️ Architecture

**Pattern:** Clean Architecture with GetX

```
lib/
├── main.dart                          # Entry point
├── config/
│   ├── di/service_locator.dart       # Dependency injection setup
│   └── theme/app_theme.dart          # Theme configuration
├── data/
│   ├── models/product_model.dart      # Product data model
│   ├── datasources/
│   │   ├── remote/product_api.dart    # API calls
│   │   └── local/favorite_hive_datasource.dart  # Hive database
│   └── repositories/product_repository.dart     # Data access layer
├── presentation/
│   ├── controllers/
│   │   └── product_list_controller.dart         # Business logic
│   ├── pages/
│   │   ├── product_list_page.dart               # List screen
│   │   └── product_detail_page.dart             # Detail screen
│   └── widgets/
│       ├── product_card.dart
│       ├── product_grid.dart
│       ├── loading_widget.dart
│       ├── error_widget.dart
│       └── custom_app_bar.dart
└── utils/constants.dart
```

**Layer Breakdown:**

- **Data Layer** - Handles API calls, local database, and repository pattern
- **Presentation Layer** - GetX controllers manage state, Pages/Widgets display UI
- **Config Layer** - Dependency injection and theme setup

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.0+
- Dart 3.0+
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ahmed-Muhammad/flutter_task_systems.git
   cd flutter_task_systems
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation (for Mockito tests)**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

5. **Run tests**
   ```bash
   flutter test
   ```

---

## 🔑 Key Technologies

| Technology               | Purpose                    |
|--------------------------|----------------------------|
| **GetX**                 | State management & routing |
| **Hive**                 | Local NoSQL database       |
| **http**                 | API communication          |
| **get_it**               | Dependency injection       |
| **cached_network_image** | Image caching              |
| **mockito**              | Unit testing framework     |

---

## 📱 Usage

### 1. View Products

- Launch app to see grid of all products
- Pull-to-refresh to reload data
- Scroll down to load more products (pagination)

### 2. View Details

- Tap any product card to view details
- See full description and larger image
- Add/remove from favorites with the heart button

### 3. Manage Favorites

- Tap heart icon to add to favorites
- Favorites are saved to Hive database
- Persists even after app restart

### 4. Toggle Dark Mode

- Use system theme or toggle in app
- All UI elements adapt to theme

---

## 🧪 Testing

### Run All Tests

```bash
flutter test
```

### Test Coverage

- **ProductRepository Tests** - API calls, caching, error handling
- **ProductListController Tests** - State management, pagination, refresh
- **FavoriteHiveDatasource Tests** - Database operations

### View Test Output

```bash
flutter test --verbose
```

### Generate Coverage Report

```bash
flutter test --coverage
lcov --list coverage/lcov.info
```

---

## 🔄 API Integration

**Base URL:** `https://fakestoreapi.com`

### Endpoints Used

- `GET /products` - Fetch all products with pagination
- `GET /products/:id` - Fetch single product details

### Example API Response

```json
{
    "id" : 1,
    "title" : "Product Title",
    "price" : 109.95,
    "description" : "Product description...",
    "category" : "electronics",
    "image" : "https://..."
}
```

---

## 💾 Local Database (Hive)

### Favorites Storage

Products are stored in Hive with key-value pairs:

```dart
// Add to favorites
await
favoritesBox.put
(productId, productData);

// Get favorites
List<Product> favorites = favoritesBox.values.toList();

// Remove from favorites
await
favoritesBox.delete
(
productId
);
```

### Box Name

- **Box:** `favorites`
- **Type:** Product models

---

## 🎨 Theming

### Light Theme

- Clean white background
- Dark text for readability
- Teal accent colors

### Dark Theme

- Dark background
- Light text
- Adjusted colors for OLED displays

### Toggle Theme

```dart
Get.changeThemeMode
(
Get.isDarkMode ? ThemeMode.light : ThemeMode.dark
);
```

---

## ⚙️ Dependency Injection Setup

```dart
// In service_locator.dart
void setupServiceLocator() {
  // API
  getIt.registerSingleton<http.Client>(http.Client());
  getIt.registerSingleton<ProductApi>(ProductApi(getIt()));

  // Database
  getIt.registerSingleton<HiveInterface>(Hive);
  getIt.registerSingleton<FavoriteHiveDatasource>(
    FavoriteHiveDatasource(getIt()),
  );

  // Repository
  getIt.registerSingleton<ProductRepository>(
    ProductRepository(getIt(), getIt()),
  );

  // Controller
  getIt.registerSingleton<ProductListController>(
    ProductListController(getIt()),
  );
}
```

---

## 🌐 Pagination Implementation

Products are loaded in batches of 10:

```dart
// First load: products 1-10
// Scroll to bottom → Load products 11-20
// Each load appends to existing list

int currentPage = 1;
int pageSize = 10;

Future<void> loadMore() async {
  currentPage++;
  // Fetch next batch
}
```

---

## 🛠️ Error Handling

### Types of Errors Handled

- **Network errors** - No internet, timeout, 404, 500
- **Local database errors** - Hive read/write failures
- **Parse errors** - JSON decoding issues
- **State errors** - Invalid app states

### Error Display

- Toast notifications for quick feedback
- Full error screens for detailed issues
- Retry buttons for failed operations

---

## 📝 Code Quality

### Best Practices Implemented

 Clean Architecture principles  
 SOLID design principles  
 Const constructors for performance  
 Proper error handling  
 Comprehensive logging  
 Type safety with Dart types  
 Null safety throughout

### Analysis

Run analysis with:

```bash
flutter analyze
```

---

## 📊 Performance

- **Image Caching** - cached_network_image for efficient loading
- **List Virtualization** - GridView with lazy loading
- **State Management** - Only rebuilds affected widgets with GetX
- **Database** - Hive for fast local storage (~1ms read/write)

---

## 🔐 Security Considerations

- HTTPS only for API calls
- No sensitive data in logs
- Secure Hive box storage (local device only)
- Input validation on all forms

---

## 🐛 Troubleshooting

### App Crashes on Startup

```bash
flutter clean
flutter pub get
flutter run
```

### Hive "Box not found" Error

```bash
# Hive registers on first run
# Clear app data if issues persist
adb shell pm clear <package_name>
```

### Tests Fail to Run

```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```

### Images Not Loading

- Check internet connection
- Verify API is accessible: https://fakestoreapi.com/products
- Clear image cache: restart app

---

## 📚 Additional Resources

- [GetX Documentation](https://pub.dev/packages/get)
- [Hive Documentation](https://pub.dev/packages/hive)
- [FakeStore API Docs](https://fakestoreapi.com/docs)
- [Flutter Testing Guide](https://flutter.dev/docs/testing)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture)

---

## 📁 Project Structure Details

### Data Layer

- **Models** - Serializable data classes with fromJson/toJson
- **DataSources** - Remote (API) and Local (Hive) data access
- **Repository** - Combines datasources, handles caching logic

### Presentation Layer

- **Controllers** - GetX RxController with business logic
- **Pages** - Full screen widgets
- **Widgets** - Reusable UI components

### Config Layer

- **DI** - Service locator pattern with get_it
- **Theme** - Material theme configuration

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is open source and available under the MIT License.

---

## 👤 Author

**Ahmad M. Hassanien**  
Senior Flutter Developer  
📧 Ahmad_hassanien@hotmail.com  
🔗 [GitHub](https://github.com/Ahmed-Muhammad) | [LinkedIn](https://linkedin.com/in/Ahmad-Muhammad)

---

## 🎓 Learning Outcomes

By studying this project, you'll learn:

-  Clean Architecture in Flutter
-  GetX state management
-  Hive local database integration
-  REST API integration with error handling
-  Unit testing with Mockito
-  Dependency injection pattern
-  Pagination implementation
-  Theme management
-  Pull-to-refresh functionality
-  Caching strategies

---

## 🔔 Version History

### v1.0.0 (Current)

-  Initial release
-  Product listing with pagination
-  Product details view
-  Favorites management
-  Dark mode support
-  Unit tests
-  Error handling

---

## 💬 Support

For questions or issues:

1. Check the [Issues](https://github.com/Ahmed-Muhammad/flutter_task_systems/issues) page
2. Create a new issue with detailed description
3. Include error logs and device information

---

**Last Updated:** December 2025  
**Framework:** Flutter 3.0+  
**Language:** Dart 3.0+  
**Architecture:** Clean Architecture with GetX

---

⭐ If this project helped you, please give it a star! ⭐
