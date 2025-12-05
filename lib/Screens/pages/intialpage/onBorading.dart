import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/intialpage/add_user.dart';
import 'package:kliencash/locale_keys.dart';
import 'package:kliencash/state/cubit/SettingsCubit.dart';
import 'package:kliencash/state/cubit/onBoardingCubit.dart';
import 'package:kliencash/state/cubit/toggleLang.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboradingPage extends StatefulWidget {
  const OnboradingPage({super.key});

  @override
  State<OnboradingPage> createState() => _OnboradingPageState();
}

class _OnboradingPageState extends State<OnboradingPage> {
  bool _hasInitialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      context.read<Togglelang>().nowlangue(context.locale.languageCode);
      _hasInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print('rebuild');
    PageController pageController = PageController();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _changeTextlang(),
              SizedBox(height: 8),
              Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dotTheme(Colors.black, 0),
                  _dotTheme(Colors.blue.shade900, 1),
                  _dotTheme(Colors.pink.shade400, 2),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (value) {
              context.read<Onboardingcubit>().getPage(value);
            },
            children: [
              _onboardingWidgets(
                context,
                pageController,
                Icons.folder,
                LocaleKeys.onBoardingPage1Title,
                LocaleKeys.onBoardingPage1Subtitle,
                false,
              ),
              _onboardingWidgets(
                context,
                pageController,
                Icons.receipt_long_rounded,
                LocaleKeys.onBoardingPage2Title,
                LocaleKeys.onBoardingPage2Subtitle,
                false,
              ),
              _onboardingWidgets(
                context,
                pageController,
                Icons.bar_chart_rounded,
                LocaleKeys.onBoardingPage3Title,
                LocaleKeys.onBoardingPage3Subtitle,
                true,
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: BlocBuilder<Onboardingcubit, int>(
              builder: (context, state) {
                return Container(
                  width: width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmoothPageIndicator(
                        controller: pageController,
                        effect: SwapEffect(
                          activeDotColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          dotColor: Theme.of(context).colorScheme.primary,
                          dotHeight: 10,
                          dotWidth: 10,
                        ),
                        count: 3,
                      ),
                      state != 2
                          ? TextButton(
                              onPressed: () {
                                pageController.jumpToPage(2);
                              },
                              child: MyText(
                                title: LocaleKeys.skipButton.tr(),
                                color: Colors.grey.shade400,
                              ),
                            )
                          : SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14.0,
                                ),
                                child: MyText(title: ''),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _changeTextlang() {
  return Builder(
    builder: (BuildContext context) {
      return BlocBuilder<Togglelang, String>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              GestureDetector(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.setLocale(Locale('en'));
                  });
                  context.read<Togglelang>().nowlangue('en');
                },
                child: MyText(
                  title: 'EN',
                  color: state == 'en' ? Colors.black : Colors.grey,
                ),
              ),
              MyText(title: ' | '),
              GestureDetector(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.setLocale(Locale('id'));
                  });
                  context.read<Togglelang>().nowlangue('id');
                },
                child: MyText(title: 'ID', color: state == 'id' ? Colors.black : Colors.grey,),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _dotTheme(Color color, value) {
  return BlocBuilder<ChangeTheme, int>(
    builder: (context, state) {
      return GestureDetector(
        onTap: () {
          context.read<ChangeTheme>().setTheme(value);
        },
        child: Container(
          decoration: BoxDecoration(
            border: BoxBorder.all(
              color: state == value ? Colors.grey : Colors.white,
            ),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Colors.grey),
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _onboardingWidgets(
  BuildContext context,
  PageController pageController,
  IconData icon,
  String title,
  String subtitle,
  bool itslastpage,
) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  return BlocBuilder<Onboardingcubit, int>(
    builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: height * 0.2),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 80,
            ),
          ),
          SizedBox(height: itslastpage ? height * 0.20 : height * 0.25),
          MyText(
            title: title.tr(),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          SizedBox(
            width: width * 0.8,
            child: MyText(
              title: subtitle.tr(),
              color: Colors.grey,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          itslastpage
              ? ElevatedButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => AddUser()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: MyText(
                    title: LocaleKeys.getStartedButton.tr(),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : SizedBox.shrink(),
        ],
      );
    },
  );
}
