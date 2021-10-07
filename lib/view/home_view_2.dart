import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ui_transition_screen/global.dart';
import 'package:ui_transition_screen/view/home_view.dart';
import 'package:ui_transition_screen/view_models/home_model.dart';
import 'package:ui_transition_screen/view_models/home_model_2.dart';

class HomeView2 extends StatefulWidget {
  HomeView2({Key? key}) : super(key: key);

  @override
  _HomeView2State createState() => _HomeView2State();
}

class _HomeView2State extends State<HomeView2> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> beginAnimation;
  late Animation<double> endAnimation;
  late Animation<double> horizontalAnimation;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    beginAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(.0, .5, curve: Curves.easeInExpo),
    );

    endAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(.5, 1, curve: Curves.easeOutExpo),
    );

    horizontalAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.75, 1, curve: Curves.easeOutQuint),
    );

    _animationController
      ..addStatusListener((status) {
        final model = Provider.of<HomeModel2>(context, listen: false);
        if (status == AnimationStatus.completed) {
          model.index++;
          model.swapColors();
          _animationController.reset();
        }
      })
      ..addListener(
        () {
          final model = Provider.of<HomeModel2>(context, listen: false);

          if (_animationController.value > 0.5) {
            model.isHalfWay = true;
          } else {
            model.isHalfWay = false;
          }
        },
      );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel2>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: model.isHalfWay ? model.foregroundColor : model.backgroundColor,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Container(
              width: size.width * 0.5 - Global.radius / 2,
              height: size.height,
              color: model.isHalfWay ? model.foregroundColor : model.backgroundColor,
            ),
            Positioned(
              left: size.width * 0.5 - Global.radius / 2,
              bottom: Global.bottomPading.toDouble(),
              child: GestureDetector(
                onTap: () {
                  _animationController.forward();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedCircle(
                      animation: beginAnimation,
                      tween: Tween<double>(begin: 1, end: Global.radius.toDouble()),
                      flip: 1,
                      color: model.foregroundColor,
                    ),
                    AnimatedCircle(
                      animation: endAnimation,
                      tween: Tween<double>(begin: Global.radius.toDouble(), end: 1),
                      flip: -1,
                      horizontalAnimation: horizontalAnimation,
                      color: model.backgroundColor,
                      horizontalTween: Tween<double>(begin: 0, end: Global.radius.toDouble()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedCircle extends AnimatedWidget {
  final Animation<double> animation;
  final Animation<double>? horizontalAnimation;
  final Tween<double> tween;
  final Tween<double>? horizontalTween;
  final double flip;
  final Color color;

  const AnimatedCircle({
    Key? key,
    required this.animation,
    required this.tween,
    this.horizontalAnimation,
    this.horizontalTween,
    required this.flip,
    required this.color,
  })  : assert(flip == 1 || flip == -1),
        super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(horizontalTween != null && horizontalAnimation != null ? horizontalTween!.evaluate(horizontalAnimation!) : 0.0),
      child: Transform(
        alignment: Alignment.centerLeft,
        transform: Matrix4.identity()
          ..scale(
            tween.evaluate(animation) * flip,
          ),
        child: Container(
          width: Global.radius.toDouble(),
          height: Global.radius.toDouble(),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}
