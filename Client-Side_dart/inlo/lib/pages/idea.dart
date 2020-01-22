import 'dart:async';

import 'package:flutter/material.dart';
// import '../widgets/helpers/read_more_text.dart';

import 'package:scoped_model/scoped_model.dart';
import '../widgets/ideas/price_tag.dart';
import '../widgets/ui_elements/title_default.dart';
import '../models/idea.dart';
import '../scoped-models/main.dart';
// import '../models/profile.dart';
// import '../scoped-models/main.dart';
import '../widgets/utility/callMessage.dart';
import '../widgets/utility/serviceLocator.dart';

class IdeaPage extends StatefulWidget {
  final Idea idea;
  final MainModel model;

  IdeaPage(
    this.idea,
    this.model,
  );

  @override
  _IdeaPageState createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  final String number = "01786122963";
  // final String email = "dancamdev@example.com";

  @override
  initState() {
    widget.model.fetchComments(widget.idea.id, clearExisting: true);
    widget.model.fetchProfiles(onlyForUser: true);
    // print(widget.model.allProfiles[0].name);
    super.initState();
  }

  final _commentController = TextEditingController();
  final _reportController = TextEditingController();

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleDefault(widget.idea.title),
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
          PriceTag(widget.idea.price.toString())
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
          Text(
            widget.idea.description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.idea.userEmail,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _modalReport(BuildContext context, Widget child, MainModel model) {
    showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0.7),
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
              child: _reportBox(context, child, model),
            ),
          );
        });
  }

  Column _reportBox(BuildContext context, Widget child, MainModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Are you sure to Report this Promotion? Then please tell us in brief why you gonna report this?",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Alert : Please give the valid reasons or you will be banned with your promotion!",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 18,
            ),
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomLeft,
          child: Container(
            // width: 120,
            // height: 50,
            padding: EdgeInsets.all(8),
            child:
                // _buildCommentController()
                TextFormField(
              maxLines: 5,
              // maxLength: 3,
              controller: _reportController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Write your report..',
                // prefixIcon: Icon(Icons.camera_alt),
                // suffixIcon:
                // IconButton(
                //     icon: Icon(Icons.send),
                //     onPressed: () {
                //       model
                //           .addComment(
                //               _commentController.text,
                //               widget.idea.id,
                //               widget.model.allProfiles[0].name,
                //               widget.model.allProfiles[0].image)
                //           .then((bool success) {
                //         if (success) {
                //           _reportController.text = "";
                //           Navigator.of(context).pop();
                //         } else {
                //           showDialog(
                //               context: context,
                //               builder: (BuildContext context) {
                //                 return AlertDialog(
                //                   title: Text('Something went wrong'),
                //                   content: Text('Please try again!'),
                //                   actions: <Widget>[
                //                     FlatButton(
                //                       onPressed: () =>
                //                           Navigator.of(context).pop(),
                //                       child: Text('Okay'),
                //                     )
                //                   ],
                //                 );
                //               });
                //         }
                //       });
                //     }),
                contentPadding: EdgeInsets.all(7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width,
            height: 30,
            child: RaisedButton(
              onPressed: () {
                model
                    .addReport(
                        _reportController.text,
                        widget.idea.id,
                        widget.idea.title,
                        widget.model.allProfiles[0].name,
                        widget.model.allProfiles[0].image)
                    .then((bool success) {
                  if (success) {
                    _reportController.text = "";
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
              child: Text(
                'Send Report',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _modal(BuildContext context, Widget child, MainModel model) {
    showModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0.7),
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
        model.allComments.length > 0
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: model.allComments.length,
                itemBuilder: (ctx, i) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: model.allComments[i].image != null
                          ? NetworkImage(model.allComments[i].image)
                          : NetworkImage(
                              'https://dummyimage.com/600x400/2abd47/fff&text=error'),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(model.allComments[i].userName),
                        Text(
                          model.allComments[i].commentBox,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  );
                })
            // _listTile(context, child, model)
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('No Comments yet !'),
              ),
        Align(
          alignment: FractionalOffset.bottomLeft,
          child: Container(
            // width: 120,
            // height: 50,
            padding: EdgeInsets.all(8),
            child:
                // _buildCommentController()
                TextFormField(
              maxLines: 3,
              // maxLength: 3,
              controller: _commentController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Write a comment..',
                // prefixIcon: Icon(Icons.camera_alt),
                suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      model
                          .addComment(
                              _commentController.text,
                              widget.idea.id,
                              widget.model.allProfiles[0].name,
                              widget.model.allProfiles[0].image)
                          .then((bool success) {
                        if (success) {
                          _commentController.text = "";
                          Navigator.of(context).pop();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Something went wrong'),
                                  content: Text('Please try again!'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text('Okay'),
                                    )
                                  ],
                                );
                              });
                        }
                      });
                    }),
                contentPadding: EdgeInsets.all(7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _listTile(BuildContext context, Widget child, MainModel model) {
  //   return ListView.builder(
  //       itemCount: model.allComments.length,
  //       itemBuilder: (context, i) {
  //         return ListTile(
  //           leading: CircleAvatar(
  //             backgroundImage: model.allComments[i].image != null
  //                 ? NetworkImage(model.allComments[i].image)
  //                 : NetworkImage(
  //                     'https://dummyimage.com/600x400/2abd47/fff&text=error'),
  //           ),
  //           title: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Text(model.allComments[i].userName),
  //               Text(
  //                 model.allComments[i].commentBox,
  //                 style: TextStyle(
  //                   color: Colors.grey[800],
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           subtitle: Text(
  //             'Reply',
  //             style: TextStyle(
  //               fontSize: 12,
  //             ),
  //           ),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            widget.idea.title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.mail),
          onPressed: () {
            _service.sendEmail(widget.model.allProfiles[0].userEmail);
          },
        ),
        body: SingleChildScrollView(
          child: Container(
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
                      child: widget.idea.image != null
                          ? Image.network(
                              widget.idea.image,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Container()
                      // Image.asset(
                      //   'assets/dbbl.jpeg',
                      //   fit: BoxFit.cover,
                      // ),
                      ),
                  _buildTitlePriceRow(),
                  _setupOthers(context),
                  ScopedModelDescendant<MainModel>(builder:
                      (BuildContext context, Widget child, MainModel model) {
                    return Container(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                        height: 30,
                        child: Column(
                          children: <Widget>[
                            RaisedButton(
                              color: Colors.amber,
                              child: Text(
                                "Call",
                              ),
                              onPressed: () => _service.call(number),
                            ),
                            RaisedButton(
                              color: Colors.purple,
                              onPressed: () {
                                _modalReport(context, child, model);
                              },
                              child: Text(
                                'Report',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                _modal(context, child, model);
                              },
                              child: Text(
                                'Comment',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
