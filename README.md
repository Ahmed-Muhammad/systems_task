# Fake Store Products App

A Flutter mini‑ecommerce app built on top of [Fake Store API](https://fakestoreapi.com/) that demonstrates:

- Product listing in **grid** or **list** view
- Product details screen
- Favorites management with local persistence (Hive)
- Offline caching of products with graceful fallback
- Online/offline awareness via `connectivity_plus`
- Dark / light theme toggle
- Clean separation between **presentation**, **data**, and **local cache** layers
- GetX for state management and navigation

---

## ✨ Features

### Product Listing

- Home screen: `ProductListPage` (`lib/presentation/pages/product_list_page.dart`)
- Fetches products via a `ProductRepository` (see data layer)
- Supports:
    - Grid view (`ProductGrids` + `ProductGridItem`)
    - List view (`ProductList` + `ProductListItem`)
    - Pull‑to‑refresh
    - Offline banner
- One‑tap toggle between Grid/List in the app bar

### Product Details

- Screen: `ProductDetailPage` (`lib/presentation/pages/product_detail_page.dart`)
- Shows:
    - Large product image
    - Category chip
    - Price
    - Rating & review count
    - Description text
- “Add to / Remove from Favorites” call‑to‑action button using GetX reactive state

### Favorites

- Screen: `FavoritesScreen` (`lib/presentation/pages/favorites_screen.dart`)
- Shows all products for which `controller.isFavorite(product.id)` is true
- Uses the same `Product` model as the list
- Drawer entry: “My Favorites” with a badge showing `favorites.length`
- Tapping a favorite item opens `ProductDetailPage`

### Offline Support & Caching

- Local cache via `ProductLocalDatasource` (Hive‑based), used by `ProductListController`:
    - `cacheProducts(data)`
    - `getAllCachedProducts()`
    - `getCacheCount()`
    - `searchCachedProducts()`, `getByCategory()`, `getCacheStats()`, `clearCache()`
- When **online**:
    - Products are loaded from the API and cached to Hive
- When **offline**:
    - Products are loaded from cache if available
    - Specific messaging when no cache exists (e.g., “No cached data available. Please go online first.”)
- Fallback logic to cached data if network calls fail

### Connectivity Awareness

- Uses `connectivity_plus` to subscribe to network changes
- `ProductListController` maintains an `isOnline` reactive flag
- When the app goes from offline → online:
    - `_handleReconnection()` is triggered
    - `refreshProducts()` is called to fetch latest products and update cache
- `OfflineStatusBanner` widget (from `core/components/offline_status_widget.dart`) shows a persistent banner at the top of the list

### Theming (Dark / Light Mode)

- Controlled by `ProductListController.isDarkMode`
- Toggled via a switch inside `AppDrawer` (`lib/presentation/pages/app_drawer.dart`)
- `toggleTheme()` uses `Get.changeThemeMode(ThemeMode.dark/light)` to change theme globally
- The drawer updates icon/text based on the current theme

### Error & Loading UX

- `LoadingWidget` (`lib/presentation/widgets/loading_widget.dart`):
    - Custom circular animated loader using `AnimationController` + `RotationTransition`
- `ErrorHandler` (`lib/presentation/widgets/error_widget.dart`):
    - Central error UI with:
        - Icon
        - Title: “Oops! Something went wrong”
        - Error message
        - “Try Again” button wired to a retry callback
- Main screen uses both to display the correct state based on `isLoading` and `error`

---

## 🧩 Technologies

From `pubspec.yaml`:
dependencies:
flutter:
sdk: flutter

State / Navigation
get: ^4.6.6

Local Database
hive: ^2.2.3
hive_flutter: ^1.1.0

Connectivity
connectivity_plus: ^6.0.5

UI / Layout helpers
gap: ^3.0.1

HTTP / Repository (in data layer)
dio: ^5.x.x # or http, depending on your implementation

dev_dependencies:
flutter_lints: ^3.0.0
build_runner: ^2.4.6
hive_generator: ^2.0.1


## 🏁 Getting Started

### 1. Clone & Install
git clone <your-repo-url>.git
cd <your-project-folder>

flutter pub get



### 2. Initialize Hive & DI (in `main.dart`)

Ensure that before `runApp()` you:

1. Initialize Hive
2. Register necessary adapters
3. Open the boxes used by `ProductLocalDatasource`
4. Create and inject:
    - `ProductLocalDatasource`
    - `ProductRepository`
    - `ProductListController`

Example sketch:
void main() async {
WidgetsFlutterBinding.ensureInitialized();

await Hive.initFlutter();
// TODO: register adapters + open boxes for products and favorites

final localDS = ProductLocalDatasource(); // your implementation
await localDS.init();

final repository = ProductRepository(
// pass API client + localDS
);

Get.put(ProductListController(repository, localDS));

runApp(const MyApp());
}


`ProductListController` constructor (from `product_list_controller.dart`):

class ProductListController extends GetxController {
final ProductRepository repository;
final ProductLocalDatasource productHiveDS;

ProductListController(this.repository, this.productHiveDS);
// ...
}


### 3. Run the App


Entry screen:

- `ProductListPage` (`lib/presentation/pages/product_list_page.dart`)

It uses `GetView<ProductListController>` and expects the controller to be already registered via `Get.put` or a binding.

---

## 📂 Code Structure (based on the attached files)

lib/
core/
components/
custom_network_image.dart # Image helper
offline_status_widget.dart # Top banner for offline state
helpers/
app_logger.dart # AppLogger.debug/info/error wrappers

data/
datasources/
local/product_local_datasource.dart # Hive-based cache layer
models/
product_model.dart # Product and Rating models
repositories/
product_repository.dart # API + favorites interface / impl

presentation/
controllers/
product_list_controller.dart # All app/product state (GetX)
pages/
product_list_page.dart # Main products screen
product_detail_page.dart # Product details
favorites_screen.dart # Favorites screen
app_drawer.dart # Drawer with favorites & theme toggle
widgets/
product_list.dart # List wrapper with RefreshIndicator
product_list_item.dart # List item card
product_grids.dart # Grid wrapper with RefreshIndicator
product_grids_item.dart # Grid item card
loading_widget.dart # Custom loader
error_widget.dart # Central error UI

main.dart # App entry point



Responsibility split:

- **core/**: generic helpers and shared UI components (e.g., offline banner, network images, logger).
- **data/**: data sources, models, and repository implementation (remote + local).
- **presentation/**: GetX controllers, pages, and reusable widgets.

---

## 🧠 Architecture & Flow

### State & Logic: `ProductListController`

Defined in `lib/presentation/controllers/product_list_controller.dart`:

- Reactive fields (`.obs`):
    - `products`
    - `favorites`
    - `isLoading`, `isLoadingMore`
    - `error`
    - `isGridView`
    - `isDarkMode`
    - `isOnline`
    - `isLoadingFromCache`
    - `isRefreshingAfterReconnect`
    - `cacheCount`
- Manages:
    - Initial load (`onInit`):
        - Initializes Hive datasource
        - Starts connectivity listener
        - Loads favorites, then products
    - Online load from repository:
        - `repository.getProducts(limit: 100)`
        - Caches to Hive
    - Offline load from cache:
        - `productHiveDS.getAllCachedProducts()`
    - Fallback load from cache on errors
    - Favorites:
        - `toggleFavorite(Product product)`
        - `loadFavorites()`
        - `isFavorite(int productId)`
    - Connectivity:
        - `Connectivity().onConnectivityChanged` subscription
        - `isOnline` updates
        - `_handleReconnection()` → `refreshProducts()`
    - View mode / theme toggles:
        - `toggleViewMode()` (grid ↔ list)
        - `toggleTheme()` (dark ↔ light, using `Get.changeThemeMode`)

### UI: Product List Page

`ProductListPage` (`lib/presentation/pages/product_list_page.dart`):

- App bar:
    - Title: “Products”
    - Action: grid/list toggle (icon changes based on `isGridView`)
- Drawer:
    - `AppDrawer` with favorites count + theme switch
- Body:
    - `OfflineStatusBanner` at top
    - Main area uses `GetBuilder` + `Obx` to render:
        - `LoadingWidget` when `isLoading == true`
        - `ErrorHandler` with retry when `error` is non‑empty and no products
        - Offline empty state when offline and no cache
        - Otherwise:
            - `ProductGrids` if `isGridView == true`
            - `ProductList` if `isGridView == false`
    - Both grid and list use `RefreshIndicator` to call `refreshProducts()`

### UI: Favorites Flow

- `FavoritesScreen` (`lib/presentation/pages/favorites_screen.dart`):
    - Uses `GetView<ProductListController>` to access the same controller
    - Filters `controller.products` by `controller.isFavorite(p.id)`
    - Shows empty state if no favorites
    - Tapping a card navigates to `ProductDetailPage(product: product)`
    - Each card includes a favorite button to remove from favorites

### Favorites & Persistence

- Favorites are stored in Hive via `ProductRepository` and/or a favorites box.
- The controller maintains `favorites` as a list of IDs:
    - `loadFavorites()` populates `favorites` from repository/Hive
    - `toggleFavorite` updates:
        - Hive (via repository methods like `addToFavorites`/`removeFromFavorites`)
        - The in‑memory `favorites` list
- UI calls `isFavorite(product.id)` to decide which icon to show.

---

## 🚀 Possible Extensions

- Add explicit pagination (page + limit instead of always `limit: 100`).
- Add search and filters that use `searchCachedProducts` / `getByCategory` from the local datasource.
- Extract a separate `ThemeController` if theme logic grows.
- Add tests for:
    - `ProductListController`
    - `ProductRepository`
    - `ProductLocalDatasource`

---

## 📄 License

You can license this project under MIT or another permissive license of your choice.

---

## 👤 Author

Adapt this section to your profile. Example:

- Name: Ahmad M. Hassanien
- Role: Senior Flutter Developer
- GitHub: `https://github.com/<your-username>`
- LinkedIn: `https://www.linkedin.com/in/<your-handle>/`  
