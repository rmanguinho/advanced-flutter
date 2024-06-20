import 'package:flutter/material.dart';

final class PlayerPhoto extends StatelessWidget {
  final String initials;
  final String? photo;

  const PlayerPhoto({
    required this.initials,
    this.photo,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundImage: photo != null ? NetworkImage(photo!) : null,
      child: photo == null ? Text(initials) : null
    );
  }
}
