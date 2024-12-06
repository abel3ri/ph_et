import 'package:flutter/material.dart';

class RListTile extends StatelessWidget {
  const RListTile({
    super.key,
    required this.title,
    this.leadingIcon,
    this.trailingIcon,
    required this.onPressed,
  });

  final String title;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon != null ? Icon(leadingIcon) : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      trailing: leadingIcon != null ? Icon(trailingIcon) : null,
      onTap: onPressed,
    );
  }
}
