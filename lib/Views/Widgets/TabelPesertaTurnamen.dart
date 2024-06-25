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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.nama}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text("No. HP : ${data.hp}"),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${data.nama2}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text("No. HP : ${data.hp2}"),
              ],
            ),
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
                           Get.defaultDialog(
                            middleText: "Apakah Anda ingin Mengubah Status Peserta ( ${data.nama} & ${data.nama2} ) Pembayaran Menjadi \"Lunas\"??",
                            textConfirm: "Iya",
                            textCancel: "Tidak",
                            onConfirm: (){
                              terC.lunasiPendaftaran(data.id!, data.idTurnamen!);
                              Get.back();
                            }
                           );
                          },
                          child: Container(
                            height: 40,
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5)),
                            child:
                                const Center(child: Text("Pembayaran Lunas",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),)),
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
                      Get.defaultDialog(
                        textCancel: 'Tidak',
                        textConfirm: 'Iya',
                        middleText: 'APakah Anda Ingin Menghapus ( ${data.nama} & ${data.nama2} ) dari daftar peserta?',
                        onConfirm: (){
                          terC.deletePeserta(data.id!, data.idTurnamen!);
                          Get.back();
                        }
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: const Center(child: Text("Hapus Peserta",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ],
              ),
            )),
      ),
    ]);
  }
}
