import 'package:excel/excel.dart';

import '../Models/PesertaView.dart';

class ExportController {
  static satexportFile(List<Pesertaview> data) async {
    var excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, "Data Peserta");

    Sheet sheet = excel['Data Peserta'];
    var headerNama = sheet.cell(CellIndex.indexByString("C2"));
    var headerPBSI = sheet.cell(CellIndex.indexByString("D2"));

    //sheet.setDefaultColumnWidth(.1);

    headerNama.value = const TextCellValue("Nama Peserta");
    headerPBSI.value = const TextCellValue("PBSI");
    headerNama.cellStyle = CellStyle(bold: true);
    headerPBSI.cellStyle = CellStyle(bold: true);
    sheet.setColumnWidth(2, 30);
    sheet.setColumnWidth(3, 30);

    int input = 3;
    for (var i = 0; i < data.length; i++) {
      Pesertaview dataPeserta = data[i];
      var cellNama = sheet.cell(CellIndex.indexByString("C$input"));
      var cellPBSI = sheet.cell(CellIndex.indexByString("D$input"));

      cellNama.value =
          TextCellValue("${dataPeserta.nama} & ${dataPeserta.nama2}");
      cellPBSI.value = TextCellValue("${dataPeserta.namaPBSI}");

      input++;
    }

    excel.save(fileName: 'Data Peserta Turnamen .xlsx');
  }
}
