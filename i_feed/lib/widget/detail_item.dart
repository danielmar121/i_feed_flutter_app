import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  final String title;

  DetailItem({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
