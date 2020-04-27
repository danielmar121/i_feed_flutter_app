import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/elements.dart';
import '../provider/users.dart';
import '../provider/actions.dart';

class MainScreen extends StatelessWidget {
  List<Widget> elementButtons(BuildContext context) {
    return <Widget>[
      FlatButton(
        onPressed: () async {
          Provider.of<Elements>(context, listen: false).createElement();
        },
        child: Text(
          'create an element',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<Elements>(context, listen: false).getSpecificElement();
        },
        child: Text(
          'get a specific element',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<Elements>(context, listen: false).getAllElements();
        },
        child: Text(
          'get all elements',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<Elements>(context, listen: false).deleteAllElements();
        },
        child: Text(
          'delete all elements',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<Elements>(context, listen: false).updateElement();
        },
        child: Text(
          'update element',
        ),
      )
    ];
  }

  List<Widget> actionButtons(BuildContext context) {
    return <Widget>[
      FlatButton(
        onPressed: () async {
          Provider.of<FeedActions>(context, listen: false).invokeAction();
        },
        child: Text(
          'invoke an action',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<FeedActions>(context, listen: false).deleteAllActions();
        },
        child: Text(
          'delete all actions',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<FeedActions>(context, listen: false).getAllActions();
        },
        child: Text(
          'get all actions',
        ),
      ),
      // FlatButton(
      //   onPressed: () async {
      //     Provider.of<Users>(context, listen: false).deleteAllUsers();
      //   },
      //   child: Text(
      //     'delete all Users',
      //   ),
      // ),
      // FlatButton(
      //   onPressed: () async {
      //     Provider.of<Users>(context, listen: false).updateUser();
      //   },
      //   child: Text(
      //     'update user',
      //   ),
      // )
    ];
  }

  List<Widget> userButtons(BuildContext context) {
    return <Widget>[
      FlatButton(
        onPressed: () async {
          Provider.of<Users>(context, listen: false).createUser();
        },
        child: Text(
          'create an user',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<Users>(context, listen: false).login();
        },
        child: Text(
          'login',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<Users>(context, listen: false).getAllUsers();
        },
        child: Text(
          'get all users',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<Users>(context, listen: false).deleteAllUsers();
        },
        child: Text(
          'delete all Users',
        ),
      ),
      FlatButton(
        onPressed: () async {
          Provider.of<Users>(context, listen: false).updateUser();
        },
        child: Text(
          'update user',
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iFeed'),
      ),
      body: Container(
        child: Column(
          // children: elementButtons(context),
          // children: userButtons(context),
          children: actionButtons(context),
        ),
      ),
    );
  }
}
