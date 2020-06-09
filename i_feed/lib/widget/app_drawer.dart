import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/new_user_screen.dart';
import '../screen/login_screen.dart';
import '../provider/users.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit user details'),
            onTap: () {
              Navigator.of(context).pushNamed(NewUserScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log out'),
            onTap: () {
              Provider.of<Users>(context, listen: false).logOut();
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
