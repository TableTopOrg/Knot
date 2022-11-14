import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:knot/constants.dart';
import 'package:knot/pages/welcome/components/welcome_page_body.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: WelcomPageBody(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "Notes",
        style: Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(color: textColorLight, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        IconButton(
            onPressed: () {},
            icon: const FaIcon(
              FontAwesomeIcons.gear,
              color: textColorLight,
            )),
        const SizedBox(width: 10)
      ],
    );
  }
}
