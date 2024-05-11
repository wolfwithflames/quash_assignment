import 'package:flutter/material.dart';
import 'package:learning_mvvm/data/response/api_response.dart';
import 'package:learning_mvvm/model/movies_ilst_model.dart';
import 'package:learning_mvvm/repo/home_repo.dart';
import 'package:quash_assignment/crash_logger.dart';

class HomeViewModel with ChangeNotifier {
  ApiResponse<UsersListModel> _apiResponse = ApiResponse.loading();
  HomeRepo _homeRepo = HomeRepo();

  ApiResponse<UsersListModel> get apiResponse => _apiResponse;

  Future<void> fetchMoviesList() async {
    _setApiResponse(ApiResponse.loading());

    try {
      final value = await _homeRepo.fetchMoviesList();
      _setApiResponse(ApiResponse.completed(value));
      debugPrint('Fetched Movies');
    } catch (error, stackTrace) {
      debugPrint('Error Occured');
      debugPrint(error.toString());
      CrashLogger.logError(error, stackTrace);
      _setApiResponse(ApiResponse.error(error.toString()));
    }
  }

  void _setApiResponse(ApiResponse<UsersListModel> response) {
    _apiResponse = response;
    notifyListeners();
  }
}
