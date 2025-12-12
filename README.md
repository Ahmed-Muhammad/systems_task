# Fake Store Products App

A Flutter mini-ecommerce app built on top of [Fake Store API](https://fakestoreapi.com/) that demonstrates modern mobile development practices with clean architecture and offline-first capabilities.

## 📱 Overview

This application showcases:

- Product listing with **grid** and **list** view modes
- Detailed product information screen
- Favorites management with local persistence (Hive)
- Offline-first architecture with graceful fallback
- Real-time network connectivity awareness
- Dark/light theme toggle
- Clean separation of concerns (presentation, data, and cache layers)
- GetX for state management and navigation

---

## ✨ Features

### Product Listing

**Location**: `lib/presentation/pages/product_list_page.dart`

The home screen displays products fetched from the Fake Store API with the following capabilities:

- **Dual View Modes**:
    - Grid view (`ProductGrids` + `ProductGridItem`)
    - List view (`ProductList` + `ProductListItem`)
- **Pull-to-refresh** functionality
- **Offline banner** indicating network status
- **One-tap toggle** between Grid/List in the app bar

### Product Details

**Location**: `lib/presentation/pages/product_detail_page.dart`

Comprehensive product information display:

- Large product image
- Category chip
- Price display
- Rating with review count
- Full description
- Reactive "Add to/Remove from Favorites" button

### Favorites Management

**Location**: `lib/presentation/pages/favorites_screen.dart`

- Displays all favorited products
- Accessible via drawer with badge showing favorites count
- Uses the same `Product` model as the main list
- Tap any item to view full product details

### Offline Support & Caching

**Implementation**: `ProductLocalDatasource` (Hive-based)

The app provides robust offline functionality:

**When Online**:

- Products are fetched from API and cached locally
- Cache is automatically updated

**When Offline**:

- Products load from local cache
- Clear messaging when no cache exists
- Graceful degradation of functionality

**Cache Operations**:

- `cacheProducts(data)` - Store products locally
- `getAllCachedProducts()` - Retrieve all cached items
- `getCacheCount()` - Get number of cached products
- `searchCachedProducts()` - Search within cache
- `getByCategory()` - Filter by category
- `getCacheStats()` - Cache statistics
- `clearCache()` - Remove all cached data

### Network Connectivity Awareness

**Implementation**: `connectivity_plus` package

- Real-time network status monitoring
- Reactive `isOnline` flag in `ProductListController`
- Automatic reconnection handling:
    - Triggers `_handleReconnection()` when network is restored
    - Calls `refreshProducts()` to fetch latest data
    - Updates local cache automatically
- Persistent `OfflineStatusBanner` at top of screen

### Theming (Dark/Light Mode)

**Controller**: `ProductListController.isDarkMode`

- Toggle switch in `AppDrawer`
- Uses `Get.changeThemeMode()` for global theme changes
- Persistent theme preference
- Dynamic icon/text updates in drawer

### Error Handling & Loading States

**Custom Widgets**:

1. **LoadingWidget** (`lib/presentation/widgets/loading_widget.dart`):
    - Custom circular animated loader
    - Uses `AnimationController` + `RotationTransition`

2. **ErrorHandler** (`lib/presentation/widgets/error_widget.dart`):
    - Centralized error UI with:
        - Error icon
        - Title: "Oops! Something went wrong"
        - Descriptive error message
        - "Try Again" button with retry callback

---

## 🛠 Technologies

### Dependencies

```yaml
dependencies :
  flutter :
    sdk : flutter
  
  # State Management & Navigation
  get : ^4.6.6
  
  # Local Database
  hive : ^2.2.3
  hive_flutter : ^1.1.0
  
  # Network Connectivity
  connectivity_plus : ^6.0.5
  
  # UI Helpers
  gap : ^3.0.1
  
  # HTTP Client
  dio : ^5.x.x

dev_dependencies :
  flutter_lints : ^3.0.0
  build_runner : ^2.4.6
  hive_generator : ^2.0.1
```

---

## 🚀 Getting Started

### 1. Clone & Install

```bash
git clone <your-repo-url>.git
cd <your-project-folder>
flutter pub get
```

### 2. Initialize Hive & Dependency Injection

Ensure proper initialization in `main.dart` before `runApp()`:

1. Initialize Hive
2. Register necessary adapters
3. Open boxes for products and favorites
4. Create and inject dependencies:
    - `ProductLocalDatasource`
    - `ProductRepository`
    - `ProductListController`

**Example Implementation**:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters (if using custom adapters)
  // Hive.registerAdapter(ProductAdapter());

  // Open boxes
  // await Hive.openBox<Product>('products');
  // await Hive.openBox<int>('favorites');

  // Initialize local datasource
  final localDS = ProductLocalDatasource();
  await localDS.init();

  // Create repository
  final repository = ProductRepository(
    // Pass API client + localDS
  );

  // Register controller
  Get.put(ProductListController(repository, localDS));

  runApp(const MyApp());
}
```

**Controller Constructor**:

```dart
class ProductListController extends GetxController {
  final ProductRepository repository;
  final ProductLocalDatasource productHiveDS;

