import 'package:dio/dio.dart';

import '../components/statics.dart';
import '../models/country_model.dart';
import '../models/daily_model.dart';
import '../models/prayer_time_model.dart';
import '../models/state_model.dart';
import '../models/town_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._interval();
  factory ApiService() => _instance;
  ApiService._interval();

  late final Dio _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 8),
        receiveTimeout: Duration(seconds: 6),
      ),
    );
  }

  Future<List<CountryModel>> getCountries() async {
    List<CountryModel> countryList = [];
    try {
      final response = await _dio.get(countriesEP);
      if (response.statusCode == 200) {
        var result = response.data as List;
        countryList = result.map((e) => CountryModel.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
    return countryList;
  }

  Future<List<StateModel>> getStates(int countryId) async {
    List<StateModel> stateList = [];
    try {
      final response = await _dio.post(statesEP, data: {'countryId': countryId});
      if (response.statusCode == 200) {
        var result = response.data as List;
        stateList = result.map((e) => StateModel.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
    return stateList;
  }

  Future<List<TownModel>> getTowns(int stateId) async {
    List<TownModel> townList = [];
    try {
      final response = await _dio.post(townsEP, data: {'stateId': stateId});
      if (response.statusCode == 200) {
        var result = response.data as List;
        townList = result.map((e) => TownModel.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
    return townList;
  }

  Future<List<PrayerTimeModel>> getPrayerTimes(int townId) async {
    List<PrayerTimeModel> prayerTimeList = [];
    try {
      final response = await _dio.post(prayerTimeEP, data: {'townId': townId});
      if (response.statusCode == 200) {
        var result = response.data as List;
        prayerTimeList = result.map((e) => PrayerTimeModel.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
    return prayerTimeList;
  }

  Future<DailyModel> getDaily() async {
    DailyModel daily = DailyModel();
    try {
      final response = await _dio.get(dailyEP);
      if (response.statusCode == 200) {
        daily = DailyModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
    return daily;
  }

  ApiException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(message: 'Bağlantı zaman aşımına uğradı.');
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Yanıt zaman aşımına uğradı.');
      case DioExceptionType.badResponse:
        return ApiException(
          message: 'Sunucu hatası: ${e.response?.statusCode}',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ApiException(message: 'İnternet bağlantısı yok.');
      default:
        return ApiException(message: e.message ?? 'Bilinmeyen bir hata oluştu.');
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message';
}
