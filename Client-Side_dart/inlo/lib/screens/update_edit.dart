// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/profileProvider.dart';
// // import '../providers/profiles.dart';
// import '../models/profile.dart';
// import '../widgets/utility/image_profile.dart';

// class UpdateEdit extends StatefulWidget {
//   static const routeName = '/update';
//   @override
//   _UpdateEditState createState() => _UpdateEditState();
// }

// class _UpdateEditState extends State<UpdateEdit> {
//   final _currencyFocus = FocusNode();
//   final _descriptionFocus = FocusNode();
//   final _imageController = TextEditingController();
//   final _imageUrlFocus = FocusNode();
//   final _form = GlobalKey<FormState>();

//   var _editProfile = Profile(
//     id: null,
//     name: '',
//     nid: '',
//     dob: '',
//     image: '',
//     imagePath: '',
//     userId: '',
//     userEmail: '',
//   );

//   var _initValues = {
//     'name': '',
//     'nid': '',
//     'dob': '',
//     'image': '',
//   };

//   var _isInitS = true;
//   var _isLoading = false;

//   @override
//   void initState() {
//     _imageUrlFocus.addListener(_updateImage);
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_isInitS) {
//       final profileId = ModalRoute.of(context).settings.arguments as String;
//       if (profileId != null) {
//         _editProfile =
//             Provider.of<Profiles>(context, listen: false).findById(profileId);
//         _initValues = {
//           'name': _editProfile.name,
//           'nid': _editProfile.nid,
//           'dob': _editProfile.dob,
//           'image': '',
//         };
//         _imageController.text = _editProfile.image;
//       }
//     }
//     _isInitS = false;
//     // Provider.of<Profile>(context).
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _imageUrlFocus.removeListener(_updateImage);
//     _imageUrlFocus.dispose();
//     _imageController.dispose();
//     _currencyFocus.dispose();
//     _descriptionFocus.dispose();
//     super.dispose();
//   }

//   void _updateImage() {
//     if (!_imageUrlFocus.hasFocus) {
//       if ((!_imageController.text.startsWith('http') &&
//           !_imageController.text.startsWith('https'))) {
//         return;
//       }
//       setState(() {});
//     }
//   }

//   void _setImage(File image) {
//     _formData['image'] = image;
//   }

// // 11 number video from http request e Future<void> chara kora ase
//   Future<void> _saveForm() async {
//     final isValid = _form.currentState.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     if (_editProfile.id != null) {
//       await Provider.of<Profiles>(context, listen: false)
//           .updateProfile(_editProfile.id, _editProfile);
//       print('hey');
//     } else {
//       try {
//         await Provider.of<Profiles>(context, listen: false)
//             .addProfile(_editProfile);
//       } catch (error) {
//         await showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text('An error occured!'),
//             content: Text('Please check your data connection!'),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Okay'),
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       }
//       // finally {
//       //   setState(() {
//       //     _isLoading = false;
//       //   });
//       //   Navigator.of(context).pop();
//       // }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//     // Navigator.of(context).pop();
//     // Navigator.of(context).pop();
//     print(_editProfile.name);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? Center(
//             child: CircularProgressIndicator(),
//           )
//         : Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Form(
//               key: _form,
//               child: ListView(
//                 children: <Widget>[
//                   TextFormField(
//                     initialValue: _initValues['name'],
//                     decoration: InputDecoration(labelText: 'Full Name'),
//                     textInputAction: TextInputAction.next,
//                     onFieldSubmitted: (_) {
//                       FocusScope.of(context).requestFocus(_currencyFocus);
//                     },
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'Name Required!';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _editProfile = Profile(
//                         id: _editProfile.id,
//                         name: value,
//                         nid: _editProfile.nid,
//                         dob: _editProfile.dob,
//                         image: _editProfile.image,
//                         imagePath: _editProfile.imagePath,
//                         userEmail: _editProfile.userEmail,
//                         userId: _editProfile.userId,
//                       );
//                     },
//                   ),
//                   TextFormField(
//                     initialValue: _initValues['dob'],
//                     decoration: InputDecoration(labelText: 'Date of Birth'),
//                     textInputAction: TextInputAction.next,
//                     keyboardType: TextInputType.number,
//                     focusNode: _currencyFocus,
//                     onFieldSubmitted: (_) {
//                       FocusScope.of(context).requestFocus(_descriptionFocus);
//                     },
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'Currency Required!';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _editProfile = Profile(
//                         id: _editProfile.id,
//                         name: _editProfile.name,
//                         nid: _editProfile.nid,
//                         dob: value,
//                         image: _editProfile.image,
//                         imagePath: _editProfile.imagePath,
//                         userEmail: _editProfile.userEmail,
//                         userId: _editProfile.userId,
//                       );
//                     },
//                   ),
//                   TextFormField(
//                     initialValue: _initValues['nid'],
//                     decoration: InputDecoration(labelText: 'N ID'),
//                     textInputAction: TextInputAction.next,
//                     keyboardType: TextInputType.multiline,
//                     onFieldSubmitted: (_) {
//                       FocusScope.of(context).requestFocus(_imageUrlFocus);
//                     },
//                     validator: (value) {
//                       if (value.isEmpty) {
//                         return 'Description Required!';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _editProfile = Profile(
//                         id: _editProfile.id,
//                         name: _editProfile.name,
//                         nid: value,
//                         dob: _editProfile.dob,
//                         image: _editProfile.image,
//                         imagePath: _editProfile.imagePath,
//                         userEmail: _editProfile.userEmail,
//                         userId: _editProfile.userId,
//                       );
//                     },
//                   ),
//                   ImageInputProfile(_setImage, profile),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: <Widget>[
//                       Container(
//                         width: 100,
//                         height: 100,
//                         margin: EdgeInsets.only(
//                           top: 8,
//                           right: 8,
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             width: 1,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         child: _imageController.text.isEmpty
//                             ? Text('Enter Image Url')
//                             : FittedBox(
//                                 child: Image.network(_imageController.text),
//                                 fit: BoxFit.cover,
//                               ),
//                       ),
//                       Expanded(
//                         child: TextFormField(
//                           decoration: InputDecoration(labelText: 'Image'),
//                           keyboardType: TextInputType.url,
//                           textInputAction: TextInputAction.done,
//                           controller: _imageController,
//                           focusNode: _imageUrlFocus,
//                           onFieldSubmitted: (_) {
//                             _saveForm();
//                           },
//                           onSaved: (value) {
//                             _editProfile = Profile(
//                               id: _editProfile.id,
//                               name: _editProfile.name,
//                               nid: _editProfile.nid,
//                               dob: _editProfile.dob,
//                               image: value,
//                               imagePath: _editProfile.imagePath,
//                               userEmail: _editProfile.userEmail,
//                               userId: _editProfile.userId,
//                             );
//                           },
//                         ),
//                       ),
//                       RaisedButton(
//                         child: Text('submit'),
//                         onPressed: _saveForm,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/helpers/ensure_visible.dart';
import '../models/profile.dart';
import '../scoped-models/main.dart';

import '../widgets/utility/image_profile.dart';

class UpdateEdit extends StatefulWidget {
  static const routeName = '/update-edit';
  @override
  State<StatefulWidget> createState() {
    return _UpdateEditState();
  }
}

class _UpdateEditState extends State<UpdateEdit> {
  final Map<String, dynamic> _formData = {
    'name': null,
    'nid': null,
    'dob': null,
    'image': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();

  Widget _buildTitleTextField(Profile profile) {
    if (profile == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (profile != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = profile.name;
    } else if (profile != null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else if (profile == null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else {
      _titleTextController.text = '';
    }
    return EnsureVisibleWhenFocused(
      focusNode: _titleFocusNode,
      child: TextFormField(
        style: TextStyle(
          color: Colors.green,
        ),
        focusNode: _titleFocusNode,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          labelText: "Full Name",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.pink,
              // width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              // width: 0.0,
            ),
          ),
        ),
        controller: _titleTextController,
        // initialValue: profile == null ? '' : profile.title,
        validator: (String value) {
          // if (value.trim().length <= 0) { 
          if (value.isEmpty) {
            return 'Name is required';
          }
        },
        onSaved: (String value) {
          _formData['name'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Profile profile) {
    if (profile == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (profile != null &&
        _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = profile.nid;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        style: TextStyle(
          color: Colors.green,
        ),
        focusNode: _descriptionFocusNode,

        // maxLines: 4,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          labelText: "National Id Card",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.pink,
              // width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              // width: 0.0,
            ),
          ),
        ),
        keyboardType: TextInputType.number,
        // initialValue: profile == null ? '' : profile.description,
        controller: _descriptionTextController,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty) {
            return 'National Id is required';
          }
        },
        onSaved: (String value) {
          _formData['nid'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Profile profile) {
    if (profile == null && _priceTextController.text.trim() == '') {
      _priceTextController.text = '';
    } else if (profile != null && _priceTextController.text.trim() == '') {
      _priceTextController.text = profile.dob;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _priceFocusNode,
      child: TextFormField(
        style: TextStyle(
          color: Colors.green,
        ),
        focusNode: _priceFocusNode,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          labelText: "Date of Birth",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.pink,
              // width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              // width: 0.0,
            ),
          ),
        ),
        // initialValue: profile == null ? '' : profile.dob,
        controller: _priceTextController,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty) {
            return 'Date of Birth is required';
          }
        },
        onSaved: (String value) {
          _formData['dob'] = value;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: () =>
                    // Provider.of<Profiles>(context).addProfile(profileId);
                    _submitForm(
                  model.addProfile,
                  model.updateProfile,
                  model.selectProfile,
                  model.selectedProfileIndex,
                ),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Profile profile) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              _buildTitleTextField(profile),
              SizedBox(
                height: 15,
              ),
              _buildDescriptionTextField(profile),
              SizedBox(
                height: 15,
              ),
              _buildPriceTextField(profile),
              // GeoLocationInput(),
              SizedBox(
                height: 10.0,
              ),
              ImageInputProfile(_setImage, profile),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  void _submitForm(
      Function addProfile, Function updateProfile, Function setSelectedProfile,
      [int selectedProfileIndex]) {
    if (!_formKey.currentState.validate() ||
        (_formData['image'] == null && selectedProfileIndex == -1)) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProfileIndex == -1) {
      addProfile(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        // _formData['dob'],
        _priceTextController.text,
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/update')
              .then((_) => setSelectedProfile(null));
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
    } else {
      updateProfile(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        // _formData['dob'],
        _priceTextController.text,
      ).then((_) => Navigator.pushReplacementNamed(context, '/update')
          .then((_) => setSelectedProfile(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProfile);
        return model.selectedProfileIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('E d i t  P r o f i l e'),
                  backgroundColor: Colors.black,
                ),
                body: pageContent,
              );
      },
    );
  }
}
