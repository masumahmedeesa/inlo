// // How a single user loan looks like ?

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../screens/edit_loan_screen.dart';
// import '../providers/loans.dart';

// class UserLoanItem extends StatelessWidget {
//   final String id;
//   final String title;
//   final String imageUrl;
//   UserLoanItem(
//     this.id,
//     this.title,
//     this.imageUrl,
//   );
//   @override
//   Widget build(BuildContext context) {
//     final scaffold = Scaffold.of(context);
//     return Card(
//       elevation: 10,
//       child: ListTile(
//         title: Text(title),
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage(imageUrl),
//         ),
//         trailing: Container(
//           width: 100,
//           child: Row(
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: () {
//                   Navigator.of(context)
//                       .pushNamed(EditLoanScreen.routeName, arguments: id);
//                 },
//                 color: Theme.of(context).primaryColor,
//               ),
//               IconButton(
//                 icon: Icon(Icons.delete),
//                 onPressed: () async {
//                   try {
//                     await Provider.of<Loans>(context, listen: false)
//                         .deleteLoan(id);
//                   } catch (error) {
//                     scaffold.showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           "Can't Deleting Loan",
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     );
//                   }
//                 },
//                 color: Theme.of(context).errorColor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