  ProductListController(this.repository, this.productHiveDS);
// ...
}
```

### 3. Run the App

```bash
flutter run
```

**Entry Point**: `ProductListPage` (`lib/presentation/pages/product_list_page.dart`)

The app uses `GetView<ProductListController>` and expects the controller to be registered via `Get.put` or a binding.

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── components/
│   │   ├── custom_network_image.dart      # Network image helper
│   │   └── offline_status_widget.dart     # Offline banner component
│   └── helpers/
│       └── app_logger.dart                 # Logging utility
│
├── data/
│   ├── datasources/
│   │   └── local/
│   │       └── product_local_datasource.dart  # Hive cache layer
│   ├── models/
│   │   └── product_model.dart              # Product & Rating models
│   └── repositories/
│       └── product_repository.dart         # API & favorites repository
│
├── presentation/
│   ├── controllers/
│   │   └── product_list_controller.dart    # Main app state (GetX)
│   ├── pages/
│   │   ├── product_list_page.dart          # Main products screen
│   │   ├── product_detail_page.dart        # Product details screen
│   │   ├── favorites_screen.dart           # Favorites screen
│   │   └── app_drawer.dart                 # Navigation drawer
│   └── widgets/
│       ├── product_list.dart               # List view wrapper
│       ├── product_list_item.dart          # List item card
│       ├── product_grids.dart              # Grid view wrapper
│       ├── product_grids_item.dart         # Grid item card
│       ├── loading_widget.dart             # Custom loader
│       └── error_widget.dart               # Error UI component
│
└── main.dart                                # App entry point
```

### Layer Responsibilities

