import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/Widgets/snackbar.dart';
import 'package:kliencash/Screens/Widgets/text_fields.dart';
import 'package:kliencash/data/model/model.dart';
import 'package:kliencash/state/bloc/paymentMethod/payment_method_bloc.dart';
import 'package:kliencash/state/bloc/users/users_bloc.dart';
import 'package:kliencash/state/cubit/SettingsCubit.dart';
import 'package:kliencash/state/cubit/dropdown_statusinvoice.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    context.read<OpenBahasaToggle>().reset();
    context.read<OpenBahasaToggle>().reset();
    context.read<TogglePaymentMethod>().reset();
    context.read<DropdownStatusinvoice>().reset();
    super.initState();
  }

  var nameC = TextEditingController();
  var nameF = FocusNode();
  var numberC = TextEditingController();
  var numberF = FocusNode();
  var atasNamaC = TextEditingController();
  var atasNamaF = FocusNode();
  @override
  void dispose() {
    nameC.dispose();
    nameF.dispose();
    numberC.dispose();
    numberF.dispose();
    atasNamaC.dispose();
    atasNamaF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: myAppBar(context, 'Settings'),
      body: BlocListener<PaymentMethodBloc, PaymentMethodState>(
        listener: (context, state) {
          if (state is PaymentMethodPostSucces) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              mySnakcbar(
                'Berhasil Menambahkan Payment Method',
                Theme.of(context).colorScheme.onPrimary,
              ),
            );
            context.read<PaymentMethodBloc>().add(ReadPaymentMethod());
          } else if (state is PaymentMethodEditSucces) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              mySnakcbar(
                'Berhasil Mengedit Payment Method',
                Theme.of(context).colorScheme.onPrimary,
              ),
            );
            context.read<PaymentMethodBloc>().add(ReadPaymentMethod());
          } else if (state is PaymentMethodDeleteSucces) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              mySnakcbar(
                'Berhasil Menghapus Payment Method',
                Theme.of(context).colorScheme.onPrimary,
              ),
            );
            context.read<PaymentMethodBloc>().add(ReadPaymentMethod());
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.02),
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.onPrimary,
                        Theme.of(context).colorScheme.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.business_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),

                SizedBox(height: height * 0.04),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _userSection(),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () =>
                            context.read<TogglePaymentMethod>().toggle(),
                        child: BlocBuilder<TogglePaymentMethod, bool>(
                          builder: (context, state) {
                            return Column(
                              children: [
                                _additionalInfo(
                                  Icons.credit_card,
                                  'Payment Method',
                                ),
                                if (state) ...[
                                  BlocBuilder<
                                    PaymentMethodBloc,
                                    PaymentMethodState
                                  >(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          if (state
                                              is PaymentMethodSReaducces) ...[
                                            Container(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: state.list.length,
                                                itemBuilder: (context, index) {
                                                  var data = state.list[index];
                                                  return SizedBox(
                                                    child: ClipRRect(
                                                      child: Slidable(
                                                        key: Key(
                                                          index.toString(),
                                                        ),
                                                        endActionPane: ActionPane(
                                                          motion:
                                                              DrawerMotion(),
                                                          extentRatio: 0.45,
                                                          children: [
                                                            SlidableAction(
                                                              onPressed: (context) {
                                                                nameC.text =
                                                                    data.name;
                                                                numberC
                                                                    .text = data
                                                                    .number!;
                                                                context
                                                                    .read<
                                                                      DropdownStatusinvoice
                                                                    >()
                                                                    .setStatus(
                                                                      data.type,
                                                                    );
                                                                atasNamaC
                                                                    .text = data
                                                                    .accountName!;
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (context) => _popUpBottomSheet(
                                                                    nameC,
                                                                    nameF,
                                                                    numberC,
                                                                    numberF,
                                                                    atasNamaC,
                                                                    atasNamaF,
                                                                    'Edit',
                                                                    onpresed: () {
                                                                      var stateType = context
                                                                          .read<
                                                                            DropdownStatusinvoice
                                                                          >()
                                                                          .state;
                                                                      context
                                                                          .read<
                                                                            PaymentMethodBloc
                                                                          >()
                                                                          .add(
                                                                            EditPaymentMethod(
                                                                              id: data.id!,
                                                                              model: PaymentMethodModel(
                                                                                name: nameC.text,
                                                                                accountName: atasNamaC.text,
                                                                                number: numberC.text,
                                                                                type: stateType!,
                                                                                isActive: 0,
                                                                              ),
                                                                            ),
                                                                          );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              backgroundColor:
                                                                  Colors.orange,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              icon: Icons.edit,
                                                              label: 'Edit',
                                                            ),
                                                            SlidableAction(
                                                              onPressed: (context) {
                                                              _deleteMetodPayment(data.id!);
                                                              },
                                                              backgroundColor:
                                                                  Colors.red,
                                                              foregroundColor:
                                                                  Colors.white,
                                                              icon: Icons
                                                                  .delete_outline,
                                                              label: 'Hapus',
                                                            ),
                                                          ],
                                                        ),
                                                        child: ListTile(
                                                          leading: Icon(
                                                            data.type.toLowerCase() ==
                                                                    'bank'
                                                                ? Icons
                                                                      .account_balance
                                                                : Icons.account_balance_wallet_rounded,
                                                            color: Colors.grey,
                                                          ),
                                                          title: MyText(
                                                            title: data.name,
                                                          ),
                                                          trailing: MyText(
                                                            title: data.type,
                                                            color: Colors.grey,
                                                            fontSize: 10,
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              MyText(
                                                                title:
                                                                    '${data.type.toLowerCase() == 'bank' ? 'Rek' : 'Num'}: ${data.number}',
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                              ),
                                                              MyText(
                                                                title:
                                                                    'A.n: ${data.accountName}',
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            state.list.length >= 10
                                                ? SizedBox.shrink()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          16.0,
                                                        ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        color: Colors
                                                            .grey
                                                            .shade100,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () => showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (context) =>
                                                              _popUpBottomSheet(
                                                                nameC,
                                                                nameF,
                                                                numberC,
                                                                numberF,
                                                                atasNamaC,
                                                                atasNamaF,
                                                                'Tambah'
                                                              ),
                                                        ),
                                                        child: ListTile(
                                                          subtitle: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.add,
                                                                color:
                                                                    Colors.grey,
                                                                size: 16,
                                                              ),
                                                              MyText(
                                                                title:
                                                                    'Tambahkan Metode Pembayaran',
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                      _langueSection(),
                      _themeSection(),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                MyText(title: 'Build by J With Love', color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteMetodPayment(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: MyText(title: 'Hapus Payment Method ini?'),
        content: MyText(title: 'Apakah kamu yakin ingin menghapus payment method ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: MyText(title: 'Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PaymentMethodBloc>().add(DeletePaymentMethod(id: id));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: MyText(
              title: 'Ya, Yakin',
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Dialog _popUpBottomSheet(
    TextEditingController nameC,
    FocusNode nameF,
    TextEditingController numberC,
    FocusNode numberF,
    TextEditingController atasNamaC,
    FocusNode atasNamaF,
    String? title,
     {
    void Function()? onpresed,
  }) {
    List items = ['BANK', 'E-Wallet'];
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      title: '$title Metode Pembayaran',
                      fontWeight: FontWeight.bold,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(120),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<DropdownStatusinvoice>().reset();
                      },
                      child: Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: BoxBorder.all(
                      color: Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButton(
                    underline: SizedBox.shrink(),
                    items: items
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MyText(title: e),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      context.read<DropdownStatusinvoice>().setStatus(
                        value.toString(),
                      );
                    },
                    hint: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.account_balance, color: Colors.grey),
                          BlocBuilder<DropdownStatusinvoice, String?>(
                            builder: (context, state) {
                              return MyText(
                                title: state ?? 'Tipe: BANK atau E-Wallet',
                                color: state != null
                                    ? Colors.black
                                    : Colors.grey,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                MyTextFileds(
                  controller: nameC,
                  label: 'Name',
                  icon: Icons.credit_card,
                  hint: MyText(
                    title: 'Contoh: BCA,Dana DLL ',
                    color: Colors.grey,
                  ),
                  focusNode: nameF,
                  isOtional: false,
                ),
                MyTextFileds(
                  controller: numberC,
                  label: 'Number',
                  icon: Icons.onetwothree,
                  hint: MyText(
                    title: 'No Rek atau no E-Wallet ',
                    color: Colors.grey,
                  ),
                  focusNode: numberF,
                  isOtional: false,
                ),
                MyTextFileds(
                  controller: atasNamaC,
                  label: 'Atas nama',
                  icon: Icons.person,
                  hint: MyText(title: 'Contoh: Yanto  ', color: Colors.grey),
                  focusNode: atasNamaF,
                  isOtional: false,
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed:
                        onpresed ??
                        () {
                          var typeState = context
                              .read<DropdownStatusinvoice>()
                              .state;
                          if (typeState != null &&
                              nameC.text.isNotEmpty &&
                              numberC.text.isNotEmpty &&
                              atasNamaC.text.isNotEmpty) {
                            context.read<PaymentMethodBloc>().add(
                              PostPaymentMethod(
                                model: PaymentMethodModel(
                                  name: nameC.text,
                                  type: typeState,
                                  number: numberC.text,
                                  accountName: atasNamaC.text,
                                  isActive: 0,
                                ),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: MyText(title: 'Terjadi Kesalahan'),
                                content: MyText(
                                  title:
                                      'Silahkan isi semua fileds terlebih dahulu',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: MyText(title: 'Ok'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: MyText(
                      title: 'Selesai',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userSection() {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersSucces) {
          var data = state.list[0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    title: 'User Information',
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MyText(
                    title: 'Hallo, ',
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  MyText(
                    title: data.username,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ],
              ),
              MyText(
                title: data.namaPerusahaaan,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 22,
              ),
              SizedBox(height: 16),
              _buildInfoRow(Icons.location_on_rounded, data.alamat),
              SizedBox(height: 12),
              _buildInfoRow(
                Icons.phone_rounded,
                '${data.countryCode} ${data.phoneNumber}',
              ),
              SizedBox(height: 12),
              _buildInfoRow(Icons.email_rounded, data.emaiil),
            ],
          );
        }
        return SizedBox.square();
      },
    );
  }

  Widget _langueSection() {
    return BlocBuilder<OpenBahasaToggle, bool>(
      builder: (context, state) {
        return Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                context.read<OpenBahasaToggle>().toggleBahasa();
              },
              child: _additionalInfo(
                Icons.language,
                'Bahasa',
                iconTrailing: state
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
              ),
            ),
            if (state) ...[
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Durations.medium2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          leading: MyText(
                            title: 'ID',
                            fontWeight: FontWeight.bold,
                          ),
                          title: MyText(title: 'Indonesia'),
                        ),
                      ),
                      ListTile(
                        leading: MyText(
                          title: 'EN',
                          fontWeight: FontWeight.bold,
                        ),
                        title: MyText(title: 'English'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _themeSection() {
    return BlocBuilder<OpenThemeToggle, bool>(
      builder: (context, state) {
        return Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                context.read<OpenThemeToggle>().toggleThm();
              },
              child: _additionalInfo(
                Icons.palette,
                'Theme',
                iconTrailing: state
                    ? Icons.arrow_drop_up_rounded
                    : Icons.arrow_drop_down_rounded,
              ),
            ),
            if (state) ...[
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Durations.medium2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: BlocBuilder<ChangeTheme, int>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: state == 1
                                  ? Colors.grey[50]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: InkWell(
                              onTap: () =>
                                  context.read<ChangeTheme>().setTheme(1),
                              child: ListTile(
                                leading: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                title: MyText(title: 'Biru'),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: state == 2
                                  ? Colors.grey[50]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: InkWell(
                              onTap: () =>
                                  context.read<ChangeTheme>().setTheme(2),
                              child: ListTile(
                                leading: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade400,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                title: MyText(title: 'Pink'),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: state == 0
                                  ? Colors.grey[50]
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: InkWell(
                              onTap: () =>
                                  context.read<ChangeTheme>().setTheme(0),
                              child: ListTile(
                                leading: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                title: MyText(title: 'Black'),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _additionalInfo(
    IconData icon,
    String title, {
    IconData? iconTrailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: MyText(title: title),
      trailing: Icon(
        iconTrailing ?? Icons.arrow_drop_down_rounded,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: Colors.grey[700]),
        ),
        SizedBox(width: 12),
        Expanded(
          child: MyText(title: text, color: Colors.grey[700], fontSize: 14),
        ),
      ],
    );
  }
}
