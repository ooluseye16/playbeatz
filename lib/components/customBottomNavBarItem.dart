import 'package:flutter/material.dart';

class CustomNavBarItem extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final Color color;
  final String label;

  CustomNavBarItem({this.icon, this.onPressed, this.color, this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 25.0,
              child: Icon(
                icon,
                color: color,
              ),
            ),
            Flexible(
                child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10.0,
              ),
            ))
          ],
        ),
        onTap: onPressed,
      ),
    );
  }
}
