import 'package:flutter/material.dart';

class CustomDrawerTile extends StatelessWidget {
  const CustomDrawerTile(
      {super.key, required this.text, this.icon, this.onTap, this.color});

  final String text;
  final IconData? icon;
  final void Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(
            color: color,
          ),
        ),
        leading: Icon(
          icon,
          color: color,
        ),
        onTap: onTap,
      ),
    );
  }
}
