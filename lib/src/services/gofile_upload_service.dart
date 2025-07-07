import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:share_my_apk/src/services/upload_service.dart';
import 'package:snug_logger/snug_logger.dart';

class GofileUploadService implements UploadService {
  final String? apiToken;

  GofileUploadService({this.apiToken});

  Future<String> _getServer() async {
    final response =
        await http.get(Uri.parse('https://api.gofile.io/getServer'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'ok') {
        return jsonResponse['data']['server'];
      }
    }
    throw Exception('Failed to get gofile.io server.');
  }

  @override
  Future<String> upload(String filePath) async {
    snugLog('Uploading to gofile.io...', logType: LogType.info);

    final file = File(filePath);
    if (!await file.exists()) {
      snugLog('File not found: $filePath', logType: LogType.error);
      throw Exception('File not found.');
    }

    final server = await _getServer();
    final uploadUrl = Uri.parse('https://$server.gofile.io/uploadFile');

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
          final downloadLink = jsonResponse['data']['downloadPage'];
          snugLog('Upload successful: $downloadLink', logType: LogType.info);
          return downloadLink;
        } else {
          final reason = jsonResponse['status'];
          snugLog('gofile.io upload failed: $reason', logType: LogType.error);
          throw Exception('gofile.io upload failed.');
        }
      } else {
        snugLog(
          'gofile.io upload failed with status: ${response.statusCode}',
          logType: LogType.error,
        );
        throw Exception('gofile.io upload failed.');
      }
    } catch (e) {
      snugLog('Error uploading to gofile.io: $e', logType: LogType.error);
      throw Exception('Error uploading to gofile.io.');
    }
  }
}
