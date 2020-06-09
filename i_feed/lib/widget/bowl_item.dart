import 'package:flutter/material.dart';
import 'package:i_feed/screen/food_bowl_details_screen.dart';
import 'package:i_feed/screen/water_bowl_details_screen.dart';

class BowlItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Color color;
  final String animal;

  BowlItem({this.id, this.title, this.imageUrl, this.color, this.animal});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle:
          animal == null ? Text("for all the animals") : Text("for: $animal"),
      leading: CircleAvatar(
        backgroundColor: color,
        backgroundImage: NetworkImage(
          imageUrl,
        ),
      ),
      trailing: Container(
        child: IconButton(
          icon: title == 'water bowl'
              ? Icon(Icons.local_drink)
              : Icon(Icons.fastfood),
          onPressed: () {
            if (title == 'water bowl') {
              Navigator.of(context)
                  .pushNamed(WaterBowlDetailsScreen.routeName, arguments: id);
            } else {
              Navigator.of(context)
                  .pushNamed(FoodBowlDetailsScreen.routeName, arguments: id);
            }
          },
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
