import 'package:get/get.dart';


class InputHideController extends GetxController{
  var isHide = false.obs;
  var isPublic = true.obs;
  

  inputChange(bool change){
    isHide.value = change;
    update();
  }
  publicChange(bool change){
    isPublic.value = change;
    update();
  }

  
}