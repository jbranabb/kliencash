import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kliencash/Screens/Widgets/appbar.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/state/cubit/SettingsCubit.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: myAppBar(context, 'Settings'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.02),

              // Profile Avatar with gradient
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with edit button
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
                      MyText(
                        title: "Pinky Wedding",
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                      SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.location_on_rounded,
                        'Jalan Jendral Sudirman, No.34',
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(Icons.phone_rounded, '+62 819-2920-2112'),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.email_rounded,
                        'contact@pinkywedding.com',
                      ),
                    ],
                  ),
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
                    BlocBuilder<OpenBahasaToggle, bool>(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
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
                    ),
                    BlocBuilder<OpenThemeToggle, bool>(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: BlocBuilder<ChangeTheme, int>(
                                    builder: (context, state) {
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: state  == 1 ? Colors.grey[50] : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: InkWell(
                                              onTap: () => context
                                                  .read<ChangeTheme>()
                                                  .setTheme(1),
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
                                              color: state == 2 ? Colors.grey[50] :Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: InkWell(
                                              onTap: () => context
                                                  .read<ChangeTheme>()
                                                  .setTheme(2),
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
                                              color: state == 0 ? Colors.grey[50] :Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: InkWell(
                                              onTap: () => context
                                                  .read<ChangeTheme>()
                                                  .setTheme(0),
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
                                          SizedBox(height: 10,)
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              MyText(title: 'Build by J With Love', color: Colors.grey),
            ],
          ),
        ),
      ),
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
