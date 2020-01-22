import 'package:flutter/material.dart';

import './idea_edit.dart';
import './idea_list.dart';
// import '../widgets/ui_elements/logout_list_tile.dart';
import '../widgets/app_drawer.dart';
import '../scoped-models/main.dart';

class IdeasAdminPage extends StatelessWidget {
  final MainModel model;

  IdeasAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        drawer: buildSideDrawer(context),
        appBar: getAppBar(context),
        body: TabBarView(
          children: <Widget>[IdeaEditPage(), IdeaListPage(model)],
        ),
      ),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black,
      title: Text(
        "M A N A G E  I D E A S",
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
              child: Text('C R E A T E'),
            ),
          ),
          // text: "INFO",
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Text('Y O U R S'),
            ),
          ),
        ],
      ),
    );
  }

}
