import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:share_my_apk/src/services/upload/upload_service.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// An [UploadService] for uploading APKs to Gofile.io.
class GofileUploadService implements UploadService {
  /// The API token for authenticating with the Gofile.io API.
  final String? apiToken;
  static final Logger _logger = Logger('GofileUploadService');

  /// Creates a new [GofileUploadService].
  GofileUploadService({this.apiToken});

  @visibleForTesting
  Future<String> getServer() async {
    final response = await http.get(
      Uri.parse('https://api.gofile.io/servers'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'ok') {
        final servers = jsonResponse['data']['servers'] as List;
        if (servers.isNotEmpty) {
          return servers[0]['name']?.toString() ?? '';
        }
      }
    }
    throw Exception('Failed to get gofile.io server.');
  }

  @override
  Future<String> upload(String filePath) async {
    _logger.info('Uploading to gofile.io...');

    final file = File(filePath);
    if (!await file.exists()) {
      _logger.severe('File not found: $filePath');
      throw Exception('File not found.');
    }

    final server = await getServer();
    final uploadUrl = Uri.parse('https://$server.gofile.io/contents/uploadfile');

    final request = http.MultipartRequest('POST', uploadUrl);
    if (apiToken != null) {
      request.fields['token'] = apiToken!;
    }
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        if (jsonResponse['status'] == 'ok') {
          final downloadPage = jsonResponse['data']['downloadPage']?.toString() ?? '';
          _logger.info('Upload successful: $downloadPage');
          return downloadPage;
        } else {
          final reason = jsonResponse['status'];
          _logger.severe('gofile.io upload failed: $reason');
          throw Exception('gofile.io upload failed.');
        }
      } else {
        _logger.severe(
          'gofile.io upload failed with status: ${response.statusCode}',
        );
        throw Exception('gofile.io upload failed.');
      }
    } catch (e) {
      _logger.severe('Error uploading to gofile.io: $e');
      throw Exception('Error uploading to gofile.io.');
    }
  }
}
