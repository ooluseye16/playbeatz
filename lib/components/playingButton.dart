import 'package:flutter/material.dart';

class PlayingButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final Color color;

  const PlayingButton({
    Key key,
    this.icon,
    this.onPressed,
    this.color = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
      ),
      iconSize: 30.0,
      onPressed: onPressed,
    );
  }
}
