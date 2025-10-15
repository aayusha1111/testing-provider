import 'package:flutter/material.dart';

class TestProvider extends ChangeNotifier {
  int a=0;
  bool passwordVisibilty=false;

  increaseValue(){
    a++;
    notifyListeners();
  }

  decreaseValue(){
    a--;
    notifyListeners();  }

  

    showPassword(){
      if(passwordVisibilty){
        passwordVisibilty=false;
      }
      else{
        passwordVisibilty=true;
      }
      notifyListeners();
    }


}
