import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dynamic_tabbar/dynamic_tabbar.dart';


import '../Widgets/LoadingBarrier.dart';
import '../Widgets/TabelTurnamen.dart';
import '../Widgets/TabelTurnamen2.dart';
import '../Widgets/NavBar.dart';
import '../../Routes/PageNames.dart';
import '../../Controllers/TurnamenContoller.dart';


class DataTurnamen extends StatelessWidget {
  DataTurnamen({super.key});
  final turC = Get.put(TurnamenController());

  List<TabData> tabs = [
    TabData(index: 1, title: const Tab( child: Text("Data Turnamen"),), content: const AccTurnamen()),
    TabData(index: 1, title: const Tab( child: Text("Pengajuan Turnamen"),), content: const NonAccTurnamen())
  ];

  @override
  Widget build(BuildContext context) {
    turC.getData2();
    return SafeArea(
      child: Scaffold(
        appBar: NavBar(title: "Data Turnamen Kota Pekanbaru"),
        //drawer: const Sidebar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            //shrinkWrap: true,
            //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        turC.date.value = DateTime.now();
                        turC.date2.value = DateTime.now();
                        turC.setDate(DateTime.now());
                        turC.setDate2(DateTime.now());
                        Get.toNamed(PageNames.AddTurnamen);
                      },
                      child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xff197500), Color(0xff007529)],
                                stops: [0, 1],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Tambah Data Turnamen",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )))),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(child: DynamicTabBarWidget(
                dynamicTabs: tabs, 
                onTabControllerUpdated: (controller){}
                )),
            ],
          ),
        ),
      ),
    );
  }
}

class AccTurnamen extends StatelessWidget {
  const AccTurnamen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TurnamenController>(
      builder: (turC) {
        if(turC.totalTur.value > 0){
          return SingleChildScrollView(
            child: PaginatedDataTable(
            source: TabelTurnamen(context),
            header: const Text("Data Turnamen"),
            rowsPerPage:
                (turC.totalTur.value >= 7 ? 7 : turC.totalTur.value),
            showFirstLastButtons: true,
            showEmptyRows: false,
            dataRowMaxHeight: 200,
            columns: const [
              DataColumn(label: Text('Baner Turnamen')),
              DataColumn(label: Text('Nama Turnamen')),
              DataColumn(label: Text('Pelaksanaan')),
              DataColumn(label: Text('Lokasi')),
              DataColumn(label: Text('Aksi')),
            ],
                    ),
          );
        }
    
        return const Center(child:Text("Tidak ada Data Turnamen"));
      },
    );
  }
}

class NonAccTurnamen extends StatelessWidget {
  const NonAccTurnamen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingBarrier(
      child: GetBuilder<TurnamenController>(
        builder: (turC) {
          if(turC.ajutotalTur.value > 0){
            return SingleChildScrollView(
              child: PaginatedDataTable(
              source: TabelTurnamen2(context),
              header: const Text("Data Pengajuan Turnamen"),
              rowsPerPage:
                  (turC.ajutotalTur.value >= 7 ? 7 : turC.ajutotalTur.value),
              showFirstLastButtons: true,
              showEmptyRows: false,
              dataRowMaxHeight: 200,
              columns: const [
                DataColumn(label: Text('Baner Turnamen')),
                DataColumn(label: Text('Nama Turnamen dan Level')),
                DataColumn(label: Text('Pelaksanaan')),
                DataColumn(label: Text('Lokasi')),
                DataColumn(label: Text('Aksi')),
              ],
                      ),
            );
          }
      
          return const Center(child:Text("Tidak ada Data Turnamen"));
        },
      ),
    );
  }
}
