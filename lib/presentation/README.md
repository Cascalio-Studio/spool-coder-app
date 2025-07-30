# Presentation Layer

This layer contains all user interface components and handles user interactions.

## Structure

- **screens/**: Complete page-level UI components
- **widgets/**: Reusable UI components shared across screens  
- **navigation/**: App routing and navigation logic

## Responsibilities

- Display data to users
- Handle user input and gestures
- Navigate between screens
- Manage UI state
- Provide visual feedback

## Guidelines

- No business logic - delegate to domain layer use cases
- Use dependency injection to access use cases
- Keep widgets focused and reusable
- Follow Flutter/Material Design principles
- Ensure responsive design for different screen sizes

## Key Files

- `screens/home_screen.dart` - Main app entry screen
- (Additional screens will be added as features are implemented)

## Dependencies

- Domain layer (use cases and entities)
- Core layer (constants, utilities)
- Flutter SDK components