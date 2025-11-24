import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/picked_pict.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
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
      appBar: myAppBar(context, 'Add Payment'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.receipt_long_rounded, color: Colors.grey),
                  title: MyText(title: 'Pilih Invoice'),
                  trailing: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
              MyTextFileds(
                controller: controller,
                label: 'Jumlah',
                icon: Icons.attach_money,
                focusNode: focusNode,
                isOtional: false,
              ),
              MyTextFileds(
                controller: controller,
                label: 'Notes',
                icon: Icons.attach_money,
                focusNode: focusNode,
                isOtional: true,
                maxlines: 10,
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
              Align(
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
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
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
                            final appDir =
                                await getApplicationDocumentsDirectory();
                            final myDir = Directory("${appDir.path}/myImages");
                            if (!await myDir.exists()) {
                              await myDir.create(recursive: true);
                            }
                            final fileName = basename(picked.path);
                            final newPath = "${myDir.path}/$fileName";
                            final exportPath = await File(
                              picked.path,
                            ).copy(newPath);
                            print('Export Path: ${exportPath.path}');
                            context.read<PickedPict>().getImage(
                              exportPath.path,
                            );
                          }
                        },
                        child: Container(
                          height: height * 0.4,
                          width: width * 0.8,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
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
              ),
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