- **core/**: Generic helpers and shared UI components (offline banner, network images, logger)
- **data/**: Data sources, models, and repository implementation (remote + local)
- **presentation/**: GetX controllers, pages, and reusable widgets

---

## 🏗 Architecture & Data Flow

### State Management: `ProductListController`

**Location**: `lib/presentation/controllers/product_list_controller.dart`

#### Reactive State Variables (`.obs`):

- `products` - List of all products
- `favorites` - List of favorite product IDs
- `isLoading` - Initial loading state
- `isLoadingMore` - Pagination loading state
- `error` - Error messages
- `isGridView` - Current view mode
- `isDarkMode` - Current theme mode
- `isOnline` - Network connectivity status
- `isLoadingFromCache` - Cache loading indicator
- `isRefreshingAfterReconnect` - Reconnection refresh state
- `cacheCount` - Number of cached products

#### Core Functionality:

**Initialization** (`onInit`):

- Initialize Hive datasource
- Start connectivity listener
- Load favorites from storage
- Load products (online or from cache)

**Online Data Loading**:

- Fetch from `repository.getProducts(limit: 100)`
- Cache results to Hive
- Update UI state

**Offline Data Loading**:

- Retrieve from `productHiveDS.getAllCachedProducts()`
- Show appropriate offline messaging

**Favorites Management**:

- `toggleFavorite(Product product)` - Add/remove favorites
- `loadFavorites()` - Load favorites from storage
- `isFavorite(int productId)` - Check favorite status

**Connectivity Handling**:

- Subscribe to `Connectivity().onConnectivityChanged`
- Update `isOnline` status
- Trigger `_handleReconnection()` → `refreshProducts()` on reconnection

**UI Controls**:

- `toggleViewMode()` - Switch between grid and list
- `toggleTheme()` - Toggle dark/light mode using `Get.changeThemeMode()`

### UI Layer: Product List Page

**Location**: `lib/presentation/pages/product_list_page.dart`

#### App Bar:

- Title: "Products"
- Action button: Grid/List toggle (icon changes based on `isGridView`)

#### Drawer:

- `AppDrawer` with favorites count badge
- Theme toggle switch

#### Body:

- `OfflineStatusBanner` - Persistent network status indicator
- Main content area using `GetBuilder` + `Obx`:
    - **Loading State**: Shows `LoadingWidget`
    - **Error State**: Shows `ErrorHandler` with retry functionality
    - **Offline Empty State**: Message when offline with no cache
    - **Success State**:
        - `ProductGrids` when `isGridView == true`
        - `ProductList` when `isGridView == false`
    - Both views include `RefreshIndicator` for pull-to-refresh

### Favorites Flow

**Screen**: `FavoritesScreen` (`lib/presentation/pages/favorites_screen.dart`)

- Uses `GetView<ProductListController>` for shared state
- Filters `controller.products` by `controller.isFavorite(p.id)`
- Empty state when no favorites exist
- Card tap navigation to `ProductDetailPage(product: product)`
- Favorite button on each card for quick removal

### Favorites Persistence

**Storage**: Hive database via `ProductRepository`

**Flow**:

1. `loadFavorites()` - Populates `favorites` list from Hive
2. `toggleFavorite()` - Updates:
    - Hive storage (via `addToFavorites`/`removeFromFavorites`)
    - In-memory `favorites` list
3. `isFavorite(productId)` - Checks favorite status for UI rendering

---
---

## 📸 Screenshots

| Products Grid (Dark)                                                  | Products Grid (Light)                                                  |
|-----------------------------------------------------------------------|------------------------------------------------------------------------|
| ![Products Grid Dark](assets/screenshots/Products%20Grids%20Dark.png) | ![Products Grid Light](assets/screenshots/Products%20Grid%20Light.png) |

| Products List (Dark)                                                 | Products List (Light)                                                  |
|----------------------------------------------------------------------|------------------------------------------------------------------------|
| ![Products List Dark](assets/screenshots/Products%20List%20Dark.png) | ![Products List Light](assets/screenshots/Products%20List%20Light.png) |

| Product Details (Light)                                                    | Drawer (Dark)                                        |
|----------------------------------------------------------------------------|------------------------------------------------------|
| ![Product Details Light](assets/screenshots/Product%20Details%20Light.png) | ![Drawer Dark](assets/screenshots/Drawer%20Dark.png) |

| Product Details (Dark)                                                   | Drawer (Light)                                         |
|--------------------------------------------------------------------------|--------------------------------------------------------|
| ![Product Details Dark](assets/screenshots/Product%20Details%20Dark.png) | ![Drawer Light](assets/screenshots/Drawer%20Light.png) |

| Favorites (Light)                                            | Favorites (Dark)                                           |
|--------------------------------------------------------------|------------------------------------------------------------|
| ![Favorites Light](assets/screenshots/Favorites%20Light.png) | ![Favorites Dark](assets/screenshots/Favorites%20Dark.png) |

## 👤 Author

**Ahmad M. Hassanien**

- Email: Ahmad_hassanien@hotmail.com
- Phone: (+2) 01023468689


