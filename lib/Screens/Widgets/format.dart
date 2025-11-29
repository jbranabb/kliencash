import 'package:intl/intl.dart';


  String formatCurrency(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }



String formatDate(String date){
  var dateFromIso = DateTime.parse(date);
  var formated = DateFormat('dd-MM-yyyy').format(dateFromIso);
  return formated;
}
String formatDateDetail(String date){
  var dateFromIso = DateTime.parse(date);
  var formated = DateFormat('dd MMM yyyy').format(dateFromIso);
  return formated;
}
String formatDateWithoutY(String date){
  var dateFromIso = DateTime.parse(date);
  var formated = DateFormat('dd MMM').format(dateFromIso);
  return formated;
}