import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bank.dart';
// import '../providers/cart.dart';
import '../screens/bank_details_screen.dart';

class BankItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // BankItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final bank = Provider.of<Bank>(context, listen: false);
    // final cart = Provider.of<Cart>(context, listen: false);
    print('object');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              BankDetailsScreen.routeName,
              arguments: bank.id,
            );
          },
          child: Image.network(
            bank.image != null
                ? bank.image
                : 'https://dummyimage.com/600x400/2abd47/fff&text=BRAC',
            fit: BoxFit.cover,
          ),
        ),
        footer: Container(
          child: GridTileBar(
            backgroundColor: Colors.black54,
            leading: Consumer<Bank>(
              builder: (ctx, bank, _) => IconButton(
                icon: Icon(
                  bank.isFavorite ? 
                  Icons.bookmark 
                  : Icons.bookmark_border,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  bank.favouriteStatus();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: Text(
              bank.stockCode,
              style: TextStyle(fontSize: 12),
              // textAlign: TextAlign.center,
            ),
            subtitle: Text(
              bank.address,
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            // trailing: Text('hey'),
            // IconButton(
            //   icon: Icon(
            //     Icons.store,
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   onPressed: () {
            //     cart.addItem(bank.id, bank.title, bank.currency);
            //     Scaffold.of(context).hideCurrentSnackBar();
            //     Scaffold.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text(
            //           'Added For Next Confirmation !',
            //         ),
            //         duration: Duration(seconds: 2),
            //         action: SnackBarAction(
            //           label: 'UNDO',
            //           onPressed: () {
            //             cart.removeSingleBankItem(bank.id);
            //           },
            //         ),
            //       ),
            //     );
            //   },
            //   color: Theme.of(context).accentColor,
            // ),
          ),
        ),
      ),
    );
  }
}
