import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

import '../providers/loans.dart';

class Individual extends StatefulWidget {
  static const routeName = '/individual';
  final MainModel model;
  Individual(this.model);

  @override
  _IndividualState createState() => _IndividualState();
}

class _IndividualState extends State<Individual> {
  final clr = TextStyle(color: Colors.grey[400]);

  final clr2 = TextStyle(color: Colors.pink);

  final _propertyController = TextEditingController();
  final _salaryController = TextEditingController();
  final _howController = TextEditingController();
  final _causeController = TextEditingController();

  String loanId;
  var loadedLoan;

  @override
  void initState() {
    widget.model.fetchProfiles(onlyForUser: true);
    super.initState();
  }

  void _modal(BuildContext context, Widget child, MainModel model) {
    showModalBottomSheet(
        // backgroundColor: Colors.white.withOpacity(1),
        context: context,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: _bottomCommentBox(context, child, model),
            ),
          );
        });
  }

  Column _bottomCommentBox(
      BuildContext context, Widget child, MainModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
              'Are you sure to take this loan? If sure, please read Eligibility section carefully. If not, we may reject you'),
        ),
        Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'Please Fill Following Form Carefully, Scroll up or Down if necessary. Say in Brief.',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            controller: _salaryController,
            decoration: InputDecoration(
              hintText: 'Your Salary or Income',
              contentPadding: EdgeInsets.all(7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            maxLines: 2,
            controller: _propertyController,
            decoration: InputDecoration(
              hintText: 'Property Status or Business',
              contentPadding: EdgeInsets.all(7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            maxLines: 2,
            controller: _howController,
            decoration: InputDecoration(
              hintText: 'How do you repay ?',
              contentPadding: EdgeInsets.all(7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            maxLines: 2,
            controller: _causeController,
            decoration: InputDecoration(
              hintText: 'Why do you take this one?',
              contentPadding: EdgeInsets.all(7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            // width: 120,
            // height: 50,
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              child: Text('Send Request'),
              onPressed: () {
                model
                    .addRequest(
                  widget.model.allProfiles[0].name,
                  widget.model.allProfiles[0].userEmail,
                  _salaryController.text,
                  _propertyController.text,
                  _howController.text,
                  _causeController.text,
                  loanId,
                  loadedLoan.stockCode,
                  loadedLoan.bankId,
                  loadedLoan.name,
                )
                    .then((bool success) {
                  if (success) {
                    _salaryController.text = "";
                    _propertyController.text = "";
                    _howController.text = "";
                    _causeController.text = "";
                    Navigator.of(context).pop();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Sending Successfully!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Something went wrong'),
                            content: Text('Please try again!'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Okay'),
                              )
                            ],
                          );
                        });
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    loanId = ModalRoute.of(context).settings.arguments as String;
    loadedLoan =
        Provider.of<Loans>(context, listen: false).findById(loanId);
    print(loadedLoan);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          loadedLoan.name,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 15.0,
          left: 5,
          right: 5,
        ),
        color: Colors.black,
        child: Column(
          children: <Widget>[
            info(context, "Name", loadedLoan.name),
            info(context, "Description", loadedLoan.description),
            info(context, "Loan Amount", loadedLoan.loanAmount),
            info(context, "Tenure", loadedLoan.tenure),
            info(context, "Interest Rate", loadedLoan.interestRate),
            info(context, "Conditions", loadedLoan.conditions),
            info(context, "Eligibility", loadedLoan.eligibility),
            ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
              return Container(
                child: RaisedButton(
                  onPressed: () {
                    _modal(context, child, model);
                  },
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'Send Request',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
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
}
