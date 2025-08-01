# Code Review Instructions for Copilot

## Purpose

- Ensure submitted code meets project standards for quality, security, and maintainability.
- Provide actionable feedback to contributors who use Copilot suggestions in their code.

---

## Review Checklist

### 1. General Coding Standards

- **Adherence to Style Guides**:  
  - Follow language- and project-specific conventions:
    - **Flutter/Dart**: [Effective Dart](https://dart.dev/guides/language/effective-dart), [Flutter Style Guide](https://docs.flutter.dev/development/ui/advanced/style).
    - **Python**: [PEP8](https://peps.python.org/pep-0008/), [Python Best Practices](https://realpython.com/tutorials/best-practices/).
  - Consistent formatting (indentation, naming, spacing).
- **Documentation**:  
  - Functions, classes, and modules have clear, concise comments.
  - Public APIs and complex logic are well-documented.

### 2. Functionality

- **Correctness**:  
  - Code fulfills the functional requirements described in issue/PR.
  - All relevant edge cases are handled.
- **Testing**:  
  - Unit and integration tests provided for new or modified code.
  - Tests pass on CI/CD pipelines.

### 3. Flutter/Dart App Development

- **Widget Structure**:  
  - Widgets are logically organized and reused where appropriate.
  - Avoid deeply nested widget trees; use composition.
- **State Management**:  
  - State handled using recommended patterns (Provider, Riverpod, Bloc, etc.).
  - Avoid global state unless strictly necessary.
- **UI/UX Compliance**:  
  - Follows platform-specific design guidelines (Material/Cupertino).
  - Responsive layouts and accessibility best practices.
- **Performance**:  
  - Use const constructors, efficient rebuilds, and lazy loading where possible.
- **Dependency Management**:  
  - pubspec.yaml dependencies are justified and up-to-date.

### 4. Python Algorithm/Programming

- **Algorithm Efficiency**:  
  - Algorithms are optimized for time and space complexity.
  - Use built-in Python features wherever applicable.
- **Readability & Maintainability**:  
  - Code is modular, uses clear naming, and is commented.
- **Error Handling**:  
  - Exceptions are handled gracefully.
  - Input validation for functions and scripts.
- **Testing**:  
  - Unit tests for algorithm correctness and edge cases.

### 5. Security & Robustness

- **Input Validation**:  
  - All external inputs are validated and sanitized.
- **Error Handling**:  
  - Return codes and error paths are handled gracefully.
  - No silent failures or ignored errors.

### 6. Maintainability

- **Readability**:  
  - Code is self-explanatory or well-commented.
- **Modularity**:  
  - Functions and files are logically separated.
- **No Dead/Unused Code**:  
  - Remove commented-out or unused code fragments.

---

## Copilot-Specific Instructions

- **Verify Suggestions**:  
  - Do not accept Copilot-generated code blindly—validate logic and resource impact.
- **Refactor as Needed**:  
  - Improve Copilot code for efficiency, clarity, and conformity to standards.
- **Flag Unclear Code**:  
  - Request clarification if Copilot code is ambiguous or deviates from project norms.

---

## Reviewer Actions

- Leave specific, actionable feedback (reference line numbers, functions).
- Approve only if all checklist items are satisfied.
- Request changes if standards are not met.

---

## References

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Style Guide](https://docs.flutter.dev/development/ui/advanced/style)
- [PEP8 Python Style Guide](https://peps.python.org/pep-0008/)
- [Python Best Practices](https://realpython.com/tutorials/best-practices/)
