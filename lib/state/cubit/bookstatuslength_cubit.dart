import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kliencash/data/database/database_helper.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/locale_keys.dart';

class BookstatuslengthCubit extends Cubit<List<Map<String, dynamic>>> {
  BookstatuslengthCubit() : super([]);
  void getlength() async {
    var database = DatabaseHelper.instance;
    var db = await database.getDatabase;
    var dataClient = await db.query('CLIENT');
    var dataInvoice = await db.query('INVOICE');
    var dataPayments = await db.query('PAYMENT');
    List<bool> outstandingDate = [];
    var invoiceResults = dataInvoice.map((e)=>InvoiceModel.fromJson(e)).toList();
    for(var i in invoiceResults){
    var outstanding =  DateTime.parse(i.jatuhTempo).isBefore(DateTime.now());
    outstandingDate.add(outstanding);
    } 
    final List<Map<String, dynamic>> cardData = [
      {
        'title': LocaleKeys.activeClients.tr(),
        'value':  dataClient.isNotEmpty ? dataClient.length : 0,
        'icon': Icons.people_outline,
        'color': Colors.blue,
      },
      {
        'title': "${LocaleKeys.installments.tr()} & ${LocaleKeys.dp.tr()}" ,
        'value':  
        invoiceResults.isNotEmpty ? invoiceResults.where((e) => e.status == 'Dp / Partial').length :
         0,
        'icon': Icons.check_circle_outline,
        'color': Colors.orange,
      },
      {
        'title': '${LocaleKeys.payment.tr()} ${LocaleKeys.done.tr()}',
        'value': dataPayments.isNotEmpty ?  dataPayments.length : 0,
        'icon': Icons.pending_actions,
        'color': Colors.green,
      },
      {
        'title': LocaleKeys.outstanding.tr(),
        'value': 
        invoiceResults.isNotEmpty ?  outstandingDate.where((e) => e ==  true).length :
         0,
        'icon': Icons.payments,
        'color': Colors.red,
      },
    ];
    emit(cardData);
  }
}
