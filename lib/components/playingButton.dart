import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlayingButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final Color color;
  final String svgImage;

  const PlayingButton({
    Key key,
    this.icon,
    this.onPressed,
    this.svgImage,
    this.color = Colors.grey,
  }) : assert(svgImage != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: svgImage != null
          ? SvgPicture.asset(
              svgImage,
              height: 30,
              width: 30,
              color: color,
            )
          : Icon(
              icon,
              color: color,
            ),
      iconSize: 30.0,
      onPressed: onPressed,
    );
  }
}
