import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final IconData icon;
  final String buttonName;
  final Function onPress;

  const ControlButton({
    Key key,
    this.icon,
    this.buttonName = '',
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPress,
      splashColor: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 20.0,
            color: Colors.black,
          ),
          Text(
            buttonName,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
