# Todo App

A Flutter-based todo application that demonstrates modern mobile app development practices using Provider for state management, with authentication and CRUD operations for todo items.

## Overview

This is a complete Flutter todo application that includes user authentication (login/signup), todo management (create, read, update, delete), and a clean, Material Design 3 UI. The app uses Provider for state management and includes mock API calls to simulate real backend interactions.

## Features

- **User Authentication**: Login and signup functionality with form validation
- **Todo Management**: Create, edit, delete, and mark todos as complete
- **Responsive UI**: Clean Material Design 3 interface with proper spacing and typography
- **State Management**: Provider-based architecture for predictable state updates
- **Form Validation**: Client-side validation for all user inputs
- **Loading States**: Proper loading indicators during async operations
- **Error Handling**: SnackBar notifications for user feedback

## Architecture

The app follows a clean architecture pattern with separation of concerns:

```
lib/
├── main.dart              # App entry point and provider setup
├── models/                # Data models
│   ├── todo.dart         # Todo item model
│   └── user.dart         # User model
├── providers/            # State management
│   ├── auth_provider.dart # Authentication state
│   └── todo_provider.dart # Todo list state
└── screens/              # UI screens
    ├── login_screen.dart
    ├── signup_screen.dart
    ├── todo_list_screen.dart
    └── add_edit_todo_screen.dart
```

## Components and Functionality

### Models

#### Todo Model (`lib/models/todo.dart`)
- **Purpose**: Represents a todo item with all necessary data fields
- **Fields**:
  - `id`: Unique identifier (String)
  - `title`: Todo title (String)
  - `description`: Optional detailed description (String)
  - `isCompleted`: Completion status (bool)
  - `createdAt`: Creation timestamp (DateTime)
  - `updatedAt`: Last update timestamp (DateTime, optional)
- **Methods**:
  - `copyWith()`: Creates a copy with modified fields (immutability)
  - `toJson()` / `fromJson()`: Serialization for API communication
- **Why used**: Provides type safety and structure for todo data, enables JSON serialization for API calls

#### User Model (`lib/models/user.dart`)
- **Purpose**: Represents authenticated user information
- **Fields**:
  - `id`: Unique user identifier (String)
  - `email`: User email address (String)
  - `name`: Display name (String)
  - `avatarUrl`: Optional profile picture URL (String)
- **Methods**:
  - `toJson()` / `fromJson()`: Serialization for API communication
- **Why used**: Stores user session data and profile information

### Providers (State Management)

#### AuthProvider (`lib/providers/auth_provider.dart`)
- **Purpose**: Manages authentication state and operations
- **State**:
  - `_currentUser`: Currently logged-in user (User?)
  - `_isLoading`: Loading state for async operations (bool)
- **Getters**:
  - `currentUser`: Current user object
  - `isLoading`: Loading status
  - `isAuthenticated`: Whether user is logged in
- **Methods**:
  - `login(email, password)`: Authenticates user (mock implementation)
  - `signup(email, password, name)`: Creates new account (mock implementation)
  - `logout()`: Clears user session
- **Why used**: Centralizes auth logic, provides reactive state updates, simulates API calls

#### TodoProvider (`lib/providers/todo_provider.dart`)
- **Purpose**: Manages todo list state and CRUD operations
- **State**:
  - `_todos`: List of all todos (List<Todo>)
  - `_isLoading`: Loading state for async operations (bool)
- **Getters**:
  - `todos`: All todos
  - `completedTodos`: Filtered list of completed todos
  - `pendingTodos`: Filtered list of pending todos
  - `isLoading`: Loading status
- **Methods**:
  - `loadTodos()`: Fetches todos from API (mock)
  - `addTodo(title, description)`: Creates new todo
  - `updateTodo(id, title, description)`: Updates existing todo
  - `toggleTodoCompletion(id)`: Toggles completion status
  - `deleteTodo(id)`: Removes todo
- **Why used**: Handles all todo-related business logic, provides reactive updates to UI

### Screens (UI Components)

#### LoginScreen (`lib/screens/login_screen.dart`)
- **Purpose**: User authentication entry point
- **Components**:
  - `Form` with `GlobalKey<FormState>` for validation
  - `TextFormField` for email input with validation
  - `TextFormField` for password with visibility toggle
  - `ElevatedButton` for login action
  - `TextButton` for navigation to signup
