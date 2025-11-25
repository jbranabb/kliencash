import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliencash/Screens/Widgets/SelectProjects.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/format.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/picked_pict.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/invoice/inovice_bloc.dart';
import 'package:kliencash/state/cubit/bookstatuslength_cubit.dart';
import 'package:kliencash/state/cubit/selectedInvoice.dart';
import 'package:kliencash/state/cubit/selectedProjects.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({super.key});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  var controller = TextEditingController();
  var focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<BookstatuslengthCubit>().getlength();
            context.read<SelectedProjects>().reset();
            context.read<Selectedinvoice>().reset();
            context.read<InvoiceBloc>().add(ReadInvoice());
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: MyText(title: 'Add Payment', color: Colors.white, fontSize: 18),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _selectProjectsWhenAddPayment(context),
              _selectedInvoiceWhenAddPayement(context),
              MyTextFileds(
                controller: controller,
                label: 'Estimated Value',
                icon: Icons.attach_money,
                focusNode: focusNode,
                isOtional: false,
              ),
              MyTextFileds(
                controller: controller,
                label: 'Total Amount',
                icon: Icons.attach_money,
                focusNode: focusNode,
                isOtional: false,
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: width * 0.5,
                      child: ListTile(
                        leading: Icon(Icons.calendar_month, color: Colors.grey),
                        title: MyText(title: 'Tanggal Bayar', fontSize: 10),
                        trailing: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: width * 0.4,
                      child: ListTile(
                        trailing: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                        title: MyText(title: 'Status', fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
              _pickPicturePayment(context),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    print(context.read<PickedPict>().state);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: MyText(
                    title: 'Selesai',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _selectedInvoiceWhenAddPayement(BuildContext context) {
  var height = MediaQuery.of(context).size.height;
  return InkWell(
    onTap: () {
      var idProjects = context.read<SelectedProjects>().state['Id'];
      idProjects != null
          ? context.read<InvoiceBloc>().add(ReadInvoiceWithId(id: idProjects))
          : null;
      showModalBottomSheet(
        context: context,
        builder: (context) => idProjects != null
            ? Container(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      height: 4,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                    ),
                    SizedBox(height: 20),
                    BlocBuilder<InvoiceBloc, InvoiceState>(
                      builder: (context, state) {
                        if (state is InvoiceReadSuccesWithId) {
                          if (state.list.isEmpty) {
                            return SizedBox(
                              height: height * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_rounded,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                  MyText(
                                    title:
                                        'Belum Ada invoice Untuk Projects ini\nSilahkan Tambahkan terlebih dahulu..',
                                    textAlign: TextAlign.center,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            );
                          }
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.list.length,
                              itemBuilder: (context, index) {
                                var invoice = state.list[index];
                                var projects = invoice.projectsModel;
                                return InkWell(
                                  onTap: () {
                                    context.read<Selectedinvoice>().getbyId(
                                      invoice.id!,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.receipt_long_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                        ),
                                      ),
                                      title: MyText(title: invoice.title),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          MyText(
                                            title: projects!.agenda,
                                            color: Colors.grey,
                                          ),
                                          MyText(
                                            title: formatCurrency(
                                              invoice.totalAmount,
                                            ),
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: bgcolors(invoice.status),
                                          border: Border.all(
                                            color: colors(invoice.status),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: MyText(
                                            fontSize: 10,
                                            title: invoice.status,
                                            color: colors(invoice.status),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              )
            : Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: MyText(
                  title: 'Silahkan Pilih Projects Terlebih dahulu.',
                  color: Colors.grey,
                ),
              ),
      );
    },
    child: BlocBuilder<Selectedinvoice, List<InvoiceModel>>(
      builder: (context, state) {
        var checkingData = state.isNotEmpty;
        var data = checkingData ? state[0] : null;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              Icons.receipt_long_rounded,
              color: checkingData ? Colors.black : Colors.grey,
            ),
            title: MyText(title: checkingData ? data!.title : 'Pilih Invoice'),
            subtitle: checkingData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        title: data!.projectsModel!.agenda,
                        color: Colors.grey,
                      ),
                      MyText(
                        title: formatCurrency(data.totalAmount),
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  )
                : null,
            trailing: checkingData
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: bgcolors(data!.status),
                      border: Border.all(color: colors(data.status)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: MyText(
                        fontSize: 10,
                        title: data.status,
                        color: colors(data.status),
                      ),
                    ),
                  )
                : Icon(Icons.arrow_drop_down_rounded, color: Colors.grey),
          ),
        );
      },
    ),
  );
}

Widget _pickPicturePayment(BuildContext context) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return Align(
    alignment: Alignment.center,
    child: SizedBox(
      child: BlocBuilder<PickedPict, String>(
        builder: (context, state) {
          if (state.isNotEmpty) {
            return InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(File(state)),
                  ),
                );
              },
              child: Container(
                height: height * 0.4,
                width: width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: Image.file(
                        height: height * 0.4,
                        width: width * 0.8,
                        File(state),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: IconButton(
                        onPressed: () {
                          context.read<PickedPict>().getImage("");
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              var picked = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              print(picked);
              if (picked != null) {
                final appDir = await getApplicationDocumentsDirectory();
                final myDir = Directory("${appDir.path}/myImages");
                if (!await myDir.exists()) {
                  await myDir.create(recursive: true);
                }
                final fileName = basename(picked.path);
                final newPath = "${myDir.path}/$fileName";
                final exportPath = await File(picked.path).copy(newPath);
                print('Export Path: ${exportPath.path}');
                context.read<PickedPict>().getImage(exportPath.path);
              }
            },
            child: Container(
              height: height * 0.4,
              width: width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: Colors.grey, size: 50),
                    MyText(
                      title: 'Upload\nBukti Pembayaran',
                      color: Colors.grey,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

Widget _selectProjectsWhenAddPayment(BuildContext context) {
  var height = MediaQuery.of(context).size.height;
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
          height: height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12),
              topLeft: Radius.circular(12),
            ),
          ),
          child: projectsToAdd(height),
        ),
      );
    },
    child: BlocBuilder<SelectedProjects, Map<String, dynamic>>(
      builder: (context, state) {
        var startAt = formatDate(state['startAt'] ?? '2025-12-20T00:00:00');
        var endAt = formatDate(state['endAt'] ?? '2025-12-20T00:00:00');
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: state['agenda'] != null
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.work,
                color: state['agenda'] != null
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.grey,
              ),
            ),
            title: MyText(title: state['agenda'] ?? 'Pilih Projects'),
            trailing: state['status'] != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: bgcolors(state['status']),
                      border: Border.all(color: colors(state['status'])),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: MyText(
                        title: state['status'],
                        fontSize: 10,
                        color: colors(state['status']),
                      ),
                    ),
                  )
                : Icon(Icons.arrow_drop_down, color: Colors.grey),
            subtitle: state['agenda'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        title: state['client_name'],
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      MyText(
                        title: formatRupiah.format(state['estimatedValue']),
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 4,
                        children: [
                          projectsDate(
                            startAt,
                            Colors.green.shade100,
                            Colors.green,
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 8,
                            color: Colors.grey,
                          ),
                          projectsDate(
                            endAt,
                            Colors.blue.shade100,
                            Colors.blue,
                            icon: Icons.done,
                          ),
                        ],
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    ),
  );
}
