import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/users.dart';
import '../model/details/user_role.dart';
import '../model/details/user_id.dart';
import '../model/feed_user.dart';

class NewUserScreen extends StatefulWidget {
  static const routeName = '/new_user';

  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _usernameFocusNode = FocusNode();
  final _avatarFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  FeedUser _editedUser = FeedUser(
    userId: UserId(domain: null, email: ''),
    role: UserRole.PLAYER,
    username: '',
    avatar: '',
  );

  var _initNewUser = {
    'email': '',
    'avatar': '',
    'username': '',
  };
  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      final currentUser = Provider.of<Users>(context, listen: false).user;
      if (currentUser != null) {
        _editedUser = currentUser;
        _initNewUser = {
          'email': _editedUser.userId.email,
          'avatar': _editedUser.avatar,
          'username': _editedUser.username,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _avatarFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_editedUser.userId.domain != null) {
        await Provider.of<Users>(context, listen: false)
            .updateUser(_editedUser);
      } else {
        await Provider.of<Users>(context, listen: false)
            .createUser(_editedUser);
      }
      Navigator.of(context).pop();
    } catch (error) {
      const errorMessage = 'Cant create the user, Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occurred'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Okay'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue[900],
          Colors.blue[800],
          Colors.blue[400]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blue,
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  initialValue: _editedUser.userId.email,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                  ),
                                  enabled: _editedUser.userId.domain != null
                                      ? false
                                      : true,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_usernameFocusNode);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'please provide a email';
                                    }
                                    return null;
                                  },
                                  onSaved: (vlaue) => _editedUser = FeedUser(
                                    userId: UserId(
                                        domain: _editedUser.userId.domain,
                                        email: vlaue),
                                    role: _editedUser.role,
                                    username: _editedUser.username,
                                    avatar: _editedUser.avatar,
                                  ),
                                ),
                                TextFormField(
                                  initialValue: _editedUser.username,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                  ),
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_avatarFocusNode);
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'please provide a username';
                                    }
                                    return null;
                                  },
                                  onSaved: (vlaue) => _editedUser = FeedUser(
                                    userId: UserId(
                                        domain: _editedUser.userId.domain,
                                        email: _editedUser.userId.email),
                                    role: _editedUser.role,
                                    username: vlaue,
                                    avatar: _editedUser.avatar,
                                  ),
                                ),
                                TextFormField(
                                  initialValue: _editedUser.avatar,
                                  decoration: InputDecoration(
                                    labelText: 'Avatar',
                                  ),
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submit(),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'please provide a avatar';
                                    }
                                    return null;
                                  },
                                  onSaved: (vlaue) => _editedUser = FeedUser(
                                    userId: UserId(
                                        domain: _editedUser.userId.domain,
                                        email: _editedUser.userId.email),
                                    role: _editedUser.role,
                                    username: _editedUser.username,
                                    avatar: vlaue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          minWidth: 150,
                          onPressed: () => _submit(),
                          shape: StadiumBorder(),
                          splashColor: Colors.lightBlue,
                          color: Colors.blue[900],
                          child: Text(
                            _editedUser.userId.domain == null
                                ? "Create"
                                : "Update",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
