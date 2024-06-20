import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/Berita.dart';
import '../../Controllers/BeritaController.dart';
import '../../Routes/PageNames.dart';

class TabelBerita extends DataTableSource {
  final BuildContext context;
  TabelBerita(this.context);
  final beritaC = Get.find<BeritaController>();

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => beritaC.dataPerAdmin.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    Berita data = beritaC.dataPerAdmin[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(
        Image(
          image: NetworkImage(
            data.img!,
          ),
          width: 180,
          height: 100,
        ),
      ),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: Text(
                "${data.judul}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            const SizedBox(height: 7,),
            Container(
              width: 190,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(7)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                child: Center(
                  child: Text(
                    DateFormat('EEEE, dd MMMM yyyy', 'id').format(data.date!),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    beritaC.editImgChanger(false);
                    beritaC.isNewImg.value = false;
                    await beritaC.getSingleBerita(data.id!);
                    Get.toNamed(PageNames.EditBerita);
                    //turC.turID.value = "${data.id}";
                    //await turC.getSingleTur();
                    //Get.toNamed(PageNames.EditTurnamen);
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
                InkWell(
                    onTap: () {
                      Get.defaultDialog(
                          title: "Konfirmasi Hapus",
                          content: Text(
                              "Apakah kamu yakin untuk menghapus data ${data.judul}?"),
                          barrierDismissible: false,
                          cancel: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("Tidak")),
                          confirm: TextButton(
                              onPressed: () {
                                if (!Get.isSnackbarOpen) {
                                  //turC.deleteData("${data.id}", "${data.img}");
                                  beritaC.deleteBerita(data.id!, data.img!);
                                }
                              },
                              child: const Text("Iya")));
                    },
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(color: Colors.red),
                        child: const Center(
                            child: Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.white,
                        )))),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
