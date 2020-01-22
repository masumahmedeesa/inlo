import 'package:flutter/material.dart';
// import '../screens/update_info.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/app_drawer.dart';
import 'update_edit.dart';
import '../scoped-models/main.dart';

class Update extends StatefulWidget {
  // static const routeName = '/update';
  final MainModel model;
  Update(this.model);
  // bool hey = false;

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  @override
  void initState() {
    widget.model.fetchProfiles(onlyForUser: true, clearExisting: true);
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

  Widget _updateInfo(BuildContext context, Widget child, MainModel model) {
    // return ScopedModelDescendant<MainModel>(
    //     builder: (BuildContext context, Widget child, MainModel model) {
    return Container(
      padding: EdgeInsets.only(
        top: 15.0,
        left: 15,
        right: 5,
      ),
      color: Colors.black,
      child: FutureBuilder(
        // future: widget.model.fetchProfiles(onlyForUser: true),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return ListView.builder(
                itemBuilder: (ctx, i) {
                  return Column(
                    children: <Widget>[
                      info(
                          context,
                          "Email",
                          model.allProfiles[i].userEmail.isEmpty
                              ? ""
                              : model.allProfiles[i].userEmail),
                      info(
                          context,
                          "Name",
                          model.allProfiles[i].name.isEmpty
                              ? ""
                              : model.allProfiles[i].name),
                      info(
                          context,
                          "NID",
                          model.allProfiles[i].nid.isEmpty
                              ? ""
                              : model.allProfiles[i].nid),
                      info(
                          context,
                          "Date Of Birth",
                          model.allProfiles[i].dob.isEmpty
                              ? ""
                              : model.allProfiles[i].dob),
                      info(context, "I M A G E", ""),
                      Image.network(
                        model.allProfiles[i].image,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 5),
                      info(context, "Verified", "Yes"),
                      info(context, "E D I T", ""),
                      _buildEditButton(context, i, model),
                    ],
                  );
                },
                itemCount: model.allProfiles.length,
              );
            }
          }
        },
      ),
    );
    // );
    // });
  }

  Widget info(BuildContext context, String prothom, String ditio) {
    return Container(
      // padding: EdgeInsets.only(top: 15.0, left: 8.0), eesha@eesha.com test@test.com
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

  @override
  Widget build(BuildContext context) {
    print('whole universe');
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return DefaultTabController(
          // length: widget.model.allProfiles
          length: 2,
          child: Scaffold(
            drawer: buildSideDrawer(context),
            appBar: getAppBar(context),
            body: Container(
              color: Colors.black,
              child: TabBarView(
                children: <Widget>[
                  model.allProfiles.isEmpty
                      ? Center(
                          child: Text(
                            'Please Update Profile First, okay? :)',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : _updateInfo(context, child, model),
                  model.allProfiles.isNotEmpty
                      ? Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Thank you, You have Successfully Updated your National Identification ! Stay Tuned :)',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : UpdateEdit(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black,
      title: Text(
        "U P D A T E  P R O F I L E",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      bottom: TabBar(
        // indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Theme.of(context).primaryColor,
        // unselectedLabelStyle: TextStyle(),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.redAccent,
        ),
        tabs: <Widget>[
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Text('I N F O'),
            ),
          ),
          // text: "INFO",
          Tab(
            child: Align(
              alignment: Alignment.center,
              child: Text('U P D A T E'),
            ),
          ),
        ],
      ),
    );
  }
}
