# Flutter MVVM App with Provider

A Flutter application demonstrating MVVM architecture with Provider state management, built as part of the technical evaluation for Sublime Technocorp.

## Features

- ✅ Dummy login screen with form validation
- ✅ Users list fetched from JSONPlaceholder API
- ✅ User detail screen with posts
- ✅ Post bookmarking with local storage (Hive)
- ✅ Bookmarks management screen
- ✅ Error handling and loading states
- ✅ Responsive UI

## Architecture

### MVVM Pattern
- **Model**: Data classes and business logic
- **View**: UI screens and widgets
- **ViewModel**: State management and business logic orchestration

### Project Structure
```
lib/
├── core/               # Core functionality
│   ├── constants/      # API endpoints and constants
│   ├── errors/         # Error handling
│   ├── services/       # API and storage services
│   └── utils/          # Validators and utilities
├── features/           # Feature modules
│   ├── auth/          # Login feature
│   ├── users/         # Users and posts feature
│   └── bookmarks/     # Bookmarks feature
└── widgets/           # Reusable widgets
```

### State Management
- **Provider**: Used for reactive state management
- **ChangeNotifier**: ViewModels extend ChangeNotifier
- **MultiProvider**: Root-level provider setup

### Local Storage
- **Hive**: NoSQL database for storing bookmarked posts
- Type-safe storage with proper initialization

## Key Implementation Details

### API Service
- Generic API service with error handling
- Centralized HTTP client management
- Type-safe JSON parsing

### Form Validation
- Reusable validators for email and password
- Real-time validation feedback

### Error Handling
- Comprehensive error states in ViewModels
- User-friendly error messages
- Retry functionality for failed requests

### Loading States
- Proper loading indicators
- Smooth state transitions
- No UI flickering

## Setup Instructions

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

## Login Credentials
- Email: test@example.com
- Password: password123

## Dependencies
- provider: State management
- http: API calls
- hive & hive_flutter: Local storage

## Clean Code Principles Applied
- Single Responsibility Principle
- Dependency Injection
- Separation of Concerns
- DRY (Don't Repeat Yourself)
- Meaningful naming conventions
- Proper error handling
- Consistent code formatting

## Future Enhancements
- Add unit tests
- Implement real authentication
- Add pagination for posts
- Add pull-to-refresh
- Implement dark mode
- Add animations
```

## Running the App

1. Make sure you have Flutter installed
2. Create a new Flutter project
3. Replace the default files with the code above
4. Run `flutter pub get`
5. Run `flutter run`