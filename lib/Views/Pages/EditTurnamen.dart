import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../Widgets/NavBar.dart';
import '../Widgets/LoadingBarrier.dart';
import '../../Models/Turnamen.dart';
import '../../Controllers/TurnamenContoller.dart';
import '../../Controllers/InputHideController.dart';
import '../../Controllers/LoadingController.dart';

class EditTurnamen extends StatelessWidget {
  EditTurnamen({super.key});

final _formKey = GlobalKey<FormState>();
  final turC = Get.find<TurnamenController>();
  final loadC = Get.find<LoadingController>();
  final inputC = Get.put(InputHideController());
  HtmlEditorController controller = HtmlEditorController();

  Future<void> _datePick(BuildContext context, DateTime init) async {
    DateTime? datepick = await showDatePicker(
        context: context,
        initialDate: init,
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

  Future<void> _datePick2(BuildContext context, DateTime init) async {
    DateTime? datepick = await showDatePicker(
        context: context,
        initialDate: init,
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
      appBar: NavBar(title: "Edit Turnamen"),
      body: GetBuilder<TurnamenController>(builder: (turC) {
        Turnamen data = turC.dataSatuTur[0];
        return LoadingBarrier(
            child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: data.nama,
                      decoration: const InputDecoration(
                          hintText: "Nama Turnamen",
                          label: Text("Nama Turnamen")),
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
                    TextFormField(
                      initialValue: data.kontak,
                      decoration: const InputDecoration(
                          hintText: "Contact Person",
                          label: Text("Contact Person")),
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
                        Text("Level Turnamen"),
                      ],
                    ),
                    DropdownButtonFormField(
                      
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
                      value: "${data.level}",
                      onSaved: (value) {
                        turC.level.value = value!;
                      },
                      onChanged: (value) {
                        turC.level.value = value!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text("Tanggal Diadakan Turnamen"),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "${turC.dateShow}",
                        suffix: const Icon(Icons.calendar_month),
                      ),
                      readOnly: true,
                      onTap: () {
                        _datePick(context, data.date!);
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
                        Text("Batas Daftar Turnamen"),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "${turC.dateShow2}",
                        suffix: const Icon(Icons.calendar_month),
                      ),
                      readOnly: true,
                      onTap: () {
                        _datePick2(context, data.batas!);
                        inputC.inputChange(true);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: data.lokasi,
                      decoration: const InputDecoration(
                          hintText: "Lokasi Turnamen",
                          label: Text("Lokasi Turnamen")),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Data Wajib Di Isi";
                        }
                      },
                      onSaved: (value) {
                        turC.lokasi.value = value!;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text("Keterangan Turnamen"),
                      ],
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
                              hint: "Masukan Keterangan",
                              initialText: data.ket,
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
                      height: 10,
                    ),
                    const Row(
                      children: [
                        Text("Brosur Turnamen, (Klik gambar untuk mengganti Gambar)"),
                      ],
                    ),
                    (turC.isEditImg.value ? Obx(() {
                      if (prev.value != null && prev.value!.isNotEmpty) {
                        return Image.memory(
                          prev.value!,
                          width: 200,
                          height: 200,
                        );
                      } else {
                        return InkWell(
                            onTap: () async {
                              turC.pickImage();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white60,
                                borderRadius:
                                    BorderRadiusDirectional.circular(10),
                              ),
                              height: 100,
                              width: 100,
                              child: const Center(
                                child: Icon(Icons.photo),
                              ),
                            ));
                      }
                    }): SizedBox(
                      width: 200,
                      height: 200,
                      child: InkWell(
                        onTap: (){
                          turC.pickImage();
                          turC.editImgchange(true);
                          
                        },
                        child: Image(
                          image: NetworkImage('${data.img}'),
                          
                        ),
                      ),
                    )),
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
                              turC.editData(prev.value);
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
