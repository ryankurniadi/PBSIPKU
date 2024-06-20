import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/Turnamen.dart';
import '../../Controllers/PBSITurController.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Routes/PageNames.dart';

class TabelTurnamenPBSI extends DataTableSource {
  final BuildContext context;
  TabelTurnamenPBSI(this.context);
  final turC = Get.find<PBSITurController>();
  final turAsliC = Get.find<TurnamenController>();

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => turC.dataTurnamen.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    Turnamen data = turC.dataTurnamen[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(
        Image(
          image: NetworkImage(
            data.img!,
          ),
          width: 120,
          height: 180,
        ),
      ),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${data.nama}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
               const SizedBox(
                    height: 10,
                  ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
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
                      padding:
                          const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
                      child: Center(
                        child: Text(
                          NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp. ', decimalDigits: 0)
                              .format(data.biaya!),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
               const SizedBox(
                    height: 5,
                  ),
              Row(
                children: [
                  Container(
                        
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
                          child: Center(
                            child: Text(
                              (data.tipe! == "Publik" ? "Publik": "Internal PBSI"),
                              style: const TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Batas Pendaftaran",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(DateFormat('EEEE, dd MMMM yyyy', 'id').format(data.batas!)),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Pelaksanaan Turnamen",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(DateFormat('EEEE, dd MMMM yyyy', 'id').format(data.date!)),
            ],
          ),
        ),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
                width: 150,
                child: Text(
                  "${data.lokasi}",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ))),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 70,
              child: Text(
                "${data.status}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (data.status == "Disetujui"
                      ? Colors.green
                      : (data.status == "Pending" ? Colors.amber : Colors.red)),
                ),
              ),
            )),
      )),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Align(
              alignment: Alignment.topLeft,
              child: (data.status == "Ditolak"
                  ? SizedBox()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            turAsliC.turID.value = "${data.id}";
                            await turAsliC.getSingleTur();
                            Get.toNamed(PageNames.DetailTurnamen);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                            ),
                            child: const Center(
                                child: Icon(
                              Icons.remove_red_eye,
                              size: 20,
                              color: Colors.white,
                            )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            turC.turID.value = "${data.id}";
                            await turC.getSingleTur();
                            Get.toNamed(PageNames.EditTurnamenPBSI);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: const Center(
                                child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            )),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        (data.status == "Disetujui" && data.tipe == "Publik"
                            ? const SizedBox()
                            : InkWell(
                                onTap: () {
                                  Get.defaultDialog(
                                      title: "Konfirmasi Hapus",
                                      content: Text(
                                          "Apakah kamu yakin untuk menghapus data ${data.nama}?"),
                                      barrierDismissible: false,
                                      cancel: TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text("Tidak")),
                                      confirm: TextButton(
                                          onPressed: () async{
                                            
                                            if (!Get.isSnackbarOpen) {
                                              await turAsliC.deleteData(data.id!, data.img!);
                                              turC.getData();
                                            }
                                          },
                                          child: const Text("Iya")));
                                },
                                child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration:
                                        const BoxDecoration(color: Colors.red),
                                    child: const Center(
                                        child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.white,
                                    )))))
                      ],
                    ))),
        ),
      ),
    ]);
  }
}
