import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/banks.dart';
import '../widgets/bank_item.dart';

class BankGrid extends StatelessWidget {
  // const BankView({
  //   Key key,
  //   @required this.loadedBank,
  // }) : super(key: key);

  // final List<Bank> loadedBank;

  final bool showFavouritesOnly;
  BankGrid(this.showFavouritesOnly);

  @override
  Widget build(BuildContext context) {
    final banksData = Provider.of<Banks>(context);
    final banks =
        showFavouritesOnly ? banksData.favoruiteItems : banksData.items;

    return 
    // ListView.builder(
    //   padding: const EdgeInsets.all(10),
    //   itemBuilder: (context, index) => ChangeNotifierProvider.value(
    //     // builder: (c) => banks[index],
    //     value: banks[index],
    //     child: BankItem(),
    //   ),
    //   itemCount: banks.length,
    // );
    GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: banks.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        // builder: (c) => banks[index], 
        value: banks[index],
        child: BankItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
