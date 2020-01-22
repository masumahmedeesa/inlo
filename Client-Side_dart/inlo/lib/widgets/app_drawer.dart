import 'package:flutter/material.dart';
import './ui_elements/logout_list_tile.dart';
import '../screens/user_loan_screen.dart';
// import '../screens/orders_screen.dart';

Widget buildSideDrawer(BuildContext context) {
  return Drawer(
    child: Container(
      color: Colors.grey[900],
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'I n l o',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            backgroundColor: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.attach_money,
              color: Colors.white,
            ),
            title: Text(
              'Loans',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/banks');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.redeem,
              color: Colors.white,
            ),
            title: Text(
              'Saved Loans',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Navigator.of(context)
                  Navigator.pushReplacementNamed(context, '/approve');
            },
          ),

          // ListTile(
          //   leading: Icon(
          //     Icons.edit,
          //     color: Colors.white,
          //   ),
          //   title: Text(
          //     'Admin Panel',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onTap: () {
          //     Navigator.of(context)
          //         .pushReplacementNamed(UserLoanScreen.routeName);
          //   },
          // ),

          ListTile(
            leading: Icon(
              Icons.wb_incandescent,
              color: Colors.white,
            ),
            title: Text(
              'All Ideas',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.unfold_more,
              color: Colors.white,
            ),
            title: Text(
              'Manage Ideas',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.unfold_more,
          //     color: Colors.white,
          //   ),
          //   title: Text(
          //     'test',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   onTap: () {
          //     Navigator.pushReplacementNamed(context, '/loan-tab');
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.update,
              color: Colors.white,
            ),
            title: Text(
              'Update Profile',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/update');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    ),
  );
}
