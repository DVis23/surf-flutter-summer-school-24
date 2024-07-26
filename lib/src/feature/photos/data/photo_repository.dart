import 'dart:convert';

import '../domain/i_photo_repository.dart';
import '../domain/models/photo_entity.dart';

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class PhotoRepository implements IPhotoRepository {
  final token = 'y0_AgAAAABZVuavAADLWwAAAAELdHsRAAAWFyiqDOJE_LPjdaheqhXn63NSWA';

  @override
  Future<List<PhotoEntity>> getPhotos() async {
    final photos = await downloadImageFromYandexCloud();
    return photos;
  }

  @override
  Future<void> uploadImageToYandexCloud(String imagePath) async {
    final uri = Uri.https(
      'cloud-api.yandex.net',
      'v1/disk/resources/upload',
      {
        "path": imagePath.split('/').last,
      },
    );

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'OAuth $token',
      },
    );

    final body = response.body;
    final json = jsonDecode(body);
    json as Map<String, dynamic>;
    final linkToUpload = json['href'] as String;

    final dio = Dio();
    final file = File(imagePath);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    await dio.put(linkToUpload, data: formData);
  }

  @override
  Future<List<PhotoEntity>> downloadImageFromYandexCloud() async {
    final uri = Uri.https(
      'cloud-api.yandex.net',
      'v1/disk/resources',
      {
        "path": '/',
        "limit": '44'
      },
    );

    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'OAuth $token',
      },
    );

    if (response.statusCode == 200) {
      final body = response.body;
      final json = jsonDecode(body) as Map<String, dynamic>;
      final items = json['_embedded']['items'] as List<dynamic>;

      return items.where((item) {
        final url = item['file'] as String?;
        return url != null && url.isNotEmpty;
      }).map((item) {
        final id = item['name'] as String;
        final url = item['file'] as String;
        final createAt = DateTime.tryParse(item['created']) ?? null;
        return PhotoEntity(
          id: id,
          url: url,
          createAt: createAt,
        );
      }).toList();
    } else {
      throw Exception('Ошибка получения фотографий с Яндекс.Диска');
    }
  }

  @override
  Future<void> deleteImageFromYandexCloud(String imagePath) async {
    final uri = Uri.https(
      'cloud-api.yandex.net',
      'v1/disk/resources',
      {
        'path': imagePath,
      },
    );

    final response = await http.delete(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'OAuth $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Ошибка удаления фотографии с Яндекс.Диска');
    }
  }
}


