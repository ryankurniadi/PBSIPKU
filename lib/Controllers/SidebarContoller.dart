import 'package:get/get.dart';

class SidebarController extends GetxController{
  var index = 0.obs;

  changeIndex(int idx){
    index.value = idx;
    update();
  }
}