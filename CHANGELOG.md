## 0.3.0-alpha

- Refactored the project structure and improved the overall architecture.
- Updated dependencies to the latest versions.
- Improved documentation and examples.

## 0.2.0-alpha

- **Init Command:** Added an `init` command to generate a `share_my_apk.yaml` file with all available options.
- **Improved Help Command:** The `--help` command now displays a more readable and visually appealing help message.
- **Configuration File:** Added support for a `share_my_apk.yaml` file to allow project-specific default configurations.
- **Provider-Specific Tokens:** Replaced the generic `--token` with `--diawi-token` and `--gofile-token` to avoid token conflicts.
- **Bug Fix:** Corrected an issue where the wrong token was used when automatically switching from Diawi to Gofile for large files.

---
## 0.1.0-alpha

- Support for multiple upload providers (Diawi and Gofile.io)
- Automatic provider switching for large files (>70MB)
- Custom APK file naming with timestamps
- Environment-based directory organization
- Custom output directory configuration
- Standard logging implementation
