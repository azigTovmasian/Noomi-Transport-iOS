import 'package:flutter/material.dart';

class NoInternetW extends StatefulWidget {
  const NoInternetW({Key? key}) : super(key: key);

  @override
  _NoInternetWState createState() => _NoInternetWState();
}

class _NoInternetWState extends State<NoInternetW>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Image.asset(
                    'assets/images/no_internet.PNG',
                    width: 120,
                    height: 120,
                  ),
                );
              },
            ),
            Text(
              'Oops! Something went wrong.\n You lost internet connection',
              style: TextStyle(fontSize: 20),
            ),
           SizedBox(height: 250,)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
