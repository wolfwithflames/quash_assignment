import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// A class that provides logging functionality for Dio requests and responses.
///
/// The `DioLogger` class extends the `Interceptor` class from the `dio` package.
/// It intercepts requests and responses made using the `Dio` HTTP client and logs the relevant information.
/// The class uses the `shared_preferences` package to store the logs in the device's shared preferences.
///
/// Example usage:
/// ```dart
/// Dio dio = Dio();
/// dio.interceptors.add(DioLogger());
/// ```
///
/// To retrieve the logs, you can use the `getLogsByRequestId`, `getAllLogs`, and `clearLogs` methods.
/// The logs are stored as a map in the shared preferences, with the request ID as the key and the log entries as the values.
/// Each log entry contains the request data, response data, and the timestamp of the log entry.
///
/// Note: The `shared_preferences` package must be added as a dependency in the `pubspec.yaml` file.
///
/// Example usage:
/// ```dart
/// DioLogger dioLogger = DioLogger();
/// List<Map<String, dynamic>>? logs = await dioLogger.getLogsByRequestId('12345');
/// List<dynamic> allLogs = await dioLogger.getAllLogs();
/// await dioLogger.clearLogs();
/// ```
///
/// See the individual method documentation for more details on their usage.

class DioLogger extends Interceptor {
  // Unique identifier for each log entry.
  final _uuid = const Uuid();

  /// Logs the request data including the requestId.
  ///
  /// This method is called before making a request.
  /// It generates a unique identifier for the request and logs the request data,
  /// including the requestId, the request method, and the request path.
  /// If the request has a body, it also logs the request body. The requestId is included in the request headers.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Generate a unique identifier for the request
    final requestId = _uuid.v4();

    // Log request data including the requestId
    log('REQUEST[$requestId][${options.method}] => PATH: ${options.path}');
    if (options.data != null) {
      log('REQUEST[$requestId][${options.method}] => BODY: ${options.data}');
    }
    options.headers['requestId'] = requestId; // Include requestId in headers
    handler.next(options);
  }

  /// Logs the error details including the requestId.
  ///
  /// This method is called when an error occurs during a request.
  /// It extracts the requestId from the error response headers if available and logs the error details,
  /// including the requestId, the error message, the response status code (if available),
  /// and the response body (if available). It also retrieves the request data from the
  /// RequestOptions and saves the error logs to shared preferences using the saveLog method.
  ///
  /// Parameters:
  /// - [err]: The DioException object containing the error details.
  /// - [handler]: The error interceptor handler.
  ///
  /// Throws:
  /// - Exception: If there is an error accessing the shared preferences.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Extract requestId from error response headers if available
    final requestId = err.requestOptions.headers['requestId'];

    // Log error details including the requestId
    log('ERROR[$requestId] => ${err.message}');
    if (err.response != null) {
      log('ERROR[$requestId] => RESPONSE[${err.response!.statusCode}] => BODY: ${err.response!.data}');
    }

    // Retrieve request data from RequestOptions
    final requestData = {
      'method': err.requestOptions.method,
      'path': err.requestOptions.uri.toString(),
      'body': err.requestOptions.data,
    };

    // Save error logs to shared preferences
    saveLog(requestId ?? _uuid.v4(), requestData, {
      'error': err.message,
      'statusCode': err.response?.statusCode,
      'body': err.response?.data,
    });

    handler.next(err);
  }

  /// Logs the response data including the requestId.
  ///
  /// This method is called when a response is received.
  /// It extracts the requestId from the response headers and logs the response data,
  /// including the requestId, the response status code, the response path, and the response body.
  /// It also retrieves the request data from the RequestOptions and saves the request and
  /// response logs to shared preferences using the saveLog method.
  ///
  /// Parameters:
  /// - [response]: The response object containing the response data.
  /// - [handler]: The response interceptor handler.
  /// Throws:
  /// - Exception: If there is an error accessing the shared preferences.

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Extract requestId from response headers
    final requestId = response.requestOptions.headers['requestId'];

    // Log response data including the requestId
    log('RESPONSE[$requestId][${response.statusCode}] => PATH: ${response.realUri}');
    log('RESPONSE[$requestId][${response.statusCode}] => BODY: ${response.data}');

    // Retrieve request data from RequestOptions
    final requestData = {
      'method': response.requestOptions.method,
      'path': response.requestOptions.uri.toString(),
      'body': response.requestOptions.data,
    };

    // Save request and response logs to shared preferences
    saveLog(requestId, requestData, {
      'statusCode': response.statusCode,
      'body': response.data,
    });

    handler.next(response);
  }

  /// Saves a log entry to the shared preferences.
  ///
  /// The log entry includes the [requestId], [requestData], [responseData], and the current timestamp.
  /// The log entry is added to the existing logs stored in the 'dio_logs' key in the shared preferences.
  /// If the 'dio_logs' key does not exist, a new empty map is created.
  /// If the [requestId] already exists in the logs, the log entry is appended to the existing list of logs for that [requestId].
  ///
  /// Example usage:
  /// ```dart
  /// saveLog('12345', {'method': 'GET', 'path': '/api/data'}, {'statusCode': 200, 'body': 'Success'});
  /// ```
  ///
  /// Throws an exception if there is an error accessing the shared preferences.
  ///
  void saveLog(String requestId, Map<String, dynamic> requestData,
      Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> logs =
        json.decode(prefs.getString('dio_logs') ?? '{}');
    logs[requestId] ??= [];
    logs[requestId]!.add({
      'request': requestData,
      'response': responseData,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
    prefs.setString('dio_logs', json.encode(logs));
  }

  /// Retrieves logs from shared preferences by the provided [requestId].
  ///
  /// This method retrieves logs stored in the 'dio_logs' key in the shared preferences.
  /// The logs are stored as a map, where the key is the requestId and the value is a list of log entries.
  /// Each log entry is a map containing the request data, response data, and the timestamp of the log entry.
  ///
  /// Parameters:
  /// - [requestId]: The unique identifier of the request to retrieve logs for.
  ///
  /// Returns:
  /// - A list of log entries as maps, where each map represents a log entry.
  /// - `null` if no logs are found for the provided requestId.
  /// - Throws an exception if there is an error accessing the shared preferences.
  ///
  /// Example usage:
  /// ```dart
  /// List<Map<String, dynamic>>? logs = await getLogsByRequestId('12345');
  ///
  Future<List<Map<String, dynamic>>?> getLogsByRequestId(
      String requestId) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = json.decode(prefs.getString('dio_logs') ?? '{}');
    return logs[requestId]?.cast<Map<String, dynamic>>();
  }

  /// Retrieves all logs stored in the shared preferences.
  ///
  /// This method retrieves the logs stored in the 'dio_logs' key in the shared preferences.
  /// If the 'dio_logs' key does not exist, an empty map is returned.
  /// The logs are returned as a list of dynamic objects, where each object represents a log entry.
  /// Each log entry contains the request data, response data, and the timestamp of the log entry.
  ///
  /// Returns:
  /// - A list of dynamic objects representing the logs.
  /// - An empty list if no logs are found in the shared preferences.
  /// - Throws an exception if there is an error accessing the shared preferences.
  Future<List<dynamic>> getAllLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = json.decode(prefs.getString('dio_logs') ?? '{}');
    List<dynamic> allLogs = [];
    logs.forEach((key, value) {
      allLogs.addAll(value);
    });
    return allLogs;
  }

  Future<void> clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('dio_logs');
  }
}
