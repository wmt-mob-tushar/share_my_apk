## 🚀 0.4.0-beta - The "Rock-Solid & Ready" Release

**🎯 Major API Integration Fixes & Comprehensive Testing**

-   **🔧 Fixed Gofile API Integration:** 
    - Corrected server endpoint to `https://api.gofile.io/servers`
    - Fixed upload endpoint to use proper `/contents/uploadfile` path
    - Improved response parsing for download links
    - Now successfully handles large files (tested with 113.4MB APKs)

-   **🔧 Enhanced Diawi API Integration:**
    - Implemented proper asynchronous job polling mechanism
    - Added timeout handling (30 attempts with 5-second intervals)
    - Improved status checking with proper error handling
    - Fixed response parsing for final download links

-   **🧪 Comprehensive Testing Suite:**
    - Added **100+ unit tests** covering all major components
    - Created **6 test categories**: Upload services, build services, CLI, error handling, integration
    - **19 test files** ensuring reliability and preventing regressions
    - Added `TESTING.md` with complete testing documentation

-   **🛡️ Enhanced Error Handling:**
    - Improved upload service factory with better validation
    - Added case-insensitive provider matching
    - Enhanced error messages for better debugging
    - Robust handling of null/empty inputs and edge cases

-   **✅ Production-Ready Validation:**
    - Successfully tested real uploads to both Diawi and Gofile
    - Verified automatic provider switching for large files
    - Validated configuration loading and CLI argument parsing
    - All code passes static analysis (`dart analyze`)

-   **📚 Updated Documentation:**
    - Comprehensive testing documentation
    - Updated API integration details
    - Enhanced troubleshooting guide
    - Better error handling examples

**⚠️ Beta Release Note:** This version includes significant API fixes and comprehensive testing. While thoroughly tested in development, we recommend testing in your specific environment before production use.

## 🚀 0.3.2 - The "Polished & Perfected" Release

-   **✨ Improved Readability:** We've polished the code to make it cleaner and more consistent. You won't see the changes, but you'll feel the love.
-   **📝 Better Documentation:** Added more details to our project documentation, making it easier for everyone to contribute.

## 🚀 0.3.1 - The "Oops, We Fixed It" Release

-   **🐛 Bug Fix:** Fixed a critical issue that could cause the build process to fail. Now, it's smooth sailing!
-   **⬆️ Under the Hood:** Updated our dependencies to the latest versions for better performance and security.
-   **📝 Clearer Instructions:** We've added more detailed comments to the code to make it easier to understand.

## 🚀 0.3.0 - The "Let's Get Serious (About Fun)" Release

-   **✨ Major Refactor:** We've completely reorganized the codebase to make it more robust and easier to maintain.
-   **⬆️ Fresher Than Ever:** All our dependencies have been updated to the latest versions.
-   **📝 Fun New Docs:** Our `README.md` is now more engaging and easier to read.
-   **💡 Clearer Examples:** Our examples are now so simple that anyone can follow along.

## 🎉 0.2.0-alpha - The "We're Getting Fancy" Release

-   **🚀 Quick Start:** You can now use the `init` command to create a configuration file automatically.
-   **🎨 Better Help:** The `--help` command has been redesigned to be more intuitive and helpful.
-   **⚙️ Easy Configuration:** We now support a `share_my_apk.yaml` file, so you can set your preferences once and forget about it.
-   **🔑 Separate Tokens:** You can now use different API tokens for Diawi and Gofile.
-   **🐛 Bug Fix:** Fixed a bug that was causing issues with API tokens.

---

## 🐣 0.1.0-alpha - The "Hello, World!" Release

-   **☁️ More Choices:** You can now upload your APKs to either Diawi or Gofile.io.
-   **🔄 Smart Uploads:** If your APK is too large for Diawi, we'll automatically switch to Gofile.io.
-   **🎨 Custom Names:** You can now give your APK a custom name.
-   **📁 Tidy Folders:** We've made it easier to keep your build folders organized.
-   **📝 You're in Control:** You can now specify a custom output directory for your APK.
-   **🪵 Stay Informed:** We've added logging so you can see what's happening behind the scenes.