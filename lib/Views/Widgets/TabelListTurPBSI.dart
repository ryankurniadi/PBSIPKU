import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/Turnamen.dart';
import '../../Controllers/ListTurPBSIController.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Routes/PageNames.dart';

class TabelListTurPBSI extends DataTableSource {
  final BuildContext context;
  TabelListTurPBSI(this.context);
  final turC = Get.find<ListTurPBSIController>();
  final turAsliC = Get.find<TurnamenController>();

  @override
  DataRow? getRow(int index) {
    Turnamen data = turC.dataTurnamen[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Image(
            image: NetworkImage(
              data.img!,
            ),
            width: 180,
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
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
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
                    const SizedBox(width: 5,),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 13),
                        child: Center(
                          child: Text(
                            NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0).format(data.biaya!),
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
        )),
        DataCell(Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Align(
              alignment: Alignment.topLeft, child: SizedBox(
                width: 200,
                child: Text("${data.lokasi}", maxLines: 4, overflow: TextOverflow.ellipsis,))),
        )),
        DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              width: 150,
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () async{
                        turAsliC.turID.value = "${data.id}";
                        await turAsliC.getSingleTur();
                      Get.toNamed(PageNames.DetailTurnamenPBSI);
                        //turC.pengajuanTur("Disetujui");
                      },
                      child: Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(child: Text("Detail Turnamen")),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Get.defaultDialog(
                          title: "Pilih Anggota",

                        );
                      },
                      child: Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(child: Text("Daftarkan Anggota")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => turC.dataTurnamen.length;

  @override
  int get selectedRowCount => 0;
}
