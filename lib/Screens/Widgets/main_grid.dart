import 'package:flutter/material.dart';
import 'package:kliencash/Screens/pages/mainGrid/clientPage/client_page.dart';
import 'package:kliencash/Screens/Widgets/my_text.dart';
import 'package:kliencash/Screens/pages/mainGrid/project/projects_page.dart';
SliverToBoxAdapter mainGrid() {
  return SliverToBoxAdapter(
    child: SizedBox(
      width: double.maxFinite,
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                    if(index == 0){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ClientPage(),));
                    }
                    if(index == 1){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProjectsPage(),));
                    }
                  },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                 color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.2, 4),
                      blurRadius: 10,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
                child: childGrid(index,context),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget childGrid(int index, BuildContext context) {
  switch (index) {
    case 0: 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.person),
        MyText(title: "Client")
      ],
    );
    case 1:
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.work),
        MyText(title: "Projects")
      ],
    );
    case 2:
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.receipt_long_rounded),
        MyText(title: "Invoice")
       ],
    );
    case 3:
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.attach_money_rounded),
        MyText(title: "Payment")
      ],
    );
    case 4:
      return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.bar_chart_rounded),
        MyText(title: "Report")
      ],
    );
    case 5:
      return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.factory),
        MyText(title: "Operasional", textAlign: TextAlign.center,)
      ],
    );
    default:
      return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(color: Theme.of(context).colorScheme.onPrimary,size: 30, Icons.person),
        MyText(title: "seprei gratis bowok", textAlign: TextAlign.center,)
      ],
    );
  }
}
