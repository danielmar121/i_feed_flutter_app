import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screen/main_screen.dart';
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
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: MainScreen(),
        // routes: {
        //   ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        //   CartScreen.routeName: (ctx) => CartScreen(),
        //   OrdersScreen.routeName: (ctx) => OrdersScreen(),
        //   UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
        //   EditProductScreen.routeName: (ctx) => EditProductScreen(),
        // },
      ),
    );
  }
}
