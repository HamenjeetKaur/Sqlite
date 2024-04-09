import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path/path.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite Login by Hamen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              bool isAuthenticated = await authenticateUser(
                  _usernameController.text, _passwordController.text);
              if (isAuthenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid username or password')));
              }
            },
            child: Text('Login'),
          ),
          SizedBox(height: 10.0),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            child: Text('Create account'),
          ),
        ],
      ),
    );
  }
}
class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SignupForm(),
    );
  }
}
class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}
class _SignupFormState extends State<SignupForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              await saveUser(
                  _usernameController.text, _passwordController.text);
              Navigator.pop(context);
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
Future<Database> openDB() async {
  return databaseFactoryWeb.openDatabase('user_database.db');
}
Future<void> saveUser(String username, String password) async {
  final Database db = await openDB();
  final store = intMapStoreFactory.store('users');
  await store.add(db, {'username': username, 'password': password});
}
Future<bool> authenticateUser(String username, String password) async {
  final Database db = await openDB();
  final store = intMapStoreFactory.store('users');
  final finder = Finder(filter: Filter.and([
    Filter.equals('username', username),
    Filter.equals('password', password),
  ]));
  final recordSnapshots = await store.find(db, finder: finder);
  return recordSnapshots.isNotEmpty;
}