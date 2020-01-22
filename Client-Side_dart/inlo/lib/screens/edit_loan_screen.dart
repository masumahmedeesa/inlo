// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/loan.dart';
// import '../providers/loans.dart';

// class EditLoanScreen extends StatefulWidget {
//   static const routeName = '/edit-loan';
//   @override
//   _EditLoanScreenState createState() => _EditLoanScreenState();
// }

// class _EditLoanScreenState extends State<EditLoanScreen> {
//   final _currencyFocus = FocusNode();
//   final _descriptionFocus = FocusNode();
//   final _imageController = TextEditingController();
//   final _imageUrlFocus = FocusNode();
//   final _form = GlobalKey<FormState>();

//   var _editLoan = Loan(
//     id: null,
//     title: '',
//     description: '',
//     currency: 0,
//     imageUrl: '',
//   );
//   var _initValues = {
//     'title': '',
//     'description': '',
//     'currency': '',
//     'imageUrl': '',
//   };
//   var _isInitS = true;
//   var _isLoading = false;

//   @override
//   void initState() {
//     _imageUrlFocus.addListener(_updateImage);
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_isInitS) {
//       final loanId = ModalRoute.of(context).settings.arguments as String;
//       if (loanId != null) {
//         _editLoan = Provider.of<Loans>(context, listen: false).findById(loanId);
//         _initValues = {
//           'title': _editLoan.title,
//           'description': _editLoan.description,
//           'currency': _editLoan.currency.toString(),
//           'imageUrl': '',
//         };
//         _imageController.text = _editLoan.imageUrl;
//       }
//     }
//     _isInitS = false;
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _imageUrlFocus.removeListener(_updateImage);
//     _imageUrlFocus.dispose();
//     _imageController.dispose();
//     _currencyFocus.dispose();
//     _descriptionFocus.dispose();
//     super.dispose();
//   }

//   void _updateImage() {
//     if (!_imageUrlFocus.hasFocus) {
//       if ((!_imageController.text.startsWith('http') &&
//           !_imageController.text.startsWith('https'))) {
//         return;
//       }
//       setState(() {});
//     }
//   }

// // 11 number video from http request e Future<void> chara kora ase
//   Future<void> _saveForm() async {
//     final isValid = _form.currentState.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     if (_editLoan.id != null) {
//       await Provider.of<Loans>(context, listen: false)
//           .updateLoan(_editLoan.id, _editLoan);
//       // setState(() {
//       //   _isLoading = false;
//       // });
//       // Navigator.of(context).pop();
//     } else {
//       try {
//         await Provider.of<Loans>(context, listen: false).addLoan(_editLoan);
//       } catch (error) {
//         await showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text('An error occured!'),
//             content: Text('Please check your data connection!'),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Okay'),
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       }
//       // finally {
//       //   setState(() {
//       //     _isLoading = false;
//       //   });
//       //   Navigator.of(context).pop();
//       // }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//     Navigator.of(context).pop();
//     // Navigator.of(context).pop();
//     // print(_editLoan.title);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           'E d i t L o a n',
//           style: TextStyle(
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveForm,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Form(
//                 key: _form,
//                 child: ListView(
//                   children: <Widget>[
//                     TextFormField(
//                       initialValue: _initValues['title'],
//                       decoration: InputDecoration(labelText: 'Title'),
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_currencyFocus);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Title Required!';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editLoan = Loan(
//                           id: _editLoan.id,
//                           title: value,
//                           description: _editLoan.description,
//                           currency: _editLoan.currency,
//                           imageUrl: _editLoan.imageUrl,
//                           isFavorite: _editLoan.isFavorite,
//                         );
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValues['currency'],
//                       decoration: InputDecoration(labelText: 'Currency'),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.number,
//                       focusNode: _currencyFocus,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_descriptionFocus);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Currency Required!';
//                         }
//                         if (double.tryParse(value) == null) {
//                           return 'Enter in Number Sir';
//                         }
//                         if (double.parse(value) <= 0) {
//                           return 'Enter a number greater than Zero';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editLoan = Loan(
//                           id: _editLoan.id,
//                           title: _editLoan.title,
//                           description: _editLoan.description,
//                           currency: double.parse(value),
//                           imageUrl: _editLoan.imageUrl,
//                           isFavorite: _editLoan.isFavorite,
//                         );
//                       },
//                     ),
//                     TextFormField(
//                       initialValue: _initValues['description'],
//                       decoration: InputDecoration(labelText: 'Description'),
//                       maxLines: 5,
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.multiline,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_imageUrlFocus);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Description Required!';
//                         }
//                         if (value.length < 10) {
//                           return 'Should be greater than 10 Characters';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editLoan = Loan(
//                           id: _editLoan.id,
//                           title: _editLoan.title,
//                           description: value,
//                           currency: _editLoan.currency,
//                           imageUrl: _editLoan.imageUrl,
//                           isFavorite: _editLoan.isFavorite,
//                         );
//                       },
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         Container(
//                           width: 100,
//                           height: 100,
//                           margin: EdgeInsets.only(
//                             top: 8,
//                             right: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               width: 1,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           child: _imageController.text.isEmpty
//                               ? Text('Enter Image Url')
//                               : FittedBox(
//                                   child: Image.network(_imageController.text),
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                         Expanded(
//                           child: TextFormField(
//                             decoration: InputDecoration(labelText: 'Image'),
//                             keyboardType: TextInputType.url,
//                             textInputAction: TextInputAction.done,
//                             controller: _imageController,
//                             focusNode: _imageUrlFocus,
//                             onFieldSubmitted: (_) {
//                               _saveForm();
//                             },
//                             onSaved: (value) {
//                               _editLoan = Loan(
//                                 id: _editLoan.id,
//                                 title: _editLoan.title,
//                                 description: _editLoan.description,
//                                 currency: _editLoan.currency,
//                                 imageUrl: value,
//                                 isFavorite: _editLoan.isFavorite,
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
