import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../providers/approveModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
// import 'package:mim';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import '../models/idea.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../models/profile.dart';
import '../models/comment.dart';

mixin ConnectedIdeasModel on Model {
  List<Idea> _ideas = [];
  // List<Idea> _verifiedIdeas = [];
  String _selIdeaId;
  User _authenticatedUser;
  bool _isLoading = false;
  List<Profile> _profiles = [];
  List<ApproveList> _apps = [];
  String _selProfileId;
  List<Comment> _comments = [];
}

mixin IdeasModel on ConnectedIdeasModel {
  bool _showFavorites = false;

  List<Idea> get allIdeas {
    return List.from(_ideas);
  }

  List<Idea> get displayedIdeas {
    if (_showFavorites) {
      return _ideas.where((Idea idea) => idea.isFavorite).toList();
    }
    return List.from(_ideas);
  }

  int get selectedIdeaIndex {
    return _ideas.indexWhere((Idea idea) {
      return idea.id == _selIdeaId;
    });
  }

  String get selectedIdeaId {
    return _selIdeaId;
  }

  Idea get selectedIdea {
    if (selectedIdeaId == null) {
      return null;
    }

    return _ideas.firstWhere((Idea idea) {
      return idea.id == _selIdeaId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final basename = path.basename(image.path);
    print(basename);
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-microinloan.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(basename[0], basename[1]),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.decodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something is wrong');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addIdea(
      String title, String description, File image, double price) async {
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      print('Something is wrong!');
      return false;
    }

    final Map<String, dynamic> ideaData = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'userId': _authenticatedUser.id,
    };
    try {
      final http.Response response = await http.post(
          'https://microinloan.firebaseio.com/ideas.json?auth=${_authenticatedUser.token}',
          body: json.encode(ideaData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Idea newIdea = Idea(
          id: responseData['name'],
          title: title,
          description: description,
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _ideas.add(newIdea);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<bool> updateIdea(
      String title, String description, File image, double price) async {
    _isLoading = true;
    notifyListeners();

    String imageUrl = selectedIdea.image;
    String imagePath = selectedIdea.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        print('Something is wrong!');
        return false;
      }
      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'userEmail': selectedIdea.userEmail,
      'userId': selectedIdea.userId
    };

    try {
      await http.put(
          'https://microinloan.firebaseio.com/ideas/${selectedIdea.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));
      // .then((http.Response reponse) {
      _isLoading = false;
      final Idea updatedIdea = Idea(
          id: selectedIdea.id,
          title: title,
          description: description,
          image: imageUrl,
          imagePath: imagePath,
          price: price,
          userEmail: selectedIdea.userEmail,
          userId: selectedIdea.userId);
      _ideas[selectedIdeaIndex] = updatedIdea;
      notifyListeners();
      return true;
    } catch (error) {
      // }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
      // });
    }
  }

  Future<bool> deleteIdea() {
    _isLoading = true;
    final deletedIdeaId = selectedIdea.id;
    _ideas.removeAt(selectedIdeaIndex);
    _selIdeaId = null;
    notifyListeners();
    return http
        .delete(
            'https://microinloan.firebaseio.com/ideas/$deletedIdeaId.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchIdeas({onlyForUser = false, clearExisting = false}) {
    _isLoading = true;
    print('first');
    if (clearExisting) {
      _ideas = [];
    }
    notifyListeners();
    return http
        .get(
            'https://microinloan.firebaseio.com/ideas.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Idea> fetchedIdeaList = [];
      final Map<String, dynamic> ideaListData = json.decode(response.body);
      print(ideaListData.length);
      if (ideaListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      print('ashse');
      ideaListData.forEach((String ideaId, dynamic ideaData) {
        final Idea idea = Idea(
            id: ideaId,
            title: ideaData['title'],
            description: ideaData['description'],
            image: ideaData['imageUrl'],
            imagePath: ideaData['imagePath'],
            price: ideaData['price'],
            userEmail: ideaData['userEmail'],
            userId: ideaData['userId'],
            isFavorite: ideaData['wishlistUsers'] == null
                ? false
                : (ideaData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id));
        fetchedIdeaList.add(idea);
      });
      print('eikhane');
      print(fetchedIdeaList.length);

      _ideas = onlyForUser
          ? fetchedIdeaList.where((Idea idea) {
              return idea.userId == _authenticatedUser.id;
            }).toList()
          : fetchedIdeaList;

      _isLoading = false;
      notifyListeners();
      _selIdeaId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleIdeaFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedIdea.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Idea updatedIdea = Idea(
      id: selectedIdea.id,
      title: selectedIdea.title,
      description: selectedIdea.description,
      price: selectedIdea.price,
      image: selectedIdea.image,
      imagePath: selectedIdea.imagePath,
      userEmail: selectedIdea.userEmail,
      userId: selectedIdea.userId,
      isFavorite: newFavoriteStatus,
    );
    _ideas[selectedIdeaIndex] = updatedIdea;
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://microinloan.firebaseio.com/ideas/${selectedIdea.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://microinloan.firebaseio.com/ideas/${selectedIdea.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Idea updatedIdea = Idea(
          id: selectedIdea.id,
          title: selectedIdea.title,
          description: selectedIdea.description,
          price: selectedIdea.price,
          image: selectedIdea.image,
          imagePath: selectedIdea.imagePath,
          userEmail: selectedIdea.userEmail,
          userId: selectedIdea.userId,
          isFavorite: !newFavoriteStatus);
      _ideas[selectedIdeaIndex] = updatedIdea;
      notifyListeners();
    }
    _selIdeaId = null;
  }

  void selectIdea(String ideaId) {
    _selIdeaId = ideaId;
    if (ideaId != null) {
      notifyListeners();
    }
    // notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedIdeasModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD4XNHQvPAAR7VXus1PGSXAJ6AKhkRIawk',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD4XNHQvPAAR7VXus1PGSXAJ6AKhkRIawk',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    _selIdeaId = null;
    _selProfileId = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedIdeasModel {
  bool get isLoading {
    return _isLoading;
  }
}

mixin ProfileModel on ConnectedIdeasModel {
  // bool _showFavorites = false;
  List<Profile> get allProfiles {
    return List.from(_profiles);
  }
  // final bool hey ;

  List<Profile> get displayedProfiles {
    // if (_showFavorites) {
    //   return _profiles.where((Profile profile) => profile.isFavorite).toList();
    // }
    return List.from(_profiles);
  }

  int get selectedProfileIndex {
    return _profiles.indexWhere((Profile profile) {
      return profile.id == _selProfileId;
    });
  }

  // bool get veried{
  //   return hey;
  // }

  String get selectedProfileId {
    return _selProfileId;
  }

  Profile get selectedProfile {
    if (selectedProfileId == null) {
      return null;
    }

    return _profiles.firstWhere((Profile profile) {
      return profile.id == _selProfileId;
    });
  }

  // bool get displayFavoritesOnly {
  //   return _showFavorites;
  // }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final basename = path.basename(image.path);
    print(basename);
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-microinloan.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(basename[0], basename[1]),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.decodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something is wrong');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addProfile(
      String name, String nid, File image, String dob) async {
    // print('fuck the whole universe');
    print(_authenticatedUser);
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      print('Something is wrong!');
      return false;
    }

    final Map<String, dynamic> profileData = {
      'name': name,
      'nid': nid,
      'dob': dob,
      'userEmail': _authenticatedUser.email,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'userId': _authenticatedUser.id,
      'verify': false,
    };
    try {
      final http.Response response = await http.post(
          'https://microinloan.firebaseio.com/profiles.json?auth=${_authenticatedUser.token}',
          body: json.encode(profileData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Profile newProfile = Profile(
          id: responseData['name'],
          name: name,
          nid: nid,
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
          dob: dob,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _profiles.add(newProfile);
      _isLoading = false;
      notifyListeners();
      // hey = true;
      print('upload hoise');
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<bool> updateProfile(
      String name, String nid, File image, String dob) async {
    _isLoading = true;
    notifyListeners();

    String imageUrl = selectedProfile.image;
    String imagePath = selectedProfile.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        print('Something is wrong!');
        return false;
      }
      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }

    final Map<String, dynamic> updateData = {
      'name': name,
      'nid': nid,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'dob': dob,
      'userEmail': selectedProfile.userEmail,
      'userId': selectedProfile.userId
    };

    try {
      await http.put(
          'https://microinloan.firebaseio.com/profiles/${selectedProfile.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));
      // .then((http.Response reponse) {
      _isLoading = false;
      final Profile updatedProfile = Profile(
          id: selectedProfile.id,
          name: name,
          nid: nid,
          image: imageUrl,
          imagePath: imagePath,
          dob: dob,
          userEmail: selectedProfile.userEmail,
          userId: selectedProfile.userId);
      _profiles[selectedProfileIndex] = updatedProfile;
      notifyListeners();
      return true;
    } catch (error) {
      // }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
      // });
    }
  }

  Future<Null> fetchProfiles({onlyForUser = false, clearExisting = false}) {
    _isLoading = true;
    if (clearExisting) {
      _profiles = [];
    }
    notifyListeners();
    return http
        .get(
            'https://microinloan.firebaseio.com/profiles.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Profile> fetchedProfileList = [];
      final Map<String, dynamic> profileListData = json.decode(response.body);
      if (profileListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      profileListData.forEach((String profileId, dynamic profileData) {
        final Profile profile = Profile(
          id: profileId,
          name: profileData['name'],
          nid: profileData['nid'],
          image: profileData['imageUrl'],
          imagePath: profileData['imagePath'],
          dob: profileData['dob'],
          userEmail: profileData['userEmail'],
          userId: profileData['userId'],
        );
        fetchedProfileList.add(profile);
      });

      _profiles = fetchedProfileList.where((Profile profile) {
        return profile.userId == _authenticatedUser.id;
      }).toList();

      // _pp = fetchedProfileList.where((Profile profile) {
      //   return profile.userId == _authenticatedUser.id;
      // }).toList();

      _isLoading = false;
      notifyListeners();
      _selProfileId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void selectProfile(String profileId) {
    _selProfileId = profileId;
    if (profileId != null) {
      notifyListeners();
    }
  }
}

mixin CommentBox on ConnectedIdeasModel {
  List<Comment> get allComments {
    return List.from(_comments);
  }
  List<ApproveList> get allApproved {
    return List.from(_apps);
  }
  Future<bool> addComment(
      String commentBox, String ideaId, String userName, String image) async {
    // print('fuck the whole universe');
    // print(_pp[0].name);
    _isLoading = true;
    notifyListeners();
    print(ideaId);
    final Map<String, dynamic> commentData = {
      'commentBox': commentBox,
      'userId': _authenticatedUser.id,
      'ideaId': ideaId,
      'userName': userName,
      'image': image,
      'isApproved': false,
    };
    try {
      final http.Response response = await http.post(
          'https://microinloan.firebaseio.com/comments.json?auth=${_authenticatedUser.token}',
          body: json.encode(commentData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Comment newComment = Comment(
        id: responseData['name'],
        commentBox: commentBox,
        userId: _authenticatedUser.id,
        ideaId: ideaId,
        userName: userName,
        image: image,
        isApproved: false,
      );
      _comments.add(newComment);
      _isLoading = false;
      notifyListeners();
      // hey = true;
      print('upload hoise');
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<Null> fetchComments(String ideaaaId, {clearExisting = false}) {
    _isLoading = true;
    // print(_pp.length);
    if (clearExisting) {
      _comments = [];
    }
    notifyListeners();
    return http
        .get(
            'https://microinloan.firebaseio.com/comments.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<Comment> fetchedCommentList = [];
      final Map<String, dynamic> commentListData = json.decode(response.body);
      if (commentListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      commentListData.forEach((String cId, dynamic commentData) {
        final Comment comment = Comment(
            id: cId,
            commentBox: commentData['commentBox'],
            userId: commentData['userId'],
            ideaId: commentData['ideaId'],
            userName: commentData['userName'],
            image: commentData['image'],
            isApproved: commentData['isApproved']);
        fetchedCommentList.add(comment);
      });
      _comments = fetchedCommentList.where((Comment comment) {
        return comment.ideaId == ideaaaId;
      }).toList();
      print(ideaaaId);
      _isLoading = false;
      print(_comments.length);
      notifyListeners();
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> addReport(String reportBox, String ideaId, String title,
      String userName, String image) async {
    // print('fuck the whole universe');
    // print(_pp[0].name);
    _isLoading = true;
    notifyListeners();
    print(ideaId);
    final Map<String, dynamic> reportData = {
      'reportBox': reportBox,
      'userId': _authenticatedUser.id,
      'ideaId': ideaId,
      'title': title,
      'userName': userName,
      'image': image,
    };
    try {
      final http.Response response = await http.post(
          'https://microinloan.firebaseio.com/reports.json?auth=${_authenticatedUser.token}',
          body: json.encode(reportData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // final Map<String, dynamic> responseData = json.decode(response.body);
      // final Comment newComment = Comment(
      //   id: responseData['name'],
      //   commentBox: commentBox,
      //   userId: _authenticatedUser.id,
      //   ideaId: ideaId,
      //   userName: userName,
      //   image: image,
      //   isApproved: false,
      // );
      // _comments.add(newComment);
      // _isLoading = false;
      // notifyListeners();
      // // hey = true;
      // print('upload hoise');
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<bool> addRequest(
      String userName,
      String userEmail,
      String salary,
      String property,
      String how,
      String cause,
      String loanId,
      String code,
      String bankId,
      String loanName) async {
    // print('fuck the whole universe');
    // print(_pp[0].name);
    _isLoading = true;
    notifyListeners();
    // print(ideaId);
    final Map<String, dynamic> requestData = {
      'userId': _authenticatedUser.id,
      'userName': userName,
      'userEmail': userEmail,
      'salary': salary,
      'property': property,
      'how': how,
      'cause': cause,
      'loanId': loanId,
      'stockCode': code,
      'bankId': bankId,
      'loanName': loanName,
    };
    try {
      final http.Response response = await http.post(
          'https://microinloan.firebaseio.com/requests.json?auth=${_authenticatedUser.token}',
          body: json.encode(requestData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      // final Map<String, dynamic> responseData = json.decode(response.body);
      // final Comment newComment = Comment(
      //   id: responseData['name'],
      //   commentBox: commentBox,
      //   userId: _authenticatedUser.id,
      //   ideaId: ideaId,
      //   userName: userName,
      //   image: image,
      //   isApproved: false,
      // );
      // _comments.add(newComment);
      // _isLoading = false;
      // notifyListeners();
      // print('upload hoise');
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

    Future<Null> fetchApproved({onlyForUser = false, clearExisting = false}) {
    _isLoading = true;
    if (clearExisting) {
      _profiles = [];
    }
    notifyListeners();
    return http
        .get(
            'https://microinloan.firebaseio.com/approved.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      final List<ApproveList> loadedLoan = [];
      final Map<String, dynamic> data = json.decode(response.body);
      if (data == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      data.forEach((String profileId, dynamic profileData) {
        final ApproveList apprv = ApproveList(
          id: profileId,
          userId: profileData['userId'],
          bankId: profileData['bankId'],
          loanId: profileData['loanId'],
          loanName: profileData['loanName'],
          stockCode: profileData['stockCode'],
          userName: profileData['userName'],
          userEmail: profileData['userEmail'],
          salary: profileData['salary'],
          property: profileData['property'],
        );
        loadedLoan.add(apprv);
      });

      _apps = loadedLoan.where((ApproveList profile) {
        return profile.userId == _authenticatedUser.id;
      }).toList();

      _isLoading = false;
      notifyListeners();
      _selProfileId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }


}
