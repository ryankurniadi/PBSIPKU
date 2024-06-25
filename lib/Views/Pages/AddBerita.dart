import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:get/get.dart';

import '../Widgets/NavBar.dart';
import '../Widgets/LoadingBarrier.dart';
import '../../Controllers/BeritaController.dart';
import '../../Controllers/LoadingController.dart';

class AddBerita extends StatelessWidget {
  AddBerita({super.key});

  final beritaC = Get.find<BeritaController>();
  final loadC = Get.find<LoadingController>();
  final _formKey = GlobalKey<FormState>();
  HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    var prev = beritaC.imageBytes;
    return SafeArea(
        child: Scaffold(
      appBar: NavBar(title: "Tambah Berita"),
      body: LoadingBarrier(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 20),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      "Judul Berita",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Judul Berita", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Data Wajib Di Isi";
                    }
                  },
                  onSaved: (value) {
                    beritaC.judul.value = value!;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  children: [
                    Text(
                      "Isi Berita",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  color: Colors.grey.shade200,
                  child: HtmlEditor(
                    controller: controller,
                    htmlEditorOptions: HtmlEditorOptions(
                      hint: "Isi Berita",
                      initialText: beritaC.isi.value,
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
                      height: 450,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    const Text(
                      "Thumbnal Berita",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Obx(
                      () => (beritaC.isImg.value
                          ? Obx(() {
                              if (prev.value != null &&
                                  prev.value!.isNotEmpty) {
                                return InkWell(
                                  onTap: () async {
                                    beritaC.pickImage();
                                  },
                                  child: Image.memory(
                                    prev.value!,
                                    width: 700,
                                    height: 500,
                                  ),
                                );
                              } else {
                                return InkWell(
                                    onTap: () async {
                                      beritaC.pickImage();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                10),
                                      ),
                                      height: 400,
                                      width: 700,
                                      child: const Center(
                                        child: Icon(Icons.photo),
                                      ),
                                    ));
                              }
                            })
                          : SizedBox(
                              width: 700,
                              height: 400,
                              child: InkWell(
                                onTap: () {
                                  beritaC.pickImage();
                                  beritaC.editImgChanger(true);
                                },
                                child: Image(
                                  image: NetworkImage('${beritaC.imgDefault}'),
                                ),
                              ),
                            )),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      loadC.changeLoading(true);
                      if (prev.value != null) {
                        var txt = await controller.getText();
                        if (txt.contains('src=\"data:')) {
                          txt =
                              '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                        }
                        beritaC.isi.value = txt;
                        beritaC.addBerita(prev.value!);
                      } else {
                        Get.snackbar("Gagal", "Gambar Baner Tidak Boleh Kosong",
                            backgroundColor: Colors.red);
                      }
                    }
                  },
                  child: Container(
                    width: Get.width / 1.1,
                    height: 60,
                    decoration: BoxDecoration(color: Colors.green,
                      borderRadius: BorderRadius.circular(10),),
                    child: const Center(
                      child: Text("Tambah Berita",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    ));
  }
}
