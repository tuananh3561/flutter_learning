/// MediaApiService - Service quản lý các cuộc gọi API đến media server
/// Xử lý việc upload file và lấy danh sách file/folder từ server

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;

/// Kết quả trả về từ API upload
class UploadResult {
  final bool success;
  final String? url;
  final String? message;
  final Map<String, dynamic>? metadata;

  UploadResult({
    required this.success,
    this.url,
    this.message,
    this.metadata,
  });
}

/// Model lưu trữ thông tin về file từ API
class MediaFileInfo {
  final String id;
  final String name;
  final String url;
  final String type;
  final String folderPath;
  final String bucket;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  MediaFileInfo({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    required this.folderPath,
    required this.bucket,
    required this.createdAt,
    required this.metadata,
  });

  factory MediaFileInfo.fromJson(Map<String, dynamic> json) {
    return MediaFileInfo(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      url: json['link'] ?? json['url'] ?? '',
      type: json['format_file'] ?? json['type'] ?? '',
      folderPath: json['path'] ?? json['folder_path'] ?? '',
      bucket: json['bucket'] ?? '',
      createdAt: json['time_created'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['time_created'] as num).toInt() * 1000)
          : DateTime.now(),
      metadata: json['metadata'] ?? {},
    );
  }
}

/// Service để tương tác với API media
class MediaApiService {
  static const String baseUrl = 'https://media.monkeyuni.net/api';
  static const String defaultBucket = 'monkeymedia2020';

  final String _token;
  final String _bucket;

  MediaApiService({
    required String token,
    String bucket = defaultBucket,
  })  : _token = token,
        _bucket = bucket;

  /// Upload file lên server
  Future<UploadResult> uploadFile({
    required File file,
    required String folderPath,
    String? description,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/upload');

      // Prepare multipart request
      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll({
        'token': _token,
      });

      // Add file
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();

      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: path.basename(file.path),
      );

      // Add form fields
      request.files.add(multipartFile);
      request.fields['description'] = description ?? '';
      request.fields['folder_path'] = folderPath;
      request.fields['bucket'] = _bucket;

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Parse response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return UploadResult(
            success: true,
            url: data['data']['link'],
            metadata: data['data'],
          );
        } else {
          return UploadResult(
            success: false,
            message: data['message'] ?? 'Unknown error',
          );
        }
      } else {
        return UploadResult(
          success: false,
          message: 'HTTP Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return UploadResult(
        success: false,
        message: 'Exception: $e',
      );
    }
  }

  /// Upload file bytes lên server (dùng cho web)
  Future<UploadResult> uploadBytes({
    required Uint8List bytes,
    required String fileName,
    required String folderPath,
    String? description,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/upload');

      // Prepare multipart request
      final request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll({
        'token': _token,
      });

      // Add file
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
      );

      // Add form fields
      request.files.add(multipartFile);
      request.fields['description'] = description ?? '';
      request.fields['folder_path'] = folderPath;
      request.fields['bucket'] = _bucket;

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Parse response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return UploadResult(
            success: true,
            url: data['data']['link'],
            metadata: data['data'],
          );
        } else {
          return UploadResult(
            success: false,
            message: data['message'] ?? 'Unknown error',
          );
        }
      } else {
        return UploadResult(
          success: false,
          message: 'HTTP Error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return UploadResult(
        success: false,
        message: 'Exception: $e',
      );
    }
  }

  /// Lấy danh sách file và thư mục từ server
  Future<List<MediaFileInfo>> getFilesAndFolders({
    required String folderPath,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        'folder_path': folderPath,
        'bucket': _bucket,
      };

      final url = Uri.parse('$baseUrl/get-files-and-folders')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        url,
        headers: {
          'token': _token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final List<dynamic> items = data['data']['files'] ?? [];
          return items.map((item) => MediaFileInfo.fromJson(item)).toList();
        } else {
          throw Exception(data['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching files and folders: $e');
      return [];
    }
  }
}
