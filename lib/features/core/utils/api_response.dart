import 'package:provider_test/features/core/utils/view_state.dart';

class ApiResponse{
  ViewState? state;
  String? errorMessage;
  dynamic data;
  ApiResponse({this.state,this.errorMessage,this.data});
}