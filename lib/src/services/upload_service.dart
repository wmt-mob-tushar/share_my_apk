import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

/// An abstract class for upload services.
abstract class UploadService {
  Future<String> upload(String filePath);
}

/// An implementation of [UploadService] for Diawi.
class DiawiUploadService implements UploadService {
  final String apiToken;
  static final Logger _logger = Logger('DiawiUploadService');

  DiawiUploadService(this.apiToken);

  @override
  Future<String> upload(String filePath) async {
    _logger.info('Uploading to Diawi...');

    final file = File(filePath);
    if (!await file.exists()) {
      _logger.severe('File not found: $filePath');
      throw Exception('File not found.');
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
          final downloadLink = 'https://i.diawi.com/app/${jsonResponse['job']}';
          _logger.info('Upload successful: $downloadLink');
          return downloadLink;
        } else {
          _logger.severe('Diawi upload failed: ${jsonResponse['message']}');
          throw Exception('Diawi upload failed.');
        }
      } else {
        _logger.severe(
          'Diawi upload failed with status: ${response.statusCode}',
        );
        throw Exception('Diawi upload failed.');
      }
    } catch (e) {
      _logger.severe('Error uploading to Diawi: $e');
      throw Exception('Error uploading to Diawi.');
    }
  }
}
