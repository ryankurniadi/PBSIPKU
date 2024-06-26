import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pbsipku/Controllers/AuthController.dart';

import '../../Controllers/PesertaTerdaftarController.dart';
import '../../Models/Turnamen.dart';
import '../../Controllers/ListTurPBSIController.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Controllers/AuthController.dart';
import '../../Models/User.dart';
import '../../Routes/PageNames.dart';

class TabelListTurPBSI extends DataTableSource {
  final BuildContext context;
  TabelListTurPBSI(this.context);
  final turC = Get.find<ListTurPBSIController>();
  final authC = Get.find<AuthController>();
  final turAsliC = Get.find<TurnamenController>();
  final terC = Get.put(PesertaTerdaftarController());

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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
              alignment: Alignment.topLeft,
              child: SizedBox(
                  width: 200,
                  child: Text(
                    "${data.lokasi}",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ))),
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
                      onTap: () async {
                        turAsliC.turID.value = "${data.id}";
                        await turAsliC.getSingleTur();
                        await terC.getData("${data.id}");
                        Get.toNamed(PageNames.DetailTurnamenPBSI);
                        //turC.pengajuanTur("Disetujui");
                      },
                      child: Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(child: Text("Detail Turnamen",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        turC.isAllPemainSelected.value = true;
                        turC.player1SelectNotify(false);
                        await turC.checkUserTerdaftar(
                            authC.authpbsi.value, data.id!, data.level!);
                        Get.dialog(AlertDialog(
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Pilih anggota yang ingin didaftarkan", style: TextStyle(
                                fontSize: 15,
                              ),),
                              Text(data.nama!, style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                              ),)
                            ],
                          ),
                          actions: [
                            TextButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.green)),
                                onPressed: () async{
                                  turC.isAllPemainSelected.value = true;
                                  await turC.daftarkanUser(data.id!, authC.authpbsi.value);
                                },
                                child: const Text(
                                  "Daftar Anggota",
                        style: TextStyle(
                            color: Colors.white,),
                                ))
                          ],
                          content: GetBuilder<ListTurPBSIController>(
                            builder: (_) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder()),
                                    hint: const Text("Pemain 1"),
                                    onChanged: (value) {
                                      turC.player1SelectNotify(true);
                                      turC.pemain1.value = value;
                                      turC.hideSelectedUser(value);
                                    },
                                    validator: (value){
                                      if(value == null){
                                        return "Pemain tidak boleh kosong";
                                      }
                                    },
                                    onTap: () {
                                      turC.player1SelectNotify(false);
                                    },
                                    items: List<DropdownMenuItem>.generate(
                                        turC.pesertaBelumTerdaftar.length,
                                        (index) {
                                      User data =
                                          turC.pesertaBelumTerdaftar[index];
                                      return DropdownMenuItem(
                                        value: "${data.id}",
                                        child: Text("${data.nama}"),
                                      );
                                    }),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (turC.isPemain1Selected.value)
                                    DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()),
                                      hint: const Text("Pemain 2"),
                                      onChanged: (value) {
                                        //turC.player1SelectNotify(true);
                                        turC.pemain2.value = value;
                                      },
                                      validator: (value){
                                      if(value == null){
                                        return "Pemain tidak boleh kosong";
                                      }
                                    },
                                      items: List<DropdownMenuItem>.generate(
                                          turC.pesertaBelumTerdaftar2.length,
                                          (index) {
                                        User data =
                                            turC.pesertaBelumTerdaftar2[index];
                                        return DropdownMenuItem(
                                          value: "${data.id}",
                                          child: Text("${data.nama}"),
                                        );
                                      }),
                                    ),

                                   Obx((){
                                    if(!turC.isAllPemainSelected.value){
                                      return  const Text("Data pemain tidak boleh kosong", style: TextStyle(color: Colors.red),);
                                    }
                                    return const SizedBox();
                                   })                                ],
                              );
                            },
                          ),
                        ));
                      },
                      child: Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(child: Text("Daftarkan Anggota",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),)),
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
