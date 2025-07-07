import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:snug_logger/snug_logger.dart';

/// An abstract class for upload services.
abstract class UploadService {
  Future<String> upload(String filePath);
}

/// An implementation of [UploadService] for Diawi.
class DiawiUploadService implements UploadService {
  final String apiToken;

  DiawiUploadService(this.apiToken);

  @override
  Future<String> upload(String filePath) async {
    snugLog('Uploading to Diawi...', logType: LogType.info);

    final file = File(filePath);
    if (!await file.exists()) {
      snugLog('File not found: $filePath', logType: LogType.error);
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
          snugLog('Upload successful: $downloadLink', logType: LogType.info);
          return downloadLink;
        } else {
          snugLog('Diawi upload failed: ${jsonResponse['message']}', logType: LogType.error);
          throw Exception('Diawi upload failed.');
        }
      } else {
        snugLog(
          'Diawi upload failed with status: ${response.statusCode}',
          logType: LogType.error,
        );
        throw Exception('Diawi upload failed.');
      }
    } catch (e) {
      snugLog('Error uploading to Diawi: $e', logType: LogType.error);
      throw Exception('Error uploading to Diawi.');
    }
  }
}
