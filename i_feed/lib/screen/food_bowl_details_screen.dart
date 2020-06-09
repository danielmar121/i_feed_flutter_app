import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screen/add_food_bowl_screen.dart';
import '../widget/detail_item.dart';
import '../widget/button_with_icon.dart';
import '../model/details/user_id.dart';
import '../model/feed_element.dart';
import '../provider/elements.dart';
import '../provider/actions.dart';
import '../provider/users.dart';

class FoodBowlDetailsScreen extends StatelessWidget {
  static const routeName = '/food_bowl_detail';

  void _removeBowl(BuildContext context, FeedElement bowl, UserId userId) {
    Provider.of<FeedActions>(context, listen: false)
        .removeFoodBowl(bowl, userId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final _bowlId = ModalRoute.of(context).settings.arguments as String;
    final _bowl =
        Provider.of<Elements>(context, listen: false).findBowl(_bowlId);
    final _userId = Provider.of<Users>(context, listen: false).user.userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Bowl'),
        actions: <Widget>[],
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Food Bowl Details:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                DetailItem(
                    title:
                        '- Food state: ${_bowl.elementAttributes['state'] ? "Full" : "Empty"}'),
                SizedBox(height: 10),
                DetailItem(
                    title: '- Food for: ${_bowl.elementAttributes['animal']}'),
                SizedBox(height: 10),
                DetailItem(
                    title: '- Brand: ${_bowl.elementAttributes['brand']}'),
                SizedBox(height: 10),
                DetailItem(
                    title:
                        '- Bowl weight: ${_bowl.elementAttributes['weight']}'),
                SizedBox(height: 10),
                DetailItem(
                    title:
                        '- Expration date: ${_bowl.elementAttributes['lastFillDate']}'),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 300,
                    child: ButtonWithIcon(
                      title: _bowl.elementAttributes['state']
                          ? 'Change To Empty'
                          : 'Change To Full',
                      color: Theme.of(context).primaryColor,
                      icon: Icons.refresh,
                      function: () {
                        Navigator.of(context).popAndPushNamed(
                            AddFoodBowlScreen.routeName,
                            arguments: _bowlId);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 150,
                    child: ButtonWithIcon(
                      title: 'Remove',
                      color: Colors.red,
                      icon: Icons.delete,
                      function: () => _removeBowl(context, _bowl, _userId),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
