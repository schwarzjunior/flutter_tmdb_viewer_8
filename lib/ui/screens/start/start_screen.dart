import 'package:flutter/material.dart';
import 'package:tmdb_viewer_8/ui/screens/base/base_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  static const int _fadeAnimationDuration = 1000;
  static const int _startAnimationDelay = 1000;
  static const int _innerAnimationsDuration = 1000;
  static const Color _titleColor = Color(0xff00e676); // Colors.greenAccent[400]

  AnimationController _opacityController;

  @override
  void initState() {
    super.initState();

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _fadeAnimationDuration),
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(milliseconds: _innerAnimationsDuration)).whenComplete(() {
            _opacityController.reverse();
          });
        } else if (status == AnimationStatus.dismissed) {
          _startApp();
        }
      });

    Future.delayed(const Duration(milliseconds: _startAnimationDelay)).whenComplete(() {
      _opacityController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Opacity(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).evaluate(_opacityController),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/tmdb-powered-by-rectangle-green.png',
                width: MediaQuery.of(context).size.width / 1.5,
              ),
              const SizedBox(height: 40.0),
              Text(
                'TMDb Viewer',
                style: Theme.of(context).textTheme.title.copyWith(
                  color: _titleColor,
                  fontSize: 30.0,
                  letterSpacing: 4.0,
                  shadows: <Shadow>[
                    const Shadow(
                      offset: const Offset(2, 2),
                      color: _titleColor,
                      blurRadius: 20.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  void _startApp() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => BaseScreen(),
    ));
  }
}
