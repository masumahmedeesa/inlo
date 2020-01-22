import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/ideas/ideas.dart';
import '../widgets/app_drawer.dart';
import '../scoped-models/main.dart';

class IdeasPage extends StatefulWidget {
  final MainModel model;

  IdeasPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _IdeasPageState();
  }
}

class _IdeasPageState extends State<IdeasPage> {
  @override
  initState() {
    widget.model.fetchIdeas();
    super.initState();
  }

  Widget _buildIdeasList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        print('in ideas');
        Widget content = Center(
            child: Text(
          'No Ideas Found :(',
          style: TextStyle(
            color: Colors.white,
          ),
        ));
        // if (model.displayedIdeas.length > 0 && !model.isLoading) {
        if (model.displayedIdeas.length > 0 && !model.isLoading) {
          content = Ideas();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: model.fetchIdeas,
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: buildSideDrawer(context),
      appBar: AppBar(
        title: Center(
          child: Text(
            'I n l o',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: _buildIdeasList(),
    );
  }
}
