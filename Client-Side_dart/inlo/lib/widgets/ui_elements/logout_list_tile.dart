import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';

class LogoutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          leading: Icon(
            Icons.explicit,
            color: Colors.white,
          ),
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            model.logout();
          },
        );
      },
    );
  }
}
