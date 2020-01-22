import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../providers/banks.dart';
import '../providers/loans.dart';
import '../screens/bank_details_screen.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final _pro = Provider.of<Banks>(context, listen: false);

    // final banksData = Provider.of<Banks>(context);
    final loansData = Provider.of<Loans>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            filled: true,
            border: InputBorder.none,
            hintText: 'Search Loan Here',
            // prefixIcon: Icon(
            //   Icons.search,
            // ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                _searchController.text = "";
              },
            ),
          ),
          onSubmitted: (input) {
            print(input);
            print('input submitted');
            setState(() {
              // Provider.of<Banks>(context, listen: false)
              //     .getSearchBank(input, clearExisting: true);
              Provider.of<Loans>(context, listen: false)
                  .getSearchLoan(input, clearExisting: true);
            });
          },
        ),
      ),
      body: Container(
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
                return loansData.search.length > 0
                    ? ListView.builder(
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  BankDetailsScreen.routeName,
                                  arguments: loansData.search[i].bankId,
                                );
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    // loansData.search[i].image == null
                                    // ?
                                    "https://dummyimage.com/600x400/2abd47/fff&text=${loansData.search[i].stockCode[0]}"
                                    // : loansData.search[i].image,
                                    ),
                              ),
                              title: Text(
                                "${loansData.search[i].name} by ${loansData.search[i].stockCode}",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                loansData.search[i].description,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                ),
                              ),
                              // trailing: Text('Trust Bank', style:clr),
                            ),
                          );
                        },
                        itemCount: loansData.search.length,
                      )
                    : Center(
                        child: Text(
                          'আপনি এখনো কিছুই খুঁজুন নি অথবা যা খুজতেসেন তা ডাটাবেসে নেই :(',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
              }
            }
          },
        ),
      ),
    );
  }
}
