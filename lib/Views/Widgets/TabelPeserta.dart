import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  int get rowCount => pesertaC.totalPeserta.value;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    Pesertaview data = pesertaC.dataPeserta[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${data.nama}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text("${data.email}"),
          ],
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${data.turnamen}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text("${data.level}"),
          ],
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
          child: Align(
            alignment: Alignment.topLeft,
            child: (data.status! != "Pending" ? const SizedBox() : LoadingBarrier(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if(!pesertaC.klik.value){
                        pesertaC.setujuiPengajuan(data.id!, data.idPBSI!, data.idTurnamen!, data.idUser!);
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
                      child: const Center(child: Text("Setujui")),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      //  turC.turID.value = "${data.id}";
                      // turC.pengajuanTur("Ditolak");
                       if(!pesertaC.klik.value){
                        pesertaC.tolakPengajuan(data.id!, data.idPBSI!, data.idTurnamen!);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: Text("Tolak")),
                    ),
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    ]);
  }
}
