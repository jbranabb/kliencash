import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/Screens/pages/mainGrid/clientPage/add_client.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/client/client_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kliencash/state/cubit/countryCode.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  var name = TextEditingController();
  var phone = TextEditingController();
  var alamat = TextEditingController();

  var nameF = FocusNode();
  var phoneF = FocusNode();
  var alamatF = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: myAppBar(context, LocaleKeys.allClients.tr()),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        onRefresh: () async {
          context.read<ClientBloc>().add(ReadDataClient());
        },
        child: BlocConsumer<ClientBloc, ClientState>(
          listener: (context, state) {
            if (state is DeleteClientSucces) {
              context.read<ClientBloc>().add(ReadDataClient());
              ScaffoldMessenger.of(context).showSnackBar(
                mySnakcbar(
                  LocaleKeys.successDeleteClient.tr(),
                  Theme.of(context).colorScheme.onPrimary,
                ),
              );
            } else if (state is EditClientSucces) {
              Navigator.of(context).pop();
              context.read<ClientBloc>().add(ReadDataClient());
              ScaffoldMessenger.of(context).showSnackBar(
                mySnakcbar(
                  LocaleKeys.successEditClient.tr(),
                  Theme.of(context).colorScheme.onPrimary,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ClientSucces) {
              if (state.list.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  var client = state.list[index];
                  return _buildClientCard(context, client, index);
                },
              );
            } else if (state is ClientLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddClient()));
        },
        icon: Icon(Icons.person_add, color: Colors.white),
        label: MyText(
          title: 'Client',
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, color: Colors.grey[400], size: 80),
          SizedBox(height: 16),
          MyText(
            title: LocaleKeys.noClient.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700]!,
          ),
          SizedBox(height: 8),
          MyText(
            title: LocaleKeys.addClientFirst.tr(),
            color: Colors.grey[500]!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(BuildContext context, ClientModel client, int index) {
    String initials = client.name.trim().isEmpty
        ? '?'
        : client.name.trim().length == 1
        ? client.name[0].toUpperCase()
        : client.name.trim().split(' ').length > 1
        ? '${client.name.trim().split(' ')[0][0]}${client.name.trim().split(' ')[1][0]}'
              .toUpperCase()
        : client.name[0].toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
      child: Slidable(
        key: Key(index.toString()),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      confirmDelete(client.name, context, client.id!),
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: LocaleKeys.deleteClient.tr(),
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onLongPress: () {
                name.text = client.name;
                alamat.text = client.alamat;
                phone.text =  client.handphone.toString();
                context.read<CountrycodeCubit>().changeCountryCode(client.countryCode);
                showDialog(
                  context: context,
                  builder: (context) => editDataClient(
                    client.id!,
                    name,
                    phone,
                    alamat,
                    nameF,
                    phoneF,
                    alamatF,
                    client,
                    context,
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.primary,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: MyText(
                          title: initials,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Client Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            title: client.name,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: MyText(
                                  title:
                                      "${client.countryCode} ${client.handphone}",
                                  fontSize: 14,
                                  color: Colors.grey[600]!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: MyText(
                                  title: client.alamat,
                                  fontSize: 13,
                                  color: Colors.grey[600]!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

AlertDialog confirmDelete(String name, BuildContext context, int id) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: Row(
      children: [
        Icon(Icons.delete_outline, color: Colors.red),
        SizedBox(width: 8),
        Expanded(
          child: MyText(title: LocaleKeys.deleteClient.tr(), fontWeight: FontWeight.bold),
        ),
      ],
    ),
    content: MyText(
      title:
          LocaleKeys.deleteClientConfirm.tr(namedArgs: {'name':name})
          ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: MyText(title: LocaleKeys.cancel.tr(), color: Colors.grey[700]!),
      ),
      ElevatedButton(
        onPressed: () {
          context.read<ClientBloc>().add(DeleteDataClient(id: id));
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: MyText(
          title: LocaleKeys.yesDelete.tr(),
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Dialog editDataClient(
  int id,
  TextEditingController name,
  TextEditingController phone,
  TextEditingController alamat,
  FocusNode nameF,
  FocusNode phoneF,
  FocusNode alamatF,
  ClientModel clientModel,
  BuildContext context,
) {
  return Dialog(
    insetPadding: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(width: 8),
                      MyText(
                        title: LocaleKeys.editClient.tr(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.grey),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              MyTextFileds(
                controller: name,
                label: LocaleKeys.clientName2.tr(),
                icon: Icons.person,
                focusNode: nameF,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).requestFocus(phoneF);
                },
              ),
              SizedBox(height: 12),
              MyTextFiledsForPhone(
                controller: phone,
                label: LocaleKeys.phoneNumber.tr(),
                icon: Icons.phone,
                focusNode: phoneF,
                onEditingCom: () {
                  FocusScope.of(context).requestFocus(alamatF);
                },
              ),
              SizedBox(height: 12),
              MyTextFileds(
                controller: alamat,
                label: LocaleKeys.address.tr(),
                icon: Icons.home,
                focusNode: alamatF,
                maxlines: 10,
                isOtional: false,
                onEditingCom: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              SizedBox(height: 20),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: MyText(
                        title: LocaleKeys.cancel.tr(),
                        color: Colors.grey[700]!,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: BlocBuilder<CountrycodeCubit, String>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            _handleSave(
                              context,
                              id,
                              name,
                              phone,
                              alamat,
                              clientModel
                             );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: MyText(
                            title: LocaleKeys.save.tr(),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _handleSave(
  BuildContext context,
  int id,
  TextEditingController name,
  TextEditingController phone,
  TextEditingController alamat,
  ClientModel clientmodel,
) {
  var state = context.read<CountrycodeCubit>().state;
  if (clientmodel.name == name.text &&
      phone.text == clientmodel.handphone &&
      alamat.text == clientmodel.alamat &&
      clientmodel.countryCode == state) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      mySnakcbar(
        'Tidak ada perubahan',
        Theme.of(context).colorScheme.onPrimary,
      ),
    );
  } else {
    validateEdit(id, name.text, state, phone.text, alamat.text, context);
  }
}

void validateEdit(
  int id,
  String name,
  String countryCode,
  String phone,
  String alamat,
  BuildContext context,
) {
  if (name.isNotEmpty && phone.isNotEmpty && alamat.isNotEmpty) {
    context.read<ClientBloc>().add(
      EditDataClient(
        id: id,
        clientModel: ClientModel(
          name: name,
          alamat: alamat,
          handphone: phone,
          countryCode: countryCode,
        ),
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            MyText(title: 'Perhatian'),
          ],
        ),
        content: MyText(title: "Silahkan isi semua field terlebih dahulu"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: MyText(
              title: 'Mengerti',
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
