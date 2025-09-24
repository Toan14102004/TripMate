import 'package:flutter/material.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  const BasicAppbar({
    this.title,
    this.hideBack = false,
    this.action,
    this.backgroundColor,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      title: title ?? const Text(''),
      actions: [
        action ?? Container()
      ],
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
