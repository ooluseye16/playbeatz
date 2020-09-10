import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomNavBarItem extends StatelessWidget {
  final String svgImage;
  final Function onPressed;
  final Color color;
  final String label;

  CustomNavBarItem({this.svgImage, this.onPressed, this.color, this.label});

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
                child: svgImage != null
                    ? SvgPicture.asset(
                        svgImage,
                        height: 30,
                        width: 30,
                        color: color,
                      )
                    : Icon(
                        Icons.album,
                        size: 27.0,
                        color: color,
                      )),
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
