import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  CustomButton(
      {this.diameter, this.onPressed, this.child, this.isToggled = false});

  final double diameter;
  final IconData child;
  final Function onPressed;
  final bool isToggled;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.3,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onPressed,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          child: Transform.scale(
            scale: 1 - _controller.value,
            child: Container(
              child: Center(
                child: Icon(widget.child,
                    size: 30.0,
                    color: widget.isToggled ? Colors.black : Colors.red),
              ),
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).splashColor,
                    offset: Offset(2, 2),
                    blurRadius: 10,
                  ),
                  // BoxShadow(
                  //   color: Theme.of(context).backgroundColor,
                  //   offset: Offset(-6, -6),
                  //   blurRadius: 10,
                  //   spreadRadius: 1.0,
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
