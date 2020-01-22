import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
// import './address_tag.dart';
import '../helpers/read_more_text.dart';
import '../ui_elements/title_default.dart';
import '../../models/idea.dart';
import '../../scoped-models/main.dart';

class IdeaCard extends StatelessWidget {
  final Idea idea;
  // final int ideaIndex;

  IdeaCard(
    this.idea,
  );

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleDefault(idea.title),
              Text(
                'Chok Bazar, Road 5, Block B, Dhaka',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(idea.price.toString())
        ],
      ),
    );
  }

  Widget _setupOthers(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // AddressTag('Union Square, San Francisco'),
          // Text(
          //   idea.description,
          //   style: TextStyle(
          //     color: Colors.grey[400],
          //     fontSize: 10,
          //   ),
          // ),
          ReadMoreText(
            idea.description,
            trimLines: 3,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Line,
            trimCollapsedText: '...Show more',
            trimExpandedText: ' show less',
          ),
          Text(
            'Email : ' + idea.userEmail,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Row(
            // alignment: MainAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            // buttonHeight: 10,
            children: <Widget>[
              ButtonTheme(
                minWidth: 30,
                height: 20,
                child: FlatButton(
                  color: Colors.white,
                  child: Text(
                    'Details',
                  ),
                  onPressed: () =>
                      Navigator.pushNamed<bool>(context, '/idea/' + idea.id),
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.details),
              //   color: Theme.of(context).primaryColorLight,
              //   onPressed: () => Navigator.pushNamed<bool>(
              //       context, '/idea/' + model.allIdeas[ideaIndex].id),
              // ),
              IconButton(
                icon: Icon(
                    idea.isFavorite ? Icons.favorite : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.selectIdea(idea.id);
                  model.toggleIdeaFavoriteStatus();
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(6),
      // color: Colors.black,
      child: Card(
        color: Colors.grey[800],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              
              borderRadius: BorderRadius.circular(5),
              child: idea.image != null
                  ? Image.network(
                      idea.image,
                      height: 220.0,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    )
                  // FadeInImage(
                  //     image: NetworkImage(idea.image),
                  //     // height: 300.0,
                  //     fit: BoxFit.cover,
                  //     placeholder: AssetImage('assets/food.jpg'),
                  //   )
                  : Container(),
            ),
            _buildTitlePriceRow(),
            _setupOthers(context),
          ],
        ),
      ),
    );
  }
}
