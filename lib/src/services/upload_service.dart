import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

/// Abstract base class for APK upload services.
///
/// This interface defines the contract that all upload service implementations
/// must follow. Each service provider (Diawi, Gofile.io, etc.) implements
/// this interface to provide a consistent API for uploading APK files.
///
/// ## Implementation Requirements
///
/// Implementations must:
/// - Accept a file path to the APK to be uploaded
/// - Return a download URL upon successful upload
/// - Throw appropriate exceptions for error conditions
/// - Provide proper logging for debugging and monitoring
///
/// ## Example Usage
///
/// ```dart
/// final uploadService = SomeUploadService('api_token');
/// try {
///   final downloadUrl = await uploadService.upload('/path/to/app.apk');
///   print('Download URL: $downloadUrl');
/// } catch (e) {
///   print('Upload failed: $e');
/// }
/// ```
abstract class UploadService {
  /// Uploads an APK file and returns the download URL.
  ///
  /// Takes the absolute path to an APK file and uploads it to the
  /// service provider. Returns a publicly accessible download URL
  /// that can be shared with testers or stakeholders.
  ///
  /// Throws an [Exception] if:
  /// - The file doesn't exist at the specified path
  /// - The upload fails due to network issues
  /// - The service returns an error response
  /// - Authentication fails (for services requiring tokens)
  Future<String> upload(String filePath);
}

/// Upload service implementation for Diawi distribution platform.
///
/// Diawi (https://diawi.com) is a tool for developers to deploy development and
/// in-house applications directly to devices. This service handles the complete
/// upload workflow including file validation, multipart upload, and download
/// URL generation.
///
/// ## Features
///
/// - Supports APK files up to 70MB (Diawi limitation)
/// - Automatic file validation before upload
/// - Detailed error handling and logging
/// - Returns a shareable download URL
///
/// ## Authentication
///
/// Requires a valid Diawi API token. Get your token from:
/// https://dashboard.diawi.com/profile/api
///
/// ## Example Usage
///
/// ```dart
/// final diawiService = DiawiUploadService('your_api_token');
/// try {
///   final url = await diawiService.upload('/path/to/app.apk');
///   print('Share this link: $url');
/// } catch (e) {
///   print('Upload failed: $e');
/// }
/// ```
class DiawiUploadService implements UploadService {
  /// The API token for authenticating with Diawi services.
  final String apiToken;
  
  /// Logger instance for tracking upload operations.
  static final Logger _logger = Logger('DiawiUploadService');

  /// Creates a new Diawi upload service with the provided API token.
  ///
  /// The [apiToken] must be a valid token obtained from the Diawi dashboard.
  /// This token is used to authenticate all upload requests.
  DiawiUploadService(this.apiToken);

  /// Uploads an APK file to Diawi and returns the download URL.
  ///
  /// This method performs the complete Diawi upload workflow:
  /// 1. Validates that the APK file exists
  /// 2. Creates a multipart HTTP request with the API token
  /// 3. Uploads the file to Diawi's servers
  /// 4. Processes the response to extract the job ID
  /// 5. Constructs and returns the download URL
  ///
  /// ## Parameters
  ///
  /// - [filePath]: Absolute path to the APK file to upload
  ///
  /// ## Returns
  ///
  /// A [Future<String>] that completes with the Diawi download URL.
  /// The URL format is: `https://i.diawi.com/app/{job_id}`
  ///
  /// ## Throws
  ///
  /// - [Exception]: If the file doesn't exist
  /// - [Exception]: If the upload request fails
  /// - [Exception]: If the Diawi API returns an error
  ///
  /// ## Example
  ///
  /// ```dart
  /// final service = DiawiUploadService('your_token');
  /// final url = await service.upload('/path/to/app.apk');
  /// // Returns: 'https://i.diawi.com/app/abc123'
  /// ```
  @override
  Future<String> upload(String filePath) async {
    _logger.info('Starting upload to Diawi...');

    // Validate file existence before attempting upload
    final file = File(filePath);
    if (!await file.exists()) {
      _logger.severe('File not found: $filePath');
      throw Exception('File not found: $filePath');
    }

    // Create multipart request for file upload
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://upload.diawi.com/'),
    );
    
    // Add authentication token and file to request
    request.fields['token'] = apiToken;
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      // Send upload request
      final response = await request.send();
      
      if (response.statusCode == 200) {
        // Parse successful response
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        
        if (jsonResponse['job'] != null) {
          // Construct download URL from job ID
          final downloadLink = 'https://i.diawi.com/app/${jsonResponse['job']}';
          _logger.info('Upload successful: $downloadLink');
          return downloadLink;
        } else {
          // Handle API error response
          final errorMessage = jsonResponse['message'] ?? 'Unknown error';
          _logger.severe('Diawi upload failed: $errorMessage');
          throw Exception('Diawi upload failed: $errorMessage');
        }
      } else {
        // Handle HTTP error status
        _logger.severe('Diawi upload failed with status: ${response.statusCode}');
        throw Exception('Diawi upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or parsing errors
      _logger.severe('Error uploading to Diawi: $e');
      throw Exception('Error uploading to Diawi: $e');
    }
  }
}
