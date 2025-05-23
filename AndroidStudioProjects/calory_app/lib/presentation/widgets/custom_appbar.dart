import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final List<Widget>? actions;
  
  const CustomAppbar({
    super.key,
    required this.title,
    required this.color,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: color,
      foregroundColor: Colors.white,
      actions: actions,
    );
  }
  
  CustomAppbar copyWith({
    String? title,
    Color? color,
    List<Widget>? actions,
  }) {
    return CustomAppbar(
      title: title ?? this.title,
      color: color ?? this.color,
      actions: actions ?? this.actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 