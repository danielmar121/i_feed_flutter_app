import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen/new_user_screen.dart';
import './screen/login_screen.dart';
import './screen/map_screen.dart';
import './screen/water_bowl_details_screen.dart';
import './screen/food_bowl_details_screen.dart';
import './screen/feeding_area_details_screen.dart';
import './screen/add_water_bowl_screen.dart';
import './screen/add_food_bowl_screen.dart';

import './provider/elements.dart';
import './provider/users.dart';
import './provider/actions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Elements(),
        ),
        ChangeNotifierProvider.value(
          value: Users(),
        ),
        ChangeNotifierProvider.value(
          value: FeedActions(),
        ),
      ],
      child: MaterialApp(
        title: 'iFeed',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: LoginScreen(),
        routes: {
          AddFoodBowlScreen.routeName: (ctx) => AddFoodBowlScreen(),
          AddWaterBowlScreen.routeName: (ctx) => AddWaterBowlScreen(),
          FeedingAreaDetailsScreen.routeName: (ctx) =>
              FeedingAreaDetailsScreen(),
          FoodBowlDetailsScreen.routeName: (ctx) => FoodBowlDetailsScreen(),
          WaterBowlDetailsScreen.routeName: (ctx) => WaterBowlDetailsScreen(),
          NewUserScreen.routeName: (ctx) => NewUserScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          MapScreen.routeName: (ctx) => MapScreen(),
        },
      ),
    );
  }
}
