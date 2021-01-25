import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cake_shop/mainscreen.dart';
import 'package:my_cake_shop/registerscreen.dart';
import 'package:my_cake_shop/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _pscontroller = TextEditingController();
  String _password = "";
  bool _rememberMe = false;
  SharedPreferences prefs;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressAppBar,
        child: Scaffold(
            //backgroundColor: Colors.yellow[50],
            body: new Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.lime[100],
                      Colors.lightGreen[100],
                      Colors.green[100],
                      Colors.teal[100],
                      Colors.cyan[100],
                    ])),
                padding: EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Image.asset(
                          'assets/images/MyCakeShop1.png',
                          scale: 0.6,
                        ),
                        Card(
                          color: Colors.lightGreen[100],
                          elevation: 15,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Column(children: [
                                TextFormField(
                                    controller: _emcontroller,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        labelText: 'Email',
                                        labelStyle: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        icon: Icon(Icons.email,
                                            color: Colors.red)),
                                    textInputAction: TextInputAction.next,
                                    validator: (_email) {
                                      Pattern pattern =
                                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(_email))
                                        return 'Invalid Email';
                                      else if (_email.isEmpty)
                                        return 'Please enter your Email';
                                      else
                                        return null;
                                    },
                                    onSaved: (String email) {
                                      _email = email;
                                    }),
                                TextFormField(
                                    // key: _passwordFieldKey,
                                    controller: _pscontroller,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      icon: Icon(Icons.lock, color: Colors.red),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: _passwordVisible,
                                    textInputAction: TextInputAction.done,
                                    validator: (password) {
                                      Pattern pattern =
                                          r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(password))
                                        return 'Invalid password';
                                      else if (_password.isEmpty)
                                        return 'Please enter your Password';
                                      else
                                        return null;
                                    },
                                    onSaved: (String password) {
                                      _password = password;
                                    }),
                                SizedBox(
                                  height: 20,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  minWidth: 300,
                                  height: 50,
                                  child: Text('LOGIN',
                                      style: TextStyle(fontSize: 18)),
                                  color: Colors.black,
                                  textColor: Colors.cyan[200],
                                  elevation: 15,
                                  onPressed: _onLogin,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (bool value) {
                                        _onChange(value);
                                      },
                                    ),
                                    Text('Remember Me',
                                        style: TextStyle(fontSize: 18))
                                  ],
                                ),
                                GestureDetector(
                                    onTap: _onRegister,
                                    child: Text('Register New Account',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic))),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                    onTap: _onForgot,
                                    child: Text('Forgot Account',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.italic))),
                              ])),
                        )
                      ],
                    ),
                  ),
                ))));
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _email = _emcontroller.text;
      _password = _pscontroller.text;
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Login...");
      await pr.show();
      http.post("http://rachelcake.com/mycakeshop/php/login_user.php", body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.body);
        List userdata = res.body.split(",");
        if (userdata[0] == "success") {
          Toast.show(
            "Login Success",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
          User user = new User(
              email: _email,
              name: userdata[1],
              password: _password,
              phone: userdata[2],
              datereg: userdata[3]);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(user: user)));
        } else {
          Toast.show(
            "Login failed",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
        }
      }).catchError((err) {
        print(err);
      });
      await pr.hide();
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _onForgot() {
    print('Please register the new one');
    Toast.show(
      "Please register the new one",
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.TOP,
    );
  }

  void _onChange(bool value) {
    setState(() {
      _rememberMe = value;
      savepref(value);
    });
  }

  Future<void> loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _rememberMe = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      _emcontroller.text = _email;
      _pscontroller.text = _password;
      _rememberMe = _rememberMe;
    }
  }

  Future<void> savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emcontroller.text;
    _password = _pscontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("EMAIL/PASSWORD EMPTY");
        _rememberMe = false;
        Toast.show(
          "EMAIL/PASSWORD EMPTY!!!",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);
        Toast.show(
          "Preferences Saved",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        print("SUCCESS");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('rememberme', false);
      setState(() {
        _emcontroller.text = "";
        _pscontroller.text = "";
        _rememberMe = false;
      });
      Toast.show(
        "Preferences Removed",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
      );
    }
  }
}
