import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RProfilePageTile extends StatelessWidget {
  const RProfilePageTile({
    super.key,
    required this.title,
    required this.onPressed,
    required this.icon,
    required this.trailing,
  });

  final String title;
  final Function()? onPressed;
  final IconData icon;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      onTap: onPressed,
      title: Text(
        title,
        style: context.textTheme.bodyMedium,
      ),
      trailing: trailing,
      iconColor: context.theme.colorScheme.primary,
    );
  }
}
