import 'package:flutter/material.dart';
import 'package:quash_assignment/crash_logger.dart';

import '../data/network/base_api_service.dart';
import '../data/network/network_api_service.dart';
import '../model/movies_ilst_model.dart';
import '../res/app_url.dart';

class HomeRepo {
  BaseApiService _apiService = NetworkApiService();

  Future<UsersListModel> fetchMoviesList() async {
    try {
      dynamic response = await _apiService.getGetApiResponse(AppUrl.users);
      debugPrint("Api Hitted");
      return UsersListModel.fromJson(response);
    } catch (error, stackTrace) {
      CrashLogger.logError(error, stackTrace);
      throw error.toString();
    }
  }
}
