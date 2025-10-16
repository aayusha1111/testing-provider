import 'package:dio/dio.dart';
import 'package:provider_test/features/core/utils/api_response.dart';
import 'package:provider_test/features/core/utils/view_state.dart';

class ApiService {
  final Dio _dio = Dio();

  /// POST request
  Future<ApiResponse> post(
    String endpoint, {
    dynamic data,
    String? token,
  }) async {
    try {
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await _dio.post(endpoint, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ApiResponse apiResponse = ApiResponse(
          state: ViewState.success,
          data: response.data,
        );
        return apiResponse ;
      } else {
        ApiResponse apiResponse = ApiResponse(state: ViewState.error);
        return apiResponse;
      }
    } on DioException catch (e) {
      ApiResponse apiResponse = ApiResponse(
        state: ViewState.error,
        errorMessage: e.response?.data['error']?.toString() ?? e.message,
      );
      return apiResponse;
    }
  }

  Future<ApiResponse>get ({String?token,String?endpoint})async{
    try {
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await _dio.get(endpoint!);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(state: ViewState.success,data: response.data) ;
      } else {
        return ApiResponse(state: ViewState.error);
      }
    } on DioException catch (e) {
      return ApiResponse(state: ViewState.error,errorMessage: e.message);
    }
    
  }


  Future<ApiResponse> delete(String url, {required String token}) async {
    try {
      if (token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse(
          state: ViewState.success,
          data: response.data.isNotEmpty ? response.data : null,
        );
      } else {
        return ApiResponse(
          state: ViewState.error,
          errorMessage:
              'Failed to delete. Status code: ${response.statusCode}, Message: ${response.statusMessage}',
        );
      }
    } catch (e) {
      return ApiResponse(state: ViewState.error, errorMessage: e.toString());
    }
  }


   Future<ApiResponse> patch(
    String endpoint, {
    dynamic data,
    String? token,
  }) async {
    try {
      if (token != null && token.isNotEmpty) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      }
      final response = await _dio.patch(endpoint, data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ApiResponse apiResponse = ApiResponse(
          state: ViewState.success,
          data: response.data,
        );
        return apiResponse ;
      } else {
        ApiResponse apiResponse = ApiResponse(state: ViewState.error);
        return apiResponse;
      }
    } on DioException catch (e) {
      ApiResponse apiResponse = ApiResponse(
        state: ViewState.error,
        errorMessage: e.response?.data['error']?.toString() ?? e.message,
      );
      return apiResponse;
    }
  }
}
