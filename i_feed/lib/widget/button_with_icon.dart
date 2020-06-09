import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final function;

  ButtonWithIcon({
    @required this.title,
    @required this.color,
    @required this.icon,
    @required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      minWidth: 150,
      padding: EdgeInsets.all(10),
      onPressed: function,
      shape: StadiumBorder(),
      splashColor: Colors.grey,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
