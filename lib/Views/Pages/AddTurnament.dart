import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../Widgets/NavBar.dart';
import '../Widgets/LoadingBarrier.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Controllers/InputHideController.dart';
import '../../Controllers/LoadingController.dart';

class AddTurnamner extends StatelessWidget {
  AddTurnamner({super.key});
  final _formKey = GlobalKey<FormState>();
  final turC = Get.find<TurnamenController>();
  final loadC = Get.find<LoadingController>();
  final inputC = Get.put(InputHideController());
  HtmlEditorController controller = HtmlEditorController();

  Future<void> _datePick(BuildContext context) async {
    DateTime? datepick = await showDatePicker(
        context: context,
        initialDate: turC.date.value,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
        onDatePickerModeChange: (value) {
          print("get data");
        });
    inputC.inputChange(false);
    if (datepick == null) {
      turC.setDate(DateTime.now());
    } else {
      turC.setDate(datepick);
    }
  }

  Future<void> _datePick2(BuildContext context) async {
    DateTime? datepick = await showDatePicker(
        context: context,
        initialDate: turC.date2.value,
        firstDate: DateTime.now(),
        lastDate: turC.date.value);
    inputC.inputChange(false);
    if (datepick == null) {
      turC.setDate2(DateTime.now());
    } else {
      turC.setDate2(datepick);
    }
  }

  @override
  Widget build(BuildContext context) {
    var prev = turC.imageBytes;
    return SafeArea(
        child: Scaffold(
      appBar: NavBar(title: "Tambah Turnamen"),
      body: GetBuilder<TurnamenController>(builder: (turC) {
        return LoadingBarrier(
            child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Nama Turnamen",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Nama Turnamen",
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data Wajib Di Isi";
                                  }
                                },
                                onSaved: (value) {
                                  turC.nama.value = value!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "Contact Person",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                keyboardType: TextInputType
                                    .number, // Keyboard type untuk angka
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter
                                      .digitsOnly // Formatter untuk angka saja
                                ],
                                decoration: const InputDecoration(
                                    hintText: "Contact Person",
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data Wajib Di Isi";
                                  }
                                },
                                onSaved: (value) {
                                  turC.kontak.value = value!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "Batas Perwakilan Tiap PBSI",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                  TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                      if (int.tryParse(newValue.text) ==
                                          0) {
                                        return oldValue;
                                      }
                                      return newValue;
                                    },
                                  )
                                ],
                                decoration: const InputDecoration(
                                    hintText: "Inputkan Angka",
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data Wajib Di Isi";
                                  }
                                  int? number = int.tryParse(value!);
                                },
                                onSaved: (value) {
                                  int? number = int.tryParse(value!);
                                  turC.limit.value = number!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "Level Turnamen",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                                items: const [
                                  DropdownMenuItem(
                                    value: "Level A",
                                    child: Text("Level A"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Level B",
                                    child: Text("Level B"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Level C",
                                    child: Text("Level C"),
                                  ),
                                  DropdownMenuItem(
                                    value: "Level D",
                                    child: Text("Level D"),
                                  )
                                ],
                                value: "Level A",
                                onChanged: (value) {
                                  turC.level.value = value!;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "Tanggal Turnamen",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: "${turC.dateShow}",
                                  suffix: const Icon(Icons.calendar_month),
                                ),
                                readOnly: true,
                                onTap: () {
                                  _datePick(context);
                                  inputC.inputChange(true);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "Batas Pendaftaran",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "${turC.dateShow2}",
                                  border: const OutlineInputBorder(),
                                  suffix: const Icon(Icons.calendar_month),
                                ),
                                readOnly: true,
                                onTap: () {
                                  _datePick2(context);
                                  inputC.inputChange(true);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  Text(
                                    "Lokasi Turnamen",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Lokasi Turnamen",
                                    border: OutlineInputBorder()),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Data Wajib Di Isi";
                                  }
                                },
                                onSaved: (value) {
                                  turC.lokasi.value = value!;
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "Brosur Turnamen",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Obx(() {
                                if (prev.value != null &&
                                    prev.value!.isNotEmpty) {
                                  return InkWell(
                                    onTap: () async {
                                      turC.pickImage();
                                    },
                                    child: Image.memory(
                                      prev.value!,
                                      width: 400,
                                      height: 500,
                                    ),
                                  );
                                } else {
                                  return InkWell(
                                      onTap: () async {
                                        turC.pickImage();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  10),
                                        ),
                                        height: 500,
                                        width: 400,
                                        child: const Center(
                                          child: Icon(Icons.photo),
                                        ),
                                      ));
                                }
                              }),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Deskripsi Lengkap",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    GetBuilder<InputHideController>(builder: (inputC) {
                      if (inputC.isHide.value) {
                        return const SizedBox();
                      } else {
                        return Container(
                          color: Colors.grey.shade200,
                          child: HtmlEditor(
                            controller: controller,
                            htmlEditorOptions: HtmlEditorOptions(
                              hint:
                                  "Masukan deskripsi lengkap (Hadiah, Peraturan Dll.)",
                              initialText: turC.ket.value,
                              characterLimit: 1000,
                              autoAdjustHeight: true,
                            ),
                            htmlToolbarOptions: const HtmlToolbarOptions(
                                gridViewHorizontalSpacing: 2,
                                toolbarType: ToolbarType.nativeGrid,
                                allowImagePicking: false,
                                defaultToolbarButtons: [
                                  FontButtons(
                                      clearAll: false,
                                      strikethrough: false,
                                      subscript: false,
                                      superscript: false),
                                  ColorButtons(),
                                  ParagraphButtons(
                                      textDirection: false,
                                      lineHeight: false,
                                      decreaseIndent: false,
                                      increaseIndent: false,
                                      caseConverter: false),
                                  ListButtons(listStyles: false),
                                ]),
                            otherOptions: const OtherOptions(
                              height: 250,
                            ),
                          ),
                        );
                      }
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            loadC.changeLoading(true);
                            if (prev.value != null) {
                              var txt = await controller.getText();
                              if (txt.contains('src=\"data:')) {
                                txt =
                                    '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                              }
                              turC.ket.value = txt;
                              turC.addData(prev.value!);
                            } else {
                              Get.snackbar(
                                  "Gagal", "Gambar Baner Tidak Boleh Kosong",
                                  backgroundColor: Colors.red);
                            }
                          }
                        },
                        child: const Text("Tambah Data")),
                  ],
                ),
              ),
            ),
          ],
        ));
      }),
    ));
  }
}
