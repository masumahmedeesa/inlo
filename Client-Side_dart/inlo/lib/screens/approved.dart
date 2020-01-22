import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:provider/provider.dart';
// import '../providers/banks.dart';
// import '../providers/loans.dart';
import '../screens/bank_details_screen.dart';
import '../scoped-models/main.dart';
import '../widgets/app_drawer.dart';

class Approve extends StatefulWidget {
  static const routeName = '/approve';

  final MainModel model;
  Approve(this.model);

  @override
  _ApproveState createState() => _ApproveState();
}

class _ApproveState extends State<Approve> {
  @override
  void initState() {
    widget.model.fetchApproved(onlyForUser: true, clearExisting: true);
    // print('hi');
    // Provider.of<Loans>(context).
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final _pro = Provider.of<Banks>(context, listen: false);

    // final banksData = Provider.of<Banks>(context);
    // Provider.of<Loans>(context)
        // .getApprove(widget.model.allProfiles[0].userId);
        // .getApprove("IxJ7TrVPb5RhAc20z0VNTtuvQ922");
        
    // final data = Provider.of<Loans>(context).apprs;
    // print(data.length);
    // print('approved');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text(
          'A P P R O V E D',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      drawer: buildSideDrawer(context),
      body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          child: FutureBuilder(
            // future: Provider.of<Banks>(context, listen: false).getSearchBank(_searchController.text),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.error != null) {
                  return Center(
                    child: Text('An error occurred!'),
                  );
                } else {
                  return model.allApproved.length > 0
                      ? ListView.builder(
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                onTap: () {
                                  // Navigator.of(context).pushNamed(
                                  //   BankDetailsScreen.routeName,
                                  //   arguments: model.allApproved[i].bankId,
                                  // ); 
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      // loansData.search[i].image == null
                                      // ?
                                      "https://dummyimage.com/600x400/2abd47/fff&text=${model.allApproved[i].stockCode[0]}"
                                      // : loansData.search[i].image, 
                                      ),
                                ),
                                title: Text(
                                  "${model.allApproved[i].loanName} by ${model.allApproved[i].stockCode}",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "${model.allApproved[i].userName} সাহেব, বিস্তারিত ${model.allApproved[i].userEmail} তে পাঠানো হয়েসে! Salary: ${model.allApproved[i].salary} & Property: ${model.allApproved[i].property} Please come to Bank to take loan. ধন্যবাদ :)",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 10,
                                  ),
                                ),
                                // trailing: Text('Trust Bank',),
                              ),
                            );
                          },
                          itemCount: model.allApproved.length,
                        )
                      : Center(
                          child: Text(
                            'আপনি এখনো কোন ঋণের জন্য আবেদন করেন নি :(',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                }
              }
            },
          ),
        );
      }),
    );
  }
}
