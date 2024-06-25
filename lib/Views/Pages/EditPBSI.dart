import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Widgets/NavBar.dart';
import '../../Controllers/PBSIController.dart';

class EditPBSI extends StatelessWidget {
  EditPBSI({super.key});
  final _formKey = GlobalKey<FormState>();
  final pbsiC = Get.find<PBSIController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NavBar(
          title: "Perbaharui Data PBSI Pekanbaru",
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 3),
              child: Form(
                key: _formKey,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 50),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Nama PBSI",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: pbsiC.nama.value,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Nama Wajib Di Isi";
                            }
                          },
                          onSaved: (value) {
                            pbsiC.nama.value = value!;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Text(
                              "Alamat",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          initialValue: pbsiC.alamat.value,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Alamat Wajib Di Isi";
                            }
                          },
                          onSaved: (value) {
                            pbsiC.alamat.value = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              pbsiC.editData(pbsiC.id.value);
                            }
                          },
                          child: Container(
                            width: Get.width / 1.1,
                            height: 60,
                            decoration: BoxDecoration(color: Colors.green,
                      borderRadius: BorderRadius.circular(10),),
                            child: const Center(
                              child: Text("Perbaharui Data PBSI",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
