import 'package:flutter/material.dart';
import './screens/approved.dart';


// import './screens/update_edit.dart';

import 'package:provider/provider.dart';
// import 'package:map_view/map_view.dart';

import './screens/bank_overview_screen.dart';

import 'package:scoped_model/scoped_model.dart';
// import 'package:flutter/rendering.dart';

// import './models/profile.dart';
import './pages/auth.dart';
import './pages/ideas_admin.dart';
import './pages/ideas.dart';
import './pages/idea.dart';
import './scoped-models/main.dart';
import './models/idea.dart';
// import './models/profile.dart';

import './providers/loans.dart';
import './providers/banks.dart';

import './screens/bank_details_screen.dart';
// import './screens/edit_loan_screen.dart';
// import './screens/user_loan_screen.dart';
import './screens/loan_tab.dart';
import './screens/individual_details.dart';
import './screens/update.dart';
import './screens/searchScreen.dart';
import './widgets/utility/serviceLocator.dart';
void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;

  // MapView.setApiKey("AIzaSyDamsSPuYnjDxpG4wbEoUsrxvaIekxM9Yo");
  // WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  // final Profile profile = Profile();
  // final PModel _pmodel = PModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building main page');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Banks(),
        ),
        ChangeNotifierProvider.value(
          value: Loans(),
        ),
      ],
      child: ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          // debugShowMaterialGrid: true,
          theme: ThemeData(
              brightness: Brightness.light,
              // primaryColor: Colors.black38,
              primarySwatch: Colors.pink,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
          // home: AuthPage(),
          routes: {
            '/': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : IdeasPage(_model),
            '/admin': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : IdeasAdminPage(_model),
            '/update': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : Update(_model),
            '/banks': (BuildContext context) => BankOverViewScreen(),
            BankDetailsScreen.routeName: (ctx) => BankDetailsScreen(),
            // UserLoanScreen.routeName: (ctx) => UserLoanScreen(),
            // EditLoanScreen.routeName: (ctx) => EditLoanScreen(),
            LoanTab.routeName: (ctx) => LoanTab(),
            Individual.routeName: (ctx) => Individual(_model),
            Approve.routeName: (ctx) => Approve(_model),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            // UpdateEdit.routeName: (ctx) => UpdateEdit(),
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_isAuthenticated) {
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AuthPage(),
              );
            }
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'idea') {
              final String ideaId = pathElements[2];
              final Idea idea = _model.allIdeas.firstWhere((Idea idea) {
                return idea.id == ideaId;
              });
              // final Profile profile = _model.allProfiles.firstWhere((Profile profile) {
              //   return profile.id == ideaId;
              // });
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : IdeaPage(idea,_model),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : IdeasPage(_model));
          },
        ),
      ),
    );
  }
}
