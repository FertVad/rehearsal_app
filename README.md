# Rehearsal App 🎭

A Flutter-based rehearsal scheduling application with Supabase backend.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **Supabase-only** backend:

### 🗂️ Project Structure

```
lib/
├── core/                      # Core functionality
│   ├── auth/                  # Authentication providers
│   ├── design_system/         # UI design tokens & components
│   ├── providers/             # Centralized provider index
│   ├── settings/              # User settings management
│   ├── supabase/              # Supabase configuration & implementations
│   ├── utils/                 # Utilities & helpers
│   └── widgets/               # Reusable core widgets
├── domain/                    # Business logic layer
│   ├── models/                # Domain models (User, Rehearsal, Availability)
│   ├── repositories/          # Repository interfaces
│   └── usecases/              # Business logic use cases
├── features/                  # Feature modules
│   ├── auth/                  # Authentication UI
│   ├── availability/          # Availability management
│   ├── calendar/              # Calendar views
│   ├── dashboard/             # Main dashboard
│   ├── projects/              # Project management
│   ├── rehearsals/            # Rehearsal scheduling
│   ├── settings/              # Settings UI
│   └── user/                  # User profile
└── l10n/                      # Internationalization
```

### 🔧 Technology Stack

- **Frontend**: Flutter 3.29.0+ with Riverpod state management
- **Backend**: Supabase (PostgreSQL + Realtime + Auth)
- **Architecture**: Clean Architecture with Repository pattern
- **State Management**: Riverpod with centralized provider system
- **UI**: Custom design system with glass morphism components
- **Internationalization**: Flutter l10n (English/Russian)

### 📊 Data Layer

**Pure Supabase Architecture** - no local database:
- **Domain Models**: Pure Dart classes in `lib/domain/models/`
- **Repository Interfaces**: Abstract classes defining data contracts
- **Supabase Implementations**: Concrete implementations in `lib/core/supabase/repositories/`

**Key Models:**
- `User` - User profiles with timezone settings
- `Rehearsal` - Rehearsal scheduling with project integration
- `Availability` - User availability with time intervals

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.29.0+
- Dart SDK >=3.8.0 <4.0.0
- Supabase account and project

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd rehearsal_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase:**
   ```bash
   # Update lib/core/supabase/supabase_config.dart with your credentials
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🏆 Key Features

- **Rehearsal Scheduling**: Create and manage rehearsal sessions
- **Availability Tracking**: Set and track user availability with time intervals
- **Project Management**: Organize rehearsals by projects
- **Real-time Updates**: Live synchronization via Supabase realtime
- **Multi-language Support**: English and Russian localization
- **Dark/Light Themes**: Comprehensive theme system
- **Glass Morphism UI**: Modern design with advanced glass components

## 🧪 Testing

Run tests with coverage:
```bash
flutter test --coverage
```

Analyze code quality:
```bash
flutter analyze
```

## 🔧 Development

### Provider System

This project uses a **centralized provider system**:
```dart
// Import all providers from one place
import 'package:rehearsal_app/core/providers/index.dart';

// Use documented providers with consistent naming
final user = ref.watch(currentUserProvider);
final settings = ref.watch(userSettingsProvider);
```

### Adding New Features

1. Create feature module in `lib/features/`
2. Define domain models in `lib/domain/models/`
3. Add repository interface in `lib/domain/repositories/`
4. Implement Supabase repository in `lib/core/supabase/repositories/`
5. Create UI components following design system patterns

## 🏗️ Build & Deployment

### Web Build
```bash
flutter build web
```

### CI/CD

GitHub Actions workflow (`.github/workflows/flutter.yml`) runs on every push:
- Dependencies installation
- Code analysis
- Test execution with coverage
- Web build generation

## 📚 Documentation

- **Provider System**: See `lib/core/providers/PROVIDER_NAMING_GUIDE.md`
- **Usage Examples**: See `lib/core/providers/USAGE_EXAMPLE.dart`
- **Architecture Decisions**: See project ADR documents

## 🎯 Recent Changes

**Major Architecture Update (September 2024):**
- ✅ **Removed Drift** - Eliminated local database entirely
- ✅ **Pure Supabase** - Migrated to cloud-only architecture  
- ✅ **Domain Models** - Created custom domain models
- ✅ **Provider Centralization** - Unified provider management system
- ✅ **Clean Architecture** - Implemented proper separation of concerns

---

*Built with ❤️ using Flutter and Supabase*