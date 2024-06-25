import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Widgets/LoadingBarrier.dart';
import '../../Models/PesertaView.dart';
import '../../Controllers/PesertaTurController.dart';

class TabelPeserta extends DataTableSource {
  final BuildContext context;
  TabelPeserta(this.context);

  final pesertaC = Get.find<PesertaTurController>();

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => pesertaC.dataPeserta.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    Pesertaview data = pesertaC.dataPeserta[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data.nama}",
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text("No. HP : ${data.hp}"),
                ],
              ),
              const SizedBox(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${data.nama2}",
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Text("No. HP : ${data.hp2}"),
                ],
              ),
            ],
          ),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: 100,
          child: Image(
            image: NetworkImage(
              data.img!,
            ),
            width: 70,
            height: 180,
          ),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${data.turnamen}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(height: 3,),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 13),
                      child: Center(
                        child: Text(
                          data.level!,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 13),
                      child: Center(
                        child: Text(
                          NumberFormat.currency(
                                  locale: 'id',
                                  symbol: 'Rp. ',
                                  decimalDigits: 0)
                              .format(data.biaya!),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "${data.status}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: (data.status == "Disetujui"
                    ? Colors.green
                    : (data.status == "Pending" ? Colors.amber : Colors.red)),
              ),
            )),
      )),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.topLeft,
              child: (data.status! != "Pending"
                  ? const SizedBox()
                  : LoadingBarrier(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              if (!pesertaC.klik.value) {
                                pesertaC.setujuiPengajuan(
                                    data.id!,
                                    data.idPBSI!,
                                    data.idTurnamen!,
                                    data.idUser!,
                                    data.idUser2!,
                                    
                                    );
                              }
                              //  turC.turID.value = "${data.id}";
                              //turC.pengajuanTur("Disetujui");
                            },
                            child: Container(
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Center(child: Text("Setujui",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              //  turC.turID.value = "${data.id}";
                              // turC.pengajuanTur("Ditolak");
                              if (!pesertaC.klik.value) {
                                pesertaC.tolakPengajuan(
                                    data.id!, data.idPBSI!, data.idTurnamen!);
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Center(child: Text("Tolak",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),)),
                            ),
                          ),
                        ],
                      ),
                    )),
            ),
          ),
        ),
      ),
    ]);
  }
}
