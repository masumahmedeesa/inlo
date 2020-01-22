import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
// import '../screens/cart_screen.dart';
import '../widgets/bank_grid.dart';
// import '../widgets/badge.dart';
// import '../providers/cart.dart';
import '../providers/banks.dart';
import '../providers/loans.dart';
import '../screens/searchScreen.dart';

enum FilterOptions {
  Favourites,
  All,
}

class BankOverViewScreen extends StatefulWidget {
  @override
  _BankOverViewScreenState createState() => _BankOverViewScreenState();
}

class _BankOverViewScreenState extends State<BankOverViewScreen> {
  var _showFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Banks>(context, listen: false).getBankSetBank();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Banks>(context, listen: false).getBankSetBank().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<Loans>(context, listen: false).getLoanSetLoan().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('pain');
    // final bankData = Provider.of<Banks>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'E x p l o r e',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                // print(selectedValue);
                if (selectedValue == FilterOptions.Favourites) {
                  // bankData.showFavourite();
                  _showFavourites = true;
                } else {
                  // bankData.showAll();
                  _showFavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Bookmarks Only'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(SearchScreen.routeName);
          //   },
          // ),
          
          // Consumer<Cart>(
          //   builder: (_, cartData, chld) => Badge(
          //     child: chld,
          //     value: cartData.itemAmount.toString(),
          //   ),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.store,
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(CartScreen.routeName);
          //     },
          //   ),
          // ),
        ],
      ),
      drawer: buildSideDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.search,
          size: 30,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(SearchScreen.routeName);
        },
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.pink,
      //   shape: CircularNotchedRectangle(),
      //   // notchMargin: 10,
      //   child: Container(
      //     height: 60,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: <Widget>[
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             MaterialButton(
      //               minWidth: 40,
      //               onPressed: () {
      //                 setState(() {
      //                   // currentScreen =
      //                   //     Dashboard(); // if user taps on this dashboard tab will be active
      //                   // currentTab = 0;
      //                 });
      //               },
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: <Widget>[
      //                   Icon(
      //                     Icons.all_inclusive,
      //                     // color: currentTab == 0 ? Colors.blue : Colors.grey,
      //                   ),
      //                   Text(
      //                     'Show All',
      //                     style: TextStyle(
      //                         // color: currentTab == 0 ? Colors.blue : Colors.grey,
      //                         ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         Row(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             MaterialButton(
      //               minWidth: 40,
      //               onPressed: () {
      //                 setState(() {
      //                   // currentScreen =
      //                   //     Dashboard(); // if user taps on this dashboard tab will be active
      //                   // currentTab = 0;
      //                 });
      //               },
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: <Widget>[
      //                   Icon(
      //                     Icons.bookmark_border,
      //                     // color: currentTab == 0 ? Colors.blue : Colors.grey,
      //                   ),
      //                   Text(
      //                     'BookMarked',
      //                     style: TextStyle(
      //                         // color: currentTab == 0 ? Colors.blue : Colors.grey,
      //                         ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _isLoading
          ? Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: Colors.black,
              child: BankGrid(_showFavourites),
            ),
    );
  }
}
