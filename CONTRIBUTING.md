# Contributing to Spool Coder App

Thank you for your interest in contributing to the Spool Coder App!  
We welcome contributions to improve the app, its code, documentation, and overall user experience.

---

## How to Contribute

### 1. Get Started

- **Fork the repository** and create your branch from `main`.
- **Install dependencies**:  
  - For Flutter/Dart: run `flutter pub get`
  - For Python: ensure dependencies in `requirements.txt` or `pyproject.toml` are installed.
- Review our [Code of Conduct](CODE_OF_CONDUCT.md).

### 2. What Can You Contribute?

- **Bug fixes**: Identify and resolve issues.
- **Features**: Propose and implement new features.
- **Documentation**: Improve guides, README, or in-code comments.
- **Tests**: Add or improve unit/integration tests.
- **Code review**: Provide constructive feedback on pull requests.

### 3. Coding Guidelines

#### Flutter/Dart

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) and [Flutter Style Guide](https://docs.flutter.dev/development/ui/advanced/style).
- Use clear naming, consistent formatting, and add documentation for complex logic.
- Organize widgets and files logically; prefer composition over deep nesting.
- Use recommended state management patterns (Provider, Riverpod, Bloc, etc.).

#### Python

- Follow [PEP8](https://peps.python.org/pep-0008/) standards.
- Optimize algorithms for clarity and efficiency.
- Add docstrings and comments to explain non-trivial logic.
- Handle exceptions gracefully and validate inputs.

### 4. Submitting Changes

- **Pull Requests**:
  - Clearly describe what you changed and why.
  - Reference related issues.
  - Ensure all tests pass (`flutter test` for Dart, `pytest` for Python).
  - Keep PRs focused—avoid mixing unrelated changes.

### 5. Code Review Process

- All pull requests are reviewed for quality, maintainability, and adherence to project standards.
- Be responsive to feedback and willing to revise your code.
- See [Code Review Instructions](.github/copilot-instructions.md) for more details.

### 6. Dependencies

- Use only necessary and well-supported packages.
- Update relevant files (`pubspec.yaml` for Dart, `requirements.txt`/`pyproject.toml` for Python).
- Run `flutter pub get` or appropriate Python commands after editing dependencies.

### 7. Reporting Issues & Requests

- Use [GitHub Issues](https://github.com/Cascalio-Studio/spool-coder-app/issues) for bugs, feature requests, and suggestions.
- Include clear steps to reproduce, screenshots, or code samples if relevant.

---

## Community

- Be respectful and inclusive.
- Participate in discussions and code reviews.
- See our [Code of Conduct](CODE_OF_CONDUCT.md).

Thank you for helping build Spool Coder App!
