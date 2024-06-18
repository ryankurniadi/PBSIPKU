import 'package:get/get.dart';

import '../Controllers/PBSIController.dart';
import '../Controllers/AuthController.dart';
import '../Controllers/LoadingController.dart';
import '../Controllers/SidebarContoller.dart';
import '../Controllers/TurnamenContoller.dart';
import '../Controllers/UserController.dart';
import '../Controllers/BeritaController.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoadingController());
    Get.put(SidebarController());
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(PBSIController());
    Get.put(TurnamenController());
    Get.put(BeritaController());
    
  }
}
