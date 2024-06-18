import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/NavBar.dart';
import '../Widgets/StatisticBeranda.dart';
import '../../Controllers/PBSIController.dart';
import '../../Controllers/UserController.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/BeritaController.dart';

class Beranda extends StatelessWidget {
  Beranda({super.key});
  final bertaC = Get.put(BeritaController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NavBar(title: "Beranda"),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          children: [
            GetBuilder<AuthController>(builder: (authC) {
              if (authC.authLevel.value == "Root") {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GetBuilder<PBSIController>(builder: (pbsiC) {
                          return StatisticBeranda(
                            totalData: pbsiC.totalPBSI.value,
                            namaData: "Data PBSI",
                            icon: Icons.sports,
                            gradien: const LinearGradient(
                              colors: [Color(0xffec557b), Color(0xfff70202)],
                              stops: [0.25, 0.75],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          );
                        }),
                        const SizedBox(
                          width: 15,
                        ),
                        GetBuilder<TurnamenController>(builder: (turC) {
                          return StatisticBeranda(
                            totalData: turC.totalTur.value,
                            namaData: "Data Turnamen",
                            icon: Icons.tour,
                            gradien: const LinearGradient(
                              colors: [Color(0xff9400d3), Color(0xff4b0082)],
                              stops: [0, 1],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          );
                        }),
                        const SizedBox(
                          width: 15,
                        ),
                        GetBuilder<UserController>(builder: (userC) {
                          return StatisticBeranda(
                            totalData: userC.totalUser.value,
                            namaData: "Data Users",
                            icon: Icons.person,
                            gradien: const LinearGradient(
                              colors: [Color(0xfffdc830), Color(0xfff37335)],
                              stops: [0, 1],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
            const Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Timeline",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
