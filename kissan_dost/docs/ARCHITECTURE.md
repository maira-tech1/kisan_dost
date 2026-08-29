# Kisan Dost Architecture

## Architecture Philosophy

Kisan Dost uses a simple feature-based Flutter architecture
with Riverpod for state management.

The architecture prioritizes:

- Simplicity
- Maintainability
- Reusability
- Clear boundaries
- Performance
- Easy modification
- Fast development

Avoid unnecessary enterprise-level abstraction.

---

## Project Structure

lib/

├── main.dart
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│
├── core/
│   ├── constants/
│   ├── network/
│   ├── utils/
│   └── widgets/
│
└── features/
    ├── home/
    ├── farmer/
    ├── assistant/
    └── weather/

---

## Feature Ownership

Each feature owns its own:

- Models
- State
- Providers
- Repositories
- Screens
- Feature-specific widgets

Feature-specific code should not be placed in `core`.

---

## Core

`core` contains only genuinely shared functionality.

Examples:

- API client
- shared constants
- validators
- reusable buttons
- reusable cards
- common loaders

Do not use `core` as a dumping ground.

---

# Riverpod

Riverpod is the application's primary state-management solution.

Use Riverpod for:

- application state
- feature state
- asynchronous operations
- API-driven state
- shared state

Prefer modern Riverpod patterns.

---

# Rebuild Strategy

Use small reactive boundaries.

Prefer:

Consumer
+
ref.watch()
+
select()

Example:

```dart
Consumer(
  builder: (context, ref, child) {
    final isListening = ref.watch(
      assistantProvider.select(
        (state) => state.isListening,
      ),
    );

    return VoiceButton(
      isListening: isListening,
    );
  },
)