import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pbsipku/Routes/PageNames.dart';

import '../../Models/Berita.dart';
import '../Widgets/NavBar.dart';
import '../Widgets/StatisticBeranda.dart';
import '../../Controllers/PBSIController.dart';
import '../../Controllers/UserController.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Controllers/AuthController.dart';
import '../../Controllers/BeritaController.dart';

class Beranda extends StatelessWidget {
  Beranda({super.key});
  final beritaC = Get.put(BeritaController());
  @override
  Widget build(BuildContext context) {
    beritaC.getData();
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
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Timeline",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            GetBuilder<BeritaController>(
              builder: (_) {
                if (beritaC.totalBeritaAdmin.value <= 0) {
                  return const Center(
                    child: Text("Tidak ada Berita"),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  itemCount: beritaC.totalBeritaAdmin.value,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Berita data = beritaC.dataBeritaAdmin[index];
                    String isiBerita = data.isi!;
                    if(isiBerita.length >= 600){
                      isiBerita = "${isiBerita.substring(0, 600)}...";
                    }
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 300,
                              width: 500,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  data.img!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.judul!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 3),
                                        child: Center(
                                          child: Text(
                                            data.penulis!,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 3),
                                        child: Center(
                                          child: Text(
                                            DateFormat(
                                                    'EEEE, dd MMMM yyyy', 'id')
                                                .format(data.date!),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                HtmlWidget(
                                """$isiBerita""",
                                
                              ),
                              const SizedBox(
                                  height: 3,
                                ),
                              if(data.isi!.length >= 600)
                              InkWell(onTap: ()async{
                                await beritaC.getDetailBerita(data.id!);
                                Get.toNamed(PageNames.DetailBerita);
                              }, child: const Text("Baca Selengkapanya...." , style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold
                              ),)) 
                              ],
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
