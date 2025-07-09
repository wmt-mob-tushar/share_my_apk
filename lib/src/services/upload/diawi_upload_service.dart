import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:share_my_apk/src/services/upload/upload_service.dart';

/// An [UploadService] for uploading APKs to Diawi.
class DiawiUploadService implements UploadService {
  /// The API token for authenticating with the Diawi API.
  final String apiToken;
  static final Logger _logger = Logger('DiawiUploadService');

  /// Creates a new [DiawiUploadService].
  DiawiUploadService(this.apiToken);

  @override
  Future<String> upload(String filePath) async {
    _logger.info('Starting upload to Diawi...');

    final file = File(filePath);
    if (!await file.exists()) {
      _logger.severe('File not found: $filePath');
      throw Exception('File not found: $filePath');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://upload.diawi.com/'),
    );

    request.fields['token'] = apiToken;
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        if (jsonResponse['job'] != null) {
          final job = jsonResponse['job'];
          _logger.info('Upload started, job ID: $job');
          
          // Poll for job completion
          return await _pollJobStatus(job as String);
        } else {
          final errorMessage = jsonResponse['message'] ?? 'Unknown error';
          _logger.severe('Diawi upload failed: $errorMessage');
          throw Exception('Diawi upload failed: $errorMessage');
        }
      } else {
        _logger.severe(
          'Diawi upload failed with status: ${response.statusCode}',
        );
        throw Exception(
          'Diawi upload failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.severe('Error uploading to Diawi: $e');
      throw Exception('Error uploading to Diawi: $e');
    }
  }

  Future<String> _pollJobStatus(String job) async {
    _logger.info('Polling job status for: $job');
    
    const maxAttempts = 30;
    const pollInterval = Duration(seconds: 5);
    
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final response = await http.get(
          Uri.parse('https://upload.diawi.com/status?token=$apiToken&job=$job'),
        );
        
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          
          if (jsonResponse['status'] == 2000) {
            // Upload completed successfully
            final hash = jsonResponse['hash'];
            final downloadLink = 'https://i.diawi.com/$hash';
            _logger.info('Upload successful: $downloadLink');
            return downloadLink;
          } else if (jsonResponse['status'] == 4000) {
            // Upload failed
            final errorMessage = jsonResponse['message'] ?? 'Upload failed';
            _logger.severe('Diawi upload failed: $errorMessage');
            throw Exception('Diawi upload failed: $errorMessage');
          } else {
            // Still processing, continue polling
            _logger.info('Job still processing, attempt ${attempt + 1}/$maxAttempts');
            await Future<void>.delayed(pollInterval);
          }
        } else {
          _logger.warning('Status check failed with status: ${response.statusCode}');
          await Future<void>.delayed(pollInterval);
        }
      } catch (e) {
        _logger.warning('Error checking job status: $e');
        await Future<void>.delayed(pollInterval);
      }
    }
    
    throw Exception('Job processing timed out after ${maxAttempts * pollInterval.inSeconds} seconds');
  }
}
