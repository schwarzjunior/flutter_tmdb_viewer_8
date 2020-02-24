import 'package:flutter/material.dart';
import 'package:tmdb_viewer_8/ui/screens/search/widgets/top_bar_button.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool darkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final Color buttonColor = Theme.of(context).bottomAppBarColor;
    final Color buttonLabelColor = darkMode ? Colors.lightBlueAccent : Colors.blue;
    final Color buttonSeparatorColor = Theme.of(context).dividerColor.withOpacity(darkMode ? 0.5 : 0.3);
    final Color topBarShadowColor = Colors.grey[darkMode ? 500 : 400];

    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: const Offset(0.0, 2.0),
            color: topBarShadowColor,
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          TopBarButton(
            label: 'All',
            labelColor: buttonLabelColor,
            decoration: BoxDecoration(),
            onPressed: () {},
          ),
          TopBarButton(
            label: 'Movies',
            labelColor: buttonLabelColor,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: buttonSeparatorColor)),
            ),
            onPressed: () {},
          ),
          TopBarButton(
            label: 'Tv Shows',
            labelColor: buttonLabelColor,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: buttonSeparatorColor)),
            ),
            onPressed: () {},
          ),
          TopBarButton(
            label: 'Persons',
            labelColor: buttonLabelColor,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: buttonSeparatorColor)),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
