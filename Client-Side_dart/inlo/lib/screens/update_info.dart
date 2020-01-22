import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../screens/update_edit.dart';

class UpdateInfo extends StatefulWidget {
  final MainModel model;
  UpdateInfo(this.model);

  @override
  _UpdateInfoState createState() => _UpdateInfoState();
}

class _UpdateInfoState extends State<UpdateInfo> {
  @override
  void initState() {
    widget.model.fetchProfiles(onlyForUser: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int i, MainModel model) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Colors.white,
      ),
      onPressed: () {
        model.selectProfile(model.allProfiles[i].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return UpdateEdit();
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
      return Container(
        padding: EdgeInsets.only(
          top: 15.0,
          left: 15,
          right: 5,
        ),
        color: Colors.black,
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            return model.allProfiles.length != 1
                ? Center(
                    child: Column(children: <Widget>[
                      Text(
                        'Please Update Your Information First !',
                        style: TextStyle(
                          color: Colors.pink,
                        ),
                      ),
                      RaisedButton(
                        child: Text('U P D A T E'),
                        onPressed: () {},
                      ),
                    ]),
                  )
                : Column(
                    children: <Widget>[
                      info(context, "Email", model.allProfiles[i].userEmail),
                      info(context, "Name", model.allProfiles[i].name),
                      info(context, "NID", model.allProfiles[i].nid),
                      info(context, "Date Of Birth", model.allProfiles[i].dob),
                      RaisedButton(
                        onPressed: () {},
                        color: Theme.of(context).primaryColor,
                        child: _buildEditButton(context, i, model),
                      ),
                    ],
                  );
          },
          itemCount: 1,
        ),
      );
      // );
    });
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
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
  
}
