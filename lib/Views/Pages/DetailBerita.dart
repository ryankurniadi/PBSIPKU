import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Widgets/NavBar.dart';
import '../../Models/Berita.dart';
import '../../Controllers/BeritaController.dart';

class DetailBerita extends StatelessWidget {
  DetailBerita({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: GetBuilder<BeritaController>(
        builder: (beritaC) {
          Berita data = beritaC.detailBerita;
          return Center(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 300),
              children: [
                Text(
                  '${data.judul}',
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    width: Get.width / 1.8,
                    height: 400,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        data.img!,
                        fit: BoxFit.cover,
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(7)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 3),
                        child: Center(
                          child: Text(
                            data.penulis!,
                            style: const TextStyle(color: Colors.white),
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
                          borderRadius: BorderRadius.circular(7)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 3),
                        child: Center(
                          child: Text(
                            DateFormat('EEEE, dd MMMM yyyy', 'id')
                                .format(data.date!),
                            style: const TextStyle(color: Colors.white),
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
                  """${data.isi}""",
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
