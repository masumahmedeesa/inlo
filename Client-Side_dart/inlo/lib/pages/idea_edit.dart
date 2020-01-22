import 'dart:io';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../models/idea.dart';
import '../scoped-models/main.dart';
// import '../widgets/locations/location.dart';
import '../widgets/utility/image.dart';

class IdeaEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IdeaEditPageState();
  }
}

class _IdeaEditPageState extends State<IdeaEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  final _priceTextController = TextEditingController();

  Widget _buildTitleTextField(Idea idea) {
    if (idea == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (idea != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = idea.title;
    } else if (idea != null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else if (idea == null && _titleTextController.text.trim() != '') {
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
          labelText: 'Idea Title',
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
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
        // initialValue: idea == null ? '' : idea.title, 
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and should be 5+ characters long.';
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
      ),
    );
  }

  Widget _buildDescriptionTextField(Idea idea) {
    if (idea == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (idea != null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = idea.description;
    }
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        style: TextStyle(
          color: Colors.green,
        ),
        focusNode: _descriptionFocusNode,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: 'Idea Description',
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
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
        // initialValue: idea == null ? '' : idea.description,
        controller: _descriptionTextController,
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and should be 10+ characters long.';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  Widget _buildPriceTextField(Idea idea) {
    if (idea == null && _priceTextController.text.trim() == '') {
      _priceTextController.text = '';
    } else if (idea != null && _priceTextController.text.trim() == '') {
      _priceTextController.text = idea.price.toString();
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
          labelText: 'Revenue',
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
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
        controller: _priceTextController,
        // initialValue: idea == null ? '' : idea.price.toString(),
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'Price is required and should be a number.';
          }
        },
        // onSaved: (String value) {
        //   _formData['price'] = double.parse(value);
        // },
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
                onPressed: () => _submitForm(
                  model.addIdea,
                  model.updateIdea,
                  model.selectIdea,
                  model.selectedIdeaIndex,
                ),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Idea idea) {
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
              SizedBox(height: 10),
              _buildTitleTextField(idea),
              SizedBox(height: 15),
              _buildDescriptionTextField(idea),
              SizedBox(height: 15),
              _buildPriceTextField(idea),
              // GeoLocationInput(),
              SizedBox(
                height: 10.0,
              ),
              ImageInput(_setImage, idea),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My Button'),
              //   ),
              // )
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
      Function addIdea, Function updateIdea, Function setSelectedIdea,
      [int selectedIdeaIndex]) {
    if (!_formKey.currentState.validate() ||
        (_formData['image'] == null && selectedIdeaIndex == -1)) {
      return;
    }
    _formKey.currentState.save();
    if (selectedIdeaIndex == -1) {
      addIdea(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        // _formData['price'],
        double.parse(_priceTextController.text.replaceFirst(RegExp(r','), '.')),
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/ideas')
              .then((_) => setSelectedIdea(null));
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
      updateIdea(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        double.parse(_priceTextController.text.replaceFirst(RegExp(r','), '.')),
      ).then((_) => Navigator.pushReplacementNamed(context, '/ideas')
          .then((_) => setSelectedIdea(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedIdea);
        return model.selectedIdeaIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Idea'),
                  backgroundColor: Colors.black,
                ),
                body: pageContent,
              );
      },
    );
  }
}
