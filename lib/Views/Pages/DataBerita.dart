import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Routes/PageNames.dart';
import '../Widgets/NavBar.dart';

class DataBerita extends StatelessWidget {
  DataBerita({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: NavBar(title: "Data Berita"),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.toNamed(PageNames.AddBerita);
                  },
                  child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff197500), Color(0xff007529)],
                            stops: [0, 1],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "TAMBAH BERITA",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      )))),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }
}
