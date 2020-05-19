import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../providers/authprovider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var _devicesize=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  colors: [
                    Colors.orangeAccent,
                    Colors.deepOrangeAccent,
                    Colors.orangeAccent
                  ],
                  end: Alignment.bottomRight),
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                alignment: Alignment.center,
                height: 70,
                child: Text(
                  "ShopApp",
                  style: TextStyle(
                    fontSize: 50,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepOrange,
                  ),
                  // textAlign: TextAlign.left,
                ),

                //transform: Matrix4.rotationY(0),
              ),
              Authwidget(),
            ],
          )
        ],
      ),
    );
  }
}

class Authwidget extends StatefulWidget {
  @override
  _AuthwidgetState createState() => _AuthwidgetState();
}

bool _issignup = false;
int check = 0;

class _AuthwidgetState extends State<Authwidget> with TickerProviderStateMixin {
  var formkey = GlobalKey<FormState>();
  String userid;
  String password;
  final passwordcontroller = TextEditingController();
  AnimationController _animatecontroller;
  AnimationController _fadecontroller;
  Animation<Size> _heighanimation;
  Animation<double> _fadeanimation;

  void afterpressingsignup() {
    setState(() {
      formkey.currentState.reset();
      _issignup = true;
    });
    _animatecontroller.forward();
    _fadecontroller.forward();
  }

  void afterpressingloginpage() {
    setState(() {
      _issignup = false;
    });
    _animatecontroller.reverse();
    _fadecontroller.reverse();
  }

  @override
  void initState() {
    _animatecontroller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _fadecontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _heighanimation = Tween<Size>(
            begin: Size(double.infinity, 150), end: Size(double.infinity, 220))
        .animate(
      CurvedAnimation(parent: _animatecontroller, curve: Curves.linear),
    );

    _fadeanimation = Tween<double>(end: 1, begin: 0).animate(
      CurvedAnimation(parent: _fadecontroller, curve: Curves.linear),
    );

    _heighanimation.addListener(() {
      setState(() {});
    });
    super.initState();
    _fadeanimation.addListener(() {
      setState(() {});
    });
  }

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? LinearProgressIndicator()
        : Column(
            children: <Widget>[
              Card(
                color: Colors.yellow.withOpacity(0.5),
                margin: EdgeInsets.all(2),
                child: Container(
                  height: _heighanimation.value.height,
                  constraints: BoxConstraints(maxHeight: 220, minHeight: 150),
                  padding: EdgeInsets.all(10),
                  width: 300,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "login",
                                labelStyle: TextStyle(color: Colors.black)),
                            validator: (value) {
                              if (value.isEmpty || !value.contains("@"))
                                return "not a valid emailid";
                              return null;
                            },
                            onSaved: (value) {
                              userid = value;
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(

                                labelText: "password",
                                labelStyle: TextStyle(color: Colors.black)),
                            validator: (value) {
                              if (value.isEmpty || value.length < 6)
                                return "password to short";
                              return null;
                            },
                            controller: passwordcontroller,
                            onSaved: (value) {
                              password = value;
                            },
                            //obscureText: true,
                          ),
                          if (_issignup)
                            FadeTransition(
                              child: TextFormField(
                                // obscureText: true,
                                decoration: InputDecoration(
                                    labelText: "confirmpassword",
                                    labelStyle: TextStyle(color: Colors.black)),
                                validator: (value) {
                                  if (passwordcontroller.text != value)
                                    return "confirm password does not match";
                                  return null;
                                },
                              ),
                              opacity: _fadeanimation,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_issignup == false)
                RaisedButton(
                  splashColor: Colors.white,
                  onPressed: () async {
                    formkey.currentState.save();
                    if (!(formkey.currentState.validate())) return;
                    try {
                      setState(() {
                        _isloading = true;
                      });
                      await Provider.of<AuthProvider>(context, listen: false)
                          .signin(userid, password);
                      setState(() {
                        _isloading = false;
                      });
                    } catch (error) {
                      setState(() {
                        _isloading = false;
                      });
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text(error),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                    }

                  },
                  //shape: Border.all(wid),
                  child: Text(
                    "login",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.orangeAccent,
                ),
              if (_issignup == false)
                FlatButton(
                  child: Text(
                    "New Registraion/Signup",
                    style: TextStyle(color: Colors.black),
                  ),
                  focusColor: Colors.white,
                  hoverColor: Colors.red,
                  onPressed: afterpressingsignup,
                ),
              if (_issignup)
                RaisedButton(
                  splashColor: Colors.white,
                  onPressed: () async {
                    formkey.currentState.save();
                    if (!(formkey.currentState.validate())) return;

                    try {
                      setState(() {
                        _isloading = true;
                      });
                      await Provider.of<AuthProvider>(context, listen: false)
                          .signup(userid, password);
                      setState(() {
                        _isloading = false;
                      });
                    } catch (error) {
                      setState(() {
                        _isloading = false;
                      });
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text(error),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("ok"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ));
                    }
                  },
                  //shape: Border.all(wid),
                  child: Text(
                    "Signup",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.orangeAccent,
                ),
              if (_issignup)
                RaisedButton(
                  splashColor: Colors.white,
                  onPressed: () => afterpressingloginpage(),
                  //shape: Border.all(wid),
                  child: Text(
                    "Backtologin",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.orangeAccent,
                ),
            ],
          );
  }
}
