import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../Controllers/AuthController.dart';
import '../Pages/Beranda.dart';
import '../Pages/BlankPage.dart';
import '../Pages/DataPBSI.dart';
import '../Pages/DataTurnamen.dart';
import '../Pages/DataTurnamenPBSI.dart';
import '../Pages/DataBerita.dart';
import '../Pages/DataUsers.dart';
import '../Pages/DataAnggota.dart';
import '../Pages/ListTurnamenPBSI.dart';

class NewSideBar extends StatelessWidget {
  NewSideBar({super.key, required this.index});
  int index;
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    if (authC.authLevel.value == "Root") {
      switch (index) {
        case 0:
          return Beranda();
        case 1:
          return DataPBSI();
        case 2:
          return DataTurnamen();
        case 3:
          return DataBerita();
        case 4:
          return DataUsers();
        case 5:
          return const BlankPage();
        default:
          return Beranda();
      }
    } else if(authC.authLevel.value == "Admin PBSI") {
      switch (index) {
        case 0:
          return Beranda();
        case 1:
          return ListTurnamenPBSI();
        case 2:
          return DataTurnamenPBSI();
        case 3:
          return DataAnggota();
        case 4:
          return DataBerita();
        case 5:
          return const BlankPage();
        default:
          return Beranda();
      }
    }else{
      switch (index) {
        case 0:
          return Beranda();
        default:
          return Beranda();
      }
    }
  }
}
