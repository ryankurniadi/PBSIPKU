import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/AuthController.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  NavBar({super.key, 
    required this.title,
  });
  final String title;
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      elevation: 2,
      
      actions: [IconButton(onPressed: () {
        Get.defaultDialog(
          middleText: "Apakah anda yakin untuk log out?",
          textCancel: "Tidak",
          title: "Konfirmasi Log Out",
          textConfirm: "Iya",
          onConfirm: ()=>authC.logout(),
        );
      }, icon: const Icon(Icons.logout))],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
