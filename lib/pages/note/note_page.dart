import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:knot/constants.dart';
import 'package:knot/notes/notes.dart';

class FloatingNote extends StatefulWidget {
  const FloatingNote({super.key, required this.note});

  final Note note;

  @override
  State<FloatingNote> createState() => _FloatingNoteState();
}

class _FloatingNoteState extends State<FloatingNote> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.note.title,
        style: Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(color: textColorLight, fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset("assets/icons/back.svg")),
    );
  }
}
