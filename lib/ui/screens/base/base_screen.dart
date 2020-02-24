import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_viewer_8/blocs/bottom_app_bar_bloc/bottom_app_bar_bloc.dart';
import 'package:tmdb_viewer_8/ui/common/custom_bottom_app_bar/custom_bottom_app_bar.dart';
import 'package:tmdb_viewer_8/ui/screens/favorites/favorites_screen.dart';
import 'package:tmdb_viewer_8/ui/screens/search/search_screen.dart';
import 'package:tmdb_viewer_8/ui/screens/trending/trending_screen.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController _pageController = PageController();

  BottomAppBarBloc _bottomAppBarBloc;
  StreamSubscription _bottomAppBarSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final BottomAppBarBloc bottomAppBarBloc = Provider.of<BottomAppBarBloc>(context);
    if (bottomAppBarBloc != _bottomAppBarBloc) {
      _bottomAppBarBloc = bottomAppBarBloc;

      _bottomAppBarSubscription?.cancel();
      _bottomAppBarSubscription = _bottomAppBarBloc.outPage.listen((page) {
        _pageController.jumpToPage(page);
      });
    }
  }

  @override
  void dispose() {
    _bottomAppBarSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          TrendingScreen(),
          SearchScreen(),
          FavoritesScreen(),
          Container(
              color: Colors.indigo,
              child: Center(
                  child: Text(
                'Settings Screen',
                style: Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
              ))),
        ],
      ),
      bottomNavigationBar: CustomBottomAppBar(),
    );
  }
}
