import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_transition_screen/view_models/home_model.dart';

class AnimatedCircle extends AnimatedWidget {
  final Tween<double> tween;
  final Tween<double>? horizontalTween;
  final Animation<double> animation;
  final Animation<double>? horizontalAnimation;
  final double flip;
  final Color color;

  final int radius = 40;

  AnimatedCircle({
    Key? key,
    required this.tween,
    this.horizontalTween,
    required this.animation,
    this.horizontalAnimation,
    required this.flip,
    required this.color,
  })  : assert(flip == 1 || flip == -1),
        super(listenable: animation, key: key);

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);
    return Transform(
      alignment: FractionalOffset.centerLeft,
      transform: Matrix4.identity()
        ..scale(
          tween.evaluate(animation) * flip,
          tween.evaluate(animation),
        ),
      child: Transform(
        transform: Matrix4.identity()
          ..translate(
            horizontalTween != null && horizontalAnimation != null ? horizontalTween!.evaluate(horizontalAnimation!) : 0.0,
          ),
        child: Container(
          width: radius.toDouble(),
          height: radius.toDouble(),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              radius * 0.5 - tween.evaluate(animation) / (radius * 0.5),
            ),
          ),
          child: Icon(
            flip == 1 ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
            color: model.index % 2 == 0 ? Colors.white : Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> startAnimation;
  late Animation<double> endAnimation;
  late Animation<double> horizontalAnimation;
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    startAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.000,
        0.5,
        curve: Curves.easeInExpo,
      ),
    );

    endAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.5,
        1,
        curve: Curves.easeOutExpo,
      ),
    );

    horizontalAnimation = CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0.750,
        1.0,
        curve: Curves.easeInOutQuad,
      ),
    );

    animationController
      ..addStatusListener(
        (status) {
          final model = Provider.of<HomeModel>(context, listen: false);
          if (status == AnimationStatus.completed) {
            model.swapColors();
            animationController.reset();
          }
        },
      )
      ..addListener(() {
        final model = Provider.of<HomeModel>(context, listen: false);
        if (animationController.value > 0.5) {
          model.isHalfWay = true;
        } else {
          model.isHalfWay = false;
        }
      });
  }

  @override
  void dispose() {
    pageController.dispose();
    animationController.dispose();
    super.dispose();
  }

  final int radius = 40;
  final int bottomPadding = 100;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);
    final Size size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      backgroundColor: model.isHalfWay ? model.foregroundColor : model.backgroundColor,
      body: Stack(
        children: [
          Container(
            color: model.isHalfWay ? model.foregroundColor : model.backgroundColor,
            width: screenWidth / 2.0 - radius / 2,
            height: double.infinity,
          ),
          Transform(
            transform: Matrix4.identity()
              ..translate(
                screenWidth * 0.5 - (radius * 0.5),
                screenHeight - radius - bottomPadding,
              ),
            child: GestureDetector(
              onTap: () {
                if (animationController.status != AnimationStatus.forward) {
                  model.isToggled = !model.isToggled;
                  model.index++;
                  if (model.index > 3) {
                    model.index = 0;
                  }

                  pageController.animateToPage(
                    model.index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutQuad,
                  );
                  animationController.forward();
                }
              },
              child: Stack(
                children: [
                  AnimatedCircle(
                    animation: startAnimation,
                    color: model.foregroundColor,
                    flip: 1.0,
                    tween: Tween<double>(begin: 1.0, end: radius.toDouble()),
                  ),
                  AnimatedCircle(
                    animation: endAnimation,
                    color: model.backgroundColor,
                    horizontalTween: Tween<double>(
                      begin: 0.0,
                      end: -radius.toDouble(),
                    ),
                    flip: -1.0,
                    horizontalAnimation: horizontalAnimation,
                    tween: Tween<double>(begin: radius.toDouble(), end: 1.0),
                  )
                ],
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: PageView.builder(
              controller: pageController,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    'Page ${index + 1}',
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
