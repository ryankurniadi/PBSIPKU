import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../Controllers/PesertaTerdaftarController.dart';
import '../Widgets/TabelPesertaTurnamenPBSI.dart';
import '../Widgets/NavBar.dart';
import '../../Models/Turnamen.dart';
import '../Widgets/LoadingBarrier.dart';
import '../../Controllers/TurnamenContoller.dart';

class DetailTurnamenPBSI extends StatelessWidget {
  DetailTurnamenPBSI({super.key});

  final terC = Get.put(PesertaTerdaftarController());
  final turC = Get.find<TurnamenController>();
  @override
  Widget build(BuildContext context) {
    //terC.getData(turC.turID.value);
    return SafeArea(
        child: Scaffold(
      appBar: NavBar(title: "Detail Turnamen"),
      body: LoadingBarrier(
        child: GetBuilder<TurnamenController>(
          builder: (_) => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              itemCount: turC.dataSatuTur.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Turnamen data = turC.dataSatuTur[index];
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SizedBox(
                                height: 400,
                                width: 350,
                                child: Image(
                                  image: NetworkImage(data.img!),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data.nama!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 35),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.level!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    constraints:const  BoxConstraints(
                                      maxWidth: 400,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        
                                            ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.locationDot,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              data.lokasi!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 15),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.userGroup,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Max Perwakilan: ${data.limit!} Tim",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Pelaksanaan Turnamen : ",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: DateFormat(
                                                'EEEE, dd MMMM yyyy', 'id')
                                            .format(data.date!),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "Batas Pendaftaran : ",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: DateFormat(
                                                'EEEE, dd MMMM yyyy', 'id')
                                            .format(data.batas!),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ]),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text(
                                "Deskripsi Turnamen",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              HtmlWidget(
                                """${data.ket}""",
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: GetBuilder<PesertaTerdaftarController>(
                        builder: (terC) {
                          if (terC.totalPeserta <= 0) {
                            return const Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Data Peserta",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Tidak ada peserta yang terdaftar"),
                                ],
                              ),
                            );
                          }
                          return PaginatedDataTable(
                            source: TabelPesertaTurnamenPBSI(context),
                            header: const Text("Daftar Peserta"),
                            rowsPerPage: (terC.totalPeserta.value >= 7
                                ? 7
                                : terC.totalPeserta.value),
                            showFirstLastButtons: true,
                            showEmptyRows: false,
                            dataRowMaxHeight: 150,
                            columns: const [
                              DataColumn(label: Text('Nama Peserta')),
                              DataColumn(label: Text('Asal PBSI')),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    ));
  }
}
