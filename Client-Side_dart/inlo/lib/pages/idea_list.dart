import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './idea_edit.dart';
import '../scoped-models/main.dart';

class IdeaListPage extends StatefulWidget {
  final MainModel model;

  IdeaListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _IdeaListPageState();
  }
}

class _IdeaListPageState extends State<IdeaListPage> {
  @override
  initState() {
    widget.model.fetchIdeas(onlyForUser: true, clearExisting: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      onPressed: () {
        model.selectIdea(model.allIdeas[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return IdeaEditPage();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allIdeas[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectIdea(model.allIdeas[index].id);
                  model.deleteIdea();
                } else if (direction == DismissDirection.startToEnd) {
                  print('Swiped start to end');
                } else {
                  print('Other swiping');
                }
              },
              // background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: model.allIdeas[index].image != null
                          ? NetworkImage(model.allIdeas[index].image)
                          : NetworkImage(
                              'https://dummyimage.com/600x400/2abd47/fff&text=error'),
                    ),
                    title: Text(
                      model.allIdeas[index].title,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Revenue BDT ${model.allIdeas[index].price.toString()}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allIdeas.length,
        );
      },
    );
  }
}
