// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../screens/edit_loan_screen.dart';
// import '../providers/loans.dart';
// import '../widgets/user_loan_item.dart';
// import '../widgets/app_drawer.dart';

// class UserLoanScreen extends StatelessWidget {
//   static const routeName = '/user-loans';

//   Future<void> _refreshLoans(BuildContext context) async {
//     await Provider.of<Loans>(context).getLoanSetLoan();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loanData = Provider.of<Loans>(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           'A D M I N  P A N E L',
//           style: TextStyle(
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.playlist_add),
//             onPressed: () {
//               Navigator.of(context).pushNamed(EditLoanScreen.routeName);
//             },
//           )
//         ],
//       ),
//       drawer: buildSideDrawer(context),
//       body: RefreshIndicator(
//         onRefresh: () => _refreshLoans(context),
//         child: Container(
//           color: Colors.black,
//           child: Padding(
//             padding: EdgeInsets.all(10),
//             child: ListView.builder(
//               itemCount: loanData.items.length,
//               itemBuilder: (_, index) => UserLoanItem(
//                 loanData.items[index].id,
//                 loanData.items[index].title,
//                 loanData.items[index].imageUrl,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