- **Functionality**:
  - Email/password validation
  - Password visibility toggle
  - Loading state during authentication
  - Navigation to todo list on success
  - Error snackbar on failure
- **Why used**: Provides secure user authentication with proper UX

#### SignupScreen (`lib/screens/signup_screen.dart`)
- **Purpose**: New user registration
- **Components**: Similar to LoginScreen plus:
  - `TextFormField` for name input
  - `TextFormField` for password confirmation
- **Functionality**:
  - Form validation including password matching
  - Account creation with user details
  - Automatic login after successful signup
- **Why used**: Allows new users to create accounts

#### TodoListScreen (`lib/screens/todo_list_screen.dart`)
- **Purpose**: Main todo management interface
- **Components**:
  - `AppBar` with title and logout button
  - `ListView.builder` for todo items
  - `FloatingActionButton` for adding new todos
  - `TodoItem` widgets for individual todos
- **Functionality**:
  - Displays all todos with completion status
  - Swipe/tap actions for edit/delete
  - Empty state when no todos exist
  - Logout functionality
- **Why used**: Central hub for todo management

#### TodoItem Widget (within TodoListScreen)
- **Purpose**: Individual todo display component
- **Components**:
  - `Card` container
  - `Checkbox` for completion toggle
  - `ListTile` with title, description, date
  - `IconButton`s for edit and delete
- **Functionality**:
  - Visual completion indication (strikethrough, color)
  - Tap to toggle completion
  - Edit/delete actions
- **Why used**: Reusable component for consistent todo display

#### AddEditTodoScreen (`lib/screens/add_edit_todo_screen.dart`)
- **Purpose**: Create or modify todo items
- **Components**:
  - `AppBar` with dynamic title and delete button (edit mode)
  - `Form` with validation
  - `TextFormField` for title (required)
  - `TextFormField` for description (optional, multiline)
  - `ElevatedButton` for save action
- **Functionality**:
  - Pre-populates fields when editing
  - Form validation for required fields
  - Different save logic for add vs edit
  - Delete confirmation dialog
- **Why used**: Handles both creation and editing workflows

## Dependencies

### Core Dependencies
- **flutter**: SDK for building the app
- **provider**: State management solution for reactive UI updates

### Dev Dependencies
- **flutter_test**: Testing framework
- **flutter_lints**: Code quality linting rules

## Getting Started

### Prerequisites
- Flutter SDK (^3.5.3)
- Dart SDK (included with Flutter)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK**:
```bash
flutter build apk --release
```

**iOS (on macOS)**:
```bash
flutter build ios --release
```

**Web**:
```bash
flutter build web --release
```

## Key Flutter Concepts Demonstrated

### State Management with Provider
- `ChangeNotifier` for reactive state updates
- `MultiProvider` for combining multiple providers
- `Consumer` and `Provider.of` for accessing state
- Separation of business logic from UI

### Form Handling
- `Form` and `GlobalKey<FormState>` for validation
- `TextFormField` with custom validators
- Form submission and error handling

### Navigation
- `Navigator.push` and `pushReplacement` for screen transitions
- `MaterialPageRoute` for route definitions
- Proper back navigation handling

### Async Operations
- `Future` for API simulation
- Loading states with `CircularProgressIndicator`
- Error handling with `SnackBar`

### UI Components
- Material Design 3 theming
- Responsive layouts with `SafeArea` and `Padding`
- Custom widgets for reusability
- Proper spacing and typography

### Data Persistence
- JSON serialization for API communication
- Immutable data models with `copyWith`
- Type-safe data handling

## Mock API Implementation

The app uses mock implementations for API calls to simulate real backend interactions:

- **Authentication**: 2-second delay, accepts any non-empty credentials
- **Todo Operations**: 500ms delay for add/update/delete, 1s for load
- **Data Storage**: In-memory storage (persists during app session)

In a production app, these would be replaced with actual HTTP calls to a backend API.

## Future Enhancements

- Real API integration
- Local database (SQLite/Hive)
- Push notifications
- Offline sync
- User profiles and avatars
- Todo categories/tags
- Due dates and reminders
- Dark mode support
- Multi-language support

## Contributing

1. Follow Flutter best practices
2. Use Provider for state management
3. Maintain form validation
4. Test on multiple platforms
5. Update documentation for new features

## License

This project is for educational purposes.
