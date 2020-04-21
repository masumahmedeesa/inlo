# Inlo (Investment & Loan | Native App)
by Masum Ahmed
# To Promote your Entrepreneur Business & to get Popular Bank Loan using Mobile, it’s really a great Native Apps for you.

<pre>
USERNAME : eesha@eesha.com <br>
PASSWORD : 01786122963
</pre>

### Client-Side is built with Flutter & Dart || Server-side is build with NodeJS, JavaScript, HTML5, CSS, Bootstrap along with Firebase for both side

# Features
- I used Flutter, a Native Language to Develop Client-Side Application and NodeJS, a Javascript framework to develop Server-Side Web Application to manipulate Bank, Loan data as AdminPanel.
- I used firebase as database.
- Both Android and iOS compitable.
- You can promote your Business. Report spam Business.
- Image Upload.
- Can invest on any Initiatives. There’s surity to be not cheated.
- You can update your National Indentity Information. Admin Panel will verify you. If you are not verified, you can’t get any services from this Applications.
- Search preferred loans of Popular Banks.


# Facilities
- You can promote your initiatives using this Native App. There is strong AdminPanel to manipulate Right Idea, Idea’s Comment Section, Report Criteria. So there is no chance to get your idea spoiled.
- You can search your preferred loan, compare between loans of Popular Banks. You can browse different kinds of Loans sitting on chair by using this Application. You can also send a request to the bank to take particular loan. Then Bank will inform you with notifications if you are eligible for that particular loan or not. Then you have to go Bank to take money from Bank.
- You can invest on any initiatives with Mobile Banking or by contacting the promoter individually.

# Some important Code
### To build flutter add this in vscode debug configuration
<pre>
"args": ["--enable-software-rendering","-d","all"]
</pre>

### How to create, release flutter project

```
flutter create inloProject

For final release

flutter run --release
```
### To use firebase in Server-Side NodeJS
```
For firebase:
1. sudo npm install -g firebase-tools
2. firebase login
3. firebase init
    - functions
    - existing
    - javascript
    - typescript debug yes
    - yes
4. cd functions
5. npm install --save cors
6. npm install --save @google-cloud/storage
7. npm install --save firebase-admin

8. cd ..
9. firebase deploy
```

# Template
```javascript
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expenses',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final appbar = AppBar(
    title: Text('data'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar,
      body: Center(
        child: Text('data'),
      ),
    );
  }
}
```