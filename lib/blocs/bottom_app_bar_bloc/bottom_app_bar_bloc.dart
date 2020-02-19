import 'package:rxdart/rxdart.dart';
import 'package:tmdb_viewer_8/blocs/bloc_base.dart';

class BottomAppBarBloc implements BlocBase {
  final BehaviorSubject<int> _pageController = BehaviorSubject<int>.seeded(0);

  Stream<int> get outPage => _pageController.stream;

  int _page = 0;

  void setPage(int page) {
    if (page != _page) {
      _page = page;
      _pageController.sink.add(_page);
    }
  }

  @override
  void dispose() {
    _pageController.close();
  }
}
