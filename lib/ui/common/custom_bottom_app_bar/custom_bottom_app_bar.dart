import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_viewer_8/blocs/bottom_app_bar_bloc/bottom_app_bar_bloc.dart';
import 'package:tmdb_viewer_8/ui/common/custom_bottom_app_bar/widgets/bottom_app_bar_button.dart';

class CustomBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BottomAppBarBloc bloc = Provider.of<BottomAppBarBloc>(context);

    return StreamBuilder<int>(
      stream: bloc.outPage,
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                offset: const Offset(0, -0.5),
                color: Colors.grey[400],
                blurRadius: 10.0,
              ),
            ],
          ),
          child: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                BottomAppBarButton(
                  iconData: Icons.trending_up,
                  label: 'Trending',
                  highlighted: snapshot.data == 0,
                  onPressed: () => _setPage(bloc, 0),
                ),
                BottomAppBarButton(
                  iconData: Icons.search,
                  label: 'Search',
                  highlighted: snapshot.data == 1,
                  onPressed: () => _setPage(bloc, 1),
                ),
                BottomAppBarButton(
                  iconData: Icons.favorite,
                  label: 'Favorites',
                  highlighted: snapshot.data == 2,
                  onPressed: () => _setPage(bloc, 2),
                ),
                BottomAppBarButton(
                  iconData: Icons.settings,
                  label: 'Settings',
                  highlighted: snapshot.data == 3,
                  onPressed: () => _setPage(bloc, 3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _setPage(BottomAppBarBloc bloc, int page) {
    bloc.setPage(page);
  }
}
