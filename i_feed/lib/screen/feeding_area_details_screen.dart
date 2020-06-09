import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/elements.dart';
import '../widget/detail_item.dart';
import '../widget/button_with_icon.dart';
import '../widget/bowl_item.dart';
import '../provider/users.dart';
import '../screen/add_food_bowl_screen.dart';
import '../screen/add_water_bowl_screen.dart';
import '../model/details/user_id.dart';
import '../model/feed_element.dart';
import '../provider/actions.dart';

class FeedingAreaDetailsScreen extends StatefulWidget {
  static const routeName = '/feeding_area_detail';

  @override
  _FeedingAreaDetailsScreenState createState() =>
      _FeedingAreaDetailsScreenState();
}

class _FeedingAreaDetailsScreenState extends State<FeedingAreaDetailsScreen> {
  void _removeFeedingArea(
      BuildContext context, FeedElement bowl, UserId userId) {
    Provider.of<FeedActions>(context, listen: false)
        .removeFeedingArea(bowl, userId);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final _feedAreaId = ModalRoute.of(context).settings.arguments as String;
    final _userId = Provider.of<Users>(context, listen: false).user.userId;
    final _elementData = Provider.of<Elements>(context, listen: false);
    final _feedArea = _elementData.findFeedArea(_feedAreaId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Feeding Area'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => setState(() {}),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: FutureBuilder(
              future: _elementData.getSpecificElement(_userId, _feedArea),
              builder: (context, snapshot) => snapshot.data == null
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Water Bowl Details:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        DetailItem(
                            title:
                                '- number of full food bowls: ${snapshot.data.elementAttributes['fullFoodBowl']}'),
                        SizedBox(height: 10),
                        DetailItem(
                            title:
                                '- number of full water bowls: ${snapshot.data.elementAttributes['fullWaterBowl']}'),
                      ],
                    ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _elementData.getBowls(_userId, _feedArea),
                builder: (context, snapshot) => snapshot.data == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemBuilder: (_, i) => Column(
                          children: <Widget>[
                            BowlItem(
                              id: snapshot.data.elementAt(i).elementId.id,
                              title: snapshot.data.elementAt(i).name,
                              imageUrl:
                                  'https://cdn4.iconfinder.com/data/icons/cute-dog-in-brown-colour/512/DOG_ICONS1-01-512.png',
                              color: snapshot.data
                                      .elementAt(i)
                                      .elementAttributes['state']
                                  ? Colors.green
                                  : Colors.red,
                              animal: snapshot.data
                                  .elementAt(i)
                                  .elementAttributes['animal'],
                            ),
                            Divider()
                          ],
                        ),
                        itemCount: snapshot.data.length,
                      )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonWithIcon(
                title: 'Add',
                color: Colors.green,
                icon: Icons.fastfood,
                function: () {
                  Navigator.of(context).pushNamed(AddFoodBowlScreen.routeName,
                      arguments: _feedAreaId);
                },
              ),
              SizedBox(width: 20),
              ButtonWithIcon(
                title: 'Add',
                color: Colors.green,
                icon: Icons.local_drink,
                function: () {
                  Navigator.of(context).pushNamed(AddWaterBowlScreen.routeName,
                      arguments: _feedAreaId);
                },
              ),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              width: 150,
              child: ButtonWithIcon(
                title: 'Remove',
                color: Colors.red,
                icon: Icons.delete,
                function: () => _removeFeedingArea(context, _feedArea, _userId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
