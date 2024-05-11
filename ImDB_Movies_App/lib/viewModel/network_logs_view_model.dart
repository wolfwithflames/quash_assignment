import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:learning_mvvm/data/response/api_response.dart';
import 'package:quash_assignment/crash_logger.dart';
import 'package:quash_assignment/dio_logger.dart';

class NetworkLogsViewModel with ChangeNotifier {
  ApiResponse<List> _apiResponse = ApiResponse.loading();

  ApiResponse<List> get apiResponse => _apiResponse;

  Future<void> fetchNetworkLogs() async {
    _setApiResponse(ApiResponse.loading());

    try {
      final value = await DioLogger().getAllLogs();
      log(value.toString());
      _setApiResponse(ApiResponse.completed(value));
      debugPrint('Fetched Movies');
    } catch (error, stackTrace) {
      debugPrint('Error Occured');
      debugPrint(error.toString());
      CrashLogger.logError(error, stackTrace);
      _setApiResponse(ApiResponse.error(error.toString()));
    }
  }

  void _setApiResponse(ApiResponse<List> response) {
    _apiResponse = response;
    notifyListeners();
  }
}
