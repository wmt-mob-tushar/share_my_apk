# 🤝 Contributing to Share My APK

Thank you for considering contributing to Share My APK! We welcome contributions from the community and appreciate your interest in making this project better.

## 🎯 Ways to Contribute

### 🐛 **Bug Reports**
- Check existing [issues](https://github.com/wm-jenildgohel/share_my_apk/issues) first
- Use the bug report template when creating new issues
- Include steps to reproduce, expected behavior, and actual behavior
- Provide your environment details (OS, Flutter version, etc.)

### 💡 **Feature Requests**
- Check existing [discussions](https://github.com/wm-jenildgohel/share_my_apk/discussions) first
- Use the feature request template
- Explain the problem you're trying to solve
- Describe your proposed solution

### 🔧 **Code Contributions**
- Fork the repository
- Create a feature branch: `git checkout -b feature/your-feature-name`
- Make your changes
- Add tests for new functionality
- Ensure all tests pass: `dart test`
- Follow the coding standards (see below)
- Submit a pull request

### 📚 **Documentation**
- Fix typos or improve clarity
- Add examples or usage scenarios
- Update README.md, CHANGELOG.md, or other docs
- Improve code comments and documentation

## 🛠️ **Development Setup**

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Git

### Setup Steps
```bash
# Clone the repository
git clone https://github.com/wm-jenildgohel/share_my_apk.git
cd share_my_apk

# Install dependencies
dart pub get

# Run tests
dart test

# Run static analysis
dart analyze
```

## 📋 **Coding Standards**

### Code Style
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format your code
- Ensure `dart analyze` passes with no issues

### Testing
- Write unit tests for new functionality
- Maintain or improve test coverage
- Test edge cases and error conditions
- Use descriptive test names

### Commit Messages
- Use conventional commit format: `type: description`
- Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`
- Examples:
  - `feat: add support for custom build environments`
  - `fix: resolve upload timeout issues`
  - `docs: update README with new CLI options`

## 🔍 **Pull Request Process**

1. **Before submitting:**
   - Ensure your code follows the style guide
   - Run `dart analyze` and fix any issues
   - Run `dart test` and ensure all tests pass
   - Update documentation if needed

2. **PR Requirements:**
   - Clear description of changes
   - Link to related issues
   - Include tests for new features
   - Update CHANGELOG.md if needed

3. **Review Process:**
   - PRs require at least one approval
   - Address reviewer feedback promptly
   - Keep PRs focused and reasonably sized

## 🧪 **Testing Guidelines**

### Test Structure
- Unit tests in `test/` directory
- Mirror the `lib/` structure in `test/`
- Test both success and failure scenarios

### Running Tests
```bash
# Run all tests
dart test

# Run specific test file
dart test test/services/upload/diawi_upload_service_test.dart

# Run tests with coverage
dart test --coverage=coverage
```

## 📦 **Project Structure**

```
share_my_apk/
├── lib/
│   ├── src/
│   │   ├── models/          # Data models
│   │   ├── services/        # Core services
│   │   └── utils/           # Utility classes
│   └── share_my_apk.dart    # Main library export
├── test/                    # Unit tests
├── example/                 # Usage examples
└── bin/                     # CLI executable
```

## 🎨 **Adding New Features**

### Upload Providers
To add a new upload provider:
1. Create a new service class implementing `UploadService`
2. Add it to `UploadServiceFactory`
3. Update CLI argument parser
4. Add comprehensive tests
5. Update documentation

### Build Pipeline Steps
To add new build pipeline steps:
1. Update `FlutterBuildService`
2. Add CLI options in `ArgParserUtil`
3. Update `CliOptions` model
4. Add tests
5. Update documentation

## 📝 **Documentation**

### Code Documentation
- Document public APIs with dartdoc comments
- Include usage examples
- Explain complex logic

### README Updates
- Keep feature lists up to date
- Update usage examples
- Maintain accurate CLI reference

## 🚀 **Release Process**

1. Update version in `pubspec.yaml`
2. Update `CHANGELOG.md`
3. Run tests and ensure they pass
4. Create a release commit
5. Tag the release: `git tag v0.X.X`
6. Push tags: `git push --tags`

## 🆘 **Getting Help**

- 💬 [GitHub Discussions](https://github.com/wm-jenildgohel/share_my_apk/discussions) for questions
- 🐛 [GitHub Issues](https://github.com/wm-jenildgohel/share_my_apk/issues) for bug reports
- 📧 Contact maintainers through GitHub

## 📜 **Code of Conduct**

We expect all contributors to:
- Be respectful and inclusive
- Provide constructive feedback
- Help maintain a positive community
- Follow GitHub's community guidelines

## 🙏 **Recognition**

All contributors will be:
- Listed in the project's contributor list
- Mentioned in release notes (for significant contributions)
- Thanked in the community

---

**Ready to contribute?** Start by checking out our [good first issues](https://github.com/wm-jenildgohel/share_my_apk/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)!

Thank you for helping make Share My APK better! 🚀