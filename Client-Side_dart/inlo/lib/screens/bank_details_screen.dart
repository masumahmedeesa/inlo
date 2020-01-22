import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'individual_details.dart';
import '../providers/banks.dart';
import '../providers/loans.dart';
// import '../providers/loan.dart';
// import '../providers/bank.dart';

class BankDetailsScreen extends StatefulWidget {
  // final String title;
  // BankDetailsScreen(this.title);

  static const routeName = '/bank-details';

  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final clr = TextStyle(color: Colors.grey[400]);

  final clr2 = TextStyle(color: Colors.pink);
  var loadedBanks;
  var loadedLoans;

  @override
  void initState() {
    // Provider.of<Loans>(context, listen: false).getLoanSetLoan("TRUSTBANK");
    // Provider.of<Banks>(context, listen: false).getBankSetBank();
    super.initState();
  }

  Widget info(BuildContext context, String prothom, String ditio) {
    return Container(
      // padding: EdgeInsets.only(top: 15.0, left: 8.0),
      child: Column(
        children: <Widget>[
          _first(context, prothom, ditio),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _getInfo(BuildContext context) {
    // final bankId = ModalRoute.of(context).settings.arguments as String;
    // final loadedBanks =
    //     Provider.of<Banks>(context, listen: false).findById(bankId);
    // final loadedLoans = Provider.of<Loans>(context, listen: false).getLoans(loadedBanks.stockCode);
    // print('eta impportant');
    // print(loadedLoans.length);
    return Container(
      padding: EdgeInsets.only(top: 17),
      child: Column(
        children: <Widget>[
          info(context, "Head Office", loadedBanks.address),
          info(context, "Known As", loadedBanks.knownAs),
          info(context, "Category", loadedBanks.category),
          info(context, "Swift Code", loadedBanks.swiftCode),
          info(context, "Stock Code", loadedBanks.stockCode),
          info(context, "Origin", loadedBanks.origin),
          info(context, "Type", loadedBanks.type),
          info(context, "Description", loadedBanks.description),
          info(context, "Services", loadedBanks.services),
          info(context, "I M A G E", ""),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              loadedBanks.image == null
                  ? 'https://dummyimage.com/600x400/2abd47/fff&text=null'
                  : loadedBanks.image,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Row _first(BuildContext context, String prothom, String ditio) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                prothom,
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width * .6,
          child: Text(
            ditio,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getBanks(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: loadedLoans.length > 0
          ? ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(Individual.routeName,
                              arguments: loadedLoans[index].id);
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            loadedBanks.image == null
                                ? "https://dummyimage.com/600x400/2abd47/fff&text=null"
                                : loadedBanks.image,
                          ),
                        ),
                        title: Text(
                          loadedLoans[index].name,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          loadedLoans[index].description,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                        // trailing: Text('Trust Bank', style:clr),
                      ),
                      Divider()
                    ],
                  ),
                );
              },
              itemCount: loadedLoans.length,
            )
          : Center(
              child: Text(
                'No Loans Available Right now!',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bankId = ModalRoute.of(context).settings.arguments as String;
    loadedBanks = Provider.of<Banks>(context, listen: false).findById(bankId);

    loadedLoans = Provider.of<Loans>(context, listen: false)
        .getLoans(loadedBanks.stockCode);
    print('eta impportant');
    print(loadedLoans.length);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // drawer: buildSideDrawer(context),
        appBar: getAppBar(context),
        body: Container(
          color: Colors.black,
          child: TabBarView(
            children: <Widget>[
              // SizedBox(height: 10,),
              SingleChildScrollView(
                child: _getInfo(context),
              ),
              _getBanks(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black,
      title: Text(
        loadedBanks.stockCode,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      bottom: TabBar(
        // indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Theme.of(context).primaryColor,
        // unselectedLabelStyle: TextStyle(),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.redAccent,
        ),
        tabs: <Widget>[
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Text('I N F O'),
            ),
          ),
          // text: "INFO",
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Text('L O A N S'),
            ),
          ),
        ],
      ),
    );
  }
}
