import 'package:flutter/material.dart';
import 'package:provider_test/features/core/utils/api_response.dart';
import 'package:provider_test/features/core/utils/constants/app_api.dart';
import 'package:provider_test/features/core/utils/services/api_service.dart';
import 'package:provider_test/features/core/utils/view_state.dart';
import 'package:provider_test/features/login/model/login.dart';
import 'package:provider_test/features/login/model/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginProvider extends ChangeNotifier {


   List<String>genderList=["male","female","others"];
   
   List<String>roleList=["admin","teacher","student"];
  

   String?email,username,fname,contactno,password,gender,role;

   String?token;

   readTokenFromSharedPrefences()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
   }


  List<String>subjectList=["DBMS","OOP","IIT","Microprpcessor","Computer Network"];
   String?title,description,subjectid,semester,faculty;

   List<String>semesterList=["First","Second","Third","Fourth","Fifth","Sixth","Seventh","Eight"];
   List<String>facultyList=["BCA","CSIT","BIM"];

  ViewState loginStatus=ViewState.idle;
  String? errorMessage;
  ApiService service=ApiService();

  setLoginState(ViewState value){
    loginStatus=value;
    notifyListeners();
  }

  Future<void> login() async {
  setLoginState(ViewState.loading);

  LoginUser login = LoginUser(
    email: email,
    password: password,
    deviceToken: "xyz",
  );

  ApiResponse response = await service.post(
    AppApi.login,
    data: login.toJson(),
  );

  if (response.state == ViewState.success) {
    setLoginState(ViewState.success);

    // Extract token and role from response
    String? token = response.data['data']['token'];
    String? role = response.data['data']['user']['role'];

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (token != null) {
      await prefs.setString('auth_token', token);
    }

    if (role != null) {
      await prefs.setString('user_role', role);
    }

  } else if (response.state == ViewState.error) {
    errorMessage = response.errorMessage;
    setLoginState(ViewState.error);
  }
}



  bool passwordVisibility = false;

  password1() {
    if (passwordVisibility) {
      passwordVisibility = false;
    } else {
      passwordVisibility = true;
    }
    notifyListeners();
  }

ViewState singupStatus=ViewState.idle;

setSingnupState(ViewState value){
    singupStatus=value;
    notifyListeners();
  }

    Future<void>signup() async{
    setSingnupState(ViewState.loading);
    Signup signup=Signup(email:email,password:password,username: username,name:fname,gender: gender,role: role,contact: contactno);
    ApiResponse response=await service.post(
      AppApi.createUser,
      data: signup.toJson());

      if(response.state==ViewState.success){
        setSingnupState(ViewState.success);
       
      }
      else if(response.state==ViewState.error){
        errorMessage=response.errorMessage;
        setSingnupState(ViewState.error);


      }
  }



  

  
}
