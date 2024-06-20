import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/PesertaView.dart';
import '../../Controllers/PesertaTerdaftarController.dart';

class TabelPesertaTurnamen extends DataTableSource {
  final BuildContext context;
  TabelPesertaTurnamen(this.context);

  final terC = Get.find<PesertaTerdaftarController>();

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => terC.dataTerdaftar.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    Pesertaview data = terC.dataTerdaftar[index];
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
        child: Align(
            alignment: Alignment.topLeft, child: Text("${data.namaPBSI}")),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Align(
            alignment: Alignment.topLeft,
            child: (data.pembayaran == "Lunas")
                ? Text("${data.pembayaran}",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold))
                : Text("${data.pembayaran}",
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold))),
      )),
      DataCell(
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  if (data.pembayaran! != "Lunas")
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            //  turC.turID.value = "${data.id}";
                            // turC.pengajuanTur("Ditolak");
                            terC.lunasiPendaftaran(data.id!, data.idTurnamen!);
                          },
                          child: Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5)),
                            child:
                                const Center(child: Text("Pembayaran Lunas")),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  InkWell(
                    onTap: () {
                      //  turC.turID.value = "${data.id}";
                      // turC.pengajuanTur("Ditolak");
                      terC.deletePeserta(data.id!, data.idTurnamen!);
                    },
                    child: Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: Text("Hapus Peserta")),
                    ),
                  ),
                ],
              ),
            )),
      ),
    ]);
  }
}
