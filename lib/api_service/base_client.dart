import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:indisk_app/main.dart';
import '../../../utils/common_colors.dart';
import '../utils/common_utills.dart';
import '../utils/global_variables.dart';
import 'models/file_model.dart';

class AppBaseClient {
  Future<dynamic> getApiCall({
    String? url,
    Map<String, dynamic>? queryParams
  }) async {
    if (!connectivity) {
      showSnackBar(language.noInternet, color: CommonColors.red);
      return null;
    }

    try {
      Map<String,String> headers = _getHeaders();
      final fullUrl = generateQueryUrl(url: url, queryParams: queryParams);

      http.Response response = await http
          .get(Uri.parse(fullUrl), headers: headers)
          .timeout(const Duration(seconds: 45));

      _printApiResponse(
        postParams: {},
        headers: headers,
        queryParams: queryParams,
        url: fullUrl,
        response: response.body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          return response.body; // return raw body if not JSON
        }
      } else {
        return jsonDecode(response.body);
      }
    } on Exception catch (e) {
      log("Exception (getApiCall) :: $e");
      return null;
    }
  }

  Future<dynamic> postApiCall({
    String? url,
    Map<String, dynamic>? postParams,
  }) async {
    if (connectivity) {
      try {

        Map<String,String> headers = _getHeaders();
        http.Response response = await http.post(
          Uri.parse(url!),
          body: jsonEncode(postParams),
          headers: headers,
        );
        _printApiResponse(postParams: postParams,headers: headers,queryParams: {},url: url,response: response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return jsonDecode(response.body);
        } else {
          return jsonDecode(response.body);
        }
      } on Exception catch (e) {
        log("Exception (postApiCall) :: $e");
        return null;
      }
    } else {
      showSnackBar(language.noInternet, color: CommonColors.red);
      return null;
    }
  }

  Future<dynamic> formDataApi({
    required String url,
    required List<FileModel> files,
    Map<String, dynamic>? postParams,
    Function(int, int)? onProgress,
    String? requestMethod,
  }) async {
    if (connectivity) {
      try {
        final request = MultipartRequest(
          requestMethod ?? 'POST',
          Uri.parse(url),
          onProgress: onProgress ??
              (int bytes, int total) {
                final progress = bytes / total;
                log('Progress :: $progress ($bytes/$total)');
              },
        );

        if (postParams != null && postParams.isNotEmpty) {
          postParams.forEach((key, value) {
            request.fields[key] = value;
          });
        }
        Map<String, String> headers = _getHeaders(isMultiPart: true);
        request.headers.addAll(headers);


        for (int i = 0; i < files.length; i++) {
          FileModel? fileModel = files[i];
          request.files.add(await http.MultipartFile.fromPath(
            fileModel.fileKey!,
            fileModel.filePath!,
          ));
        }

        final streamedResponse = await request.send();
        http.Response response =
            await http.Response.fromStream(streamedResponse);
        _printApiResponse(postParams: postParams,headers: headers,queryParams: {},url: url,response: response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return jsonDecode(response.body);
        } else {
          return jsonDecode(response.body);
        }
      } on Exception catch (e) {
        log('Exception :: $e');
        return null;
      }
    } else {
      showSnackBar(
        language.noInternet,
        color: CommonColors.red,
      );
      return null;
    }
  }

  Future<dynamic> optionApiCall({
    String? url,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final client = http.Client();
        const method = 'OPTIONS';
        final request = http.Request(method,
            Uri.parse(generateQueryUrl(url: url, queryParams: queryParams)));
        final streamedResponse = await client.send(request);
        final response = await http.Response.fromStream(streamedResponse);
        _printApiResponse(postParams: {},headers: headers,queryParams: queryParams ?? {},url: generateQueryUrl(url: url, queryParams: queryParams),response: response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return jsonDecode(response.body);
        } else {
          return jsonDecode(response.body);
        }
      } on Exception catch (e) {
        log("Exception (optionApiCall) :: $e");
        return null;
      }
    } else {
      showSnackBar(language.noInternet, color: CommonColors.red);
      return null;
    }
  }

  Future<dynamic> putApiWithTokenCall({
    String? url,
    Map<String, dynamic>? postParams,
    Map<String, dynamic>? queryParams,
  }) async {
    String newUrl = url!;
    if (queryParams != null && queryParams.isNotEmpty) {
      newUrl = generateQueryUrl(url: url, queryParams: queryParams);
    }

    if (connectivity) {
      try {
        Map<String, String> headers = _getHeaders();
        http.Response response = await http.put(Uri.parse(newUrl),
            body: jsonEncode(postParams), headers: headers);

        _printApiResponse(postParams: postParams ?? {},headers: headers,queryParams: queryParams ?? {},url: generateQueryUrl(url: url, queryParams: queryParams),response: response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return jsonDecode(response.body);
        } else {
          return jsonDecode(response.body);
        }
      } on Exception catch (e) {
        log("Exception (postApiWithTokenCall) :: $e");
        return null;
      }
    } else {
      showSnackBar(language.noInternet, color: CommonColors.red);
      return null;
    }
  }

  Future<dynamic> deleteApiCall({
    String? url,
    Map<String, dynamic>? postParams,
  }) async {
    log("API URL :: $url");
    if (postParams != null) {}

    if (connectivity) {
      try {
        Map<String, String> headers = _getHeaders();

        http.Response response = await http.delete(Uri.parse(url!),
            body: postParams != null ? jsonEncode(postParams) : {},
            headers: headers);

        _printApiResponse(postParams: postParams ?? {},headers: headers,queryParams:{},url: url,response: response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          return jsonDecode(response.body);
        } else {
          return jsonDecode(response.body);
        }
      } on Exception catch (e) {
        log("Exception (postApiWithTokenCall) :: $e");
        return null;
      }
    } else {
      showSnackBar(language.noInternet, color: CommonColors.red);
      return null;
    }
  }

  String generateQueryUrl({String? url, Map<String, dynamic>? queryParams}) {
    if (queryParams != null && queryParams.isNotEmpty) {
      queryParams.forEach((key, value) {
        if (queryParams.entries.first.key == key) {
          url = "$url?$key=$value";
        } else {
          url = "$url&$key=$value";
        }
      });
    }
    return url!;
  }

  _getHeaders({bool? isMultiPart = false}) {
    Map<String, String> headers = {
      'Content-Type': isMultiPart! ? "multipart/form-data" : 'application/json',
      'Accept': 'application/json',
      // if (tokenDetails != null)
      //   'Authorization':
      //   'Bearer ${tokenDetails.accessToken ?? tokenDetails.refreshToken}',
    };
    return headers;
  }

  void _printApiResponse({
    Map<String, dynamic>? postParams,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    String? url,
    dynamic response,
  }) {
    try {
      log("URL $url");
      log("HEADERS ${headers ?? {}}");
      log("QUERY PARAMS ${queryParams ?? {}}");
      log("POST PARAMS ${postParams ?? {}}");
      log("RESPONSE ${response ?? 'NULL_RESPONSE'}");
    } catch (e) {
      log("Error printing API response: $e");
    }
  }
}

class MultipartRequest extends http.MultipartRequest {
  /// Creates a new [MultipartRequest].
  MultipartRequest(
    super.method,
    super.url, {
    this.onProgress,
  });

  final void Function(int bytes, int totalBytes)? onProgress;

  /// Freezes all mutable fields and returns a single-subscription [ByteStream]
  /// that will emit the request body.
  @override
  http.ByteStream finalize() {
    final byteStream = super.finalize();
    if (onProgress == null) return byteStream;

    final total = contentLength;
    int bytes = 0;

    final t = StreamTransformer.fromHandlers(
      handleData: (List<int> data, EventSink<List<int>> sink) {
        bytes += data.length;
        onProgress!(bytes, total);
        if (total >= bytes) {
          sink.add(data);
        }
      },
    );
    final stream = byteStream.transform(t);
    return http.ByteStream(stream);
  }
}

// Add other custom exceptions as needed
