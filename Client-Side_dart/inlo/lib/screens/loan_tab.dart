import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class LoanTab extends StatelessWidget {
  static const routeName = '/loan-tab';

  final clr = TextStyle(color: Colors.grey[400]);
  final clr2 = TextStyle(color: Colors.pink);

  Widget info(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: 15.0, left: 8.0),
      child: Column(
        children: <Widget>[
          _first(context),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _getInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 17),
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) => info(context),
      ),
    );
  }

  Row _first(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Text(
                'Head Office',
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
            "Peoples Insurance Bhaban 36, Dilkusha Commercial Area (2nd, 16th & 17th Floor),Dhaka-1000, Bangladesh",
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

  Widget _getLoans(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://dummyimage.com/600x400/2abd47/fff&text=trust")),
                  title: Text(
                    'ADVANCED AGAINST SALARY LOAN',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Life is continuously facing unforeseen events. For which sudden financial support is essential. We are at your side to meet up your urgency at any moment through our "Advance against salary" scheme.',
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
        itemCount: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
    DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: buildSideDrawer(context),
        appBar: getAppBar(context),
        body: Container(
          color: Colors.black,
          child: TabBarView(
            children: <Widget>[
              // SizedBox(height: 10,),
              _getInfo(context),
              _getLoans(context),
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
        "T I T L E",
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
