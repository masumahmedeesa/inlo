import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './idea_card.dart';
import '../../models/idea.dart';
import '../../scoped-models/main.dart';

class Ideas extends StatelessWidget {
  Widget _buildIdeaList(List<Idea> ideas) {
    Widget ideaCards;
    print('next');
    print(ideas.length);
    // print(ideas[0].title); 
    if (ideas.length > 0) {
      ideaCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            IdeaCard(ideas[index]),
        itemCount: ideas.length,
      );
    } else {
      ideaCards = Container(
        child: SizedBox(height: 120,),
      );
    }
    return ideaCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Ideas Widget] build()'); 
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return  _buildIdeaList(model.displayedIdeas);
    },);
  }
}
