import 'package:flutter/material.dart';

Future<dynamic> pushSlideMove(page, context, direction) async {
  return await Navigator.of(context).push(
      PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondary) => page,
          transitionsBuilder: (context, animation, secondary, child){
            var begin = Offset(1.5 * direction, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween),
                child: child
            );
          }
      )
  );
}

Future<dynamic> replaceSlideMove(page, context, direction) async {
  return await Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondary) => page,
      transitionsBuilder: (context, animation, secondary, child) {
        var begin = Offset(1.5 * direction, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end)
            .chain(CurveTween(curve: curve));

        return SlideTransition(
            position: animation.drive(tween),
            child: child
        );
      }
  ));
}

Future<dynamic> removeSlideMove(page, context, direction) async {
  return await Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondary) => page,
          transitionsBuilder: (context, animation, secondary, child) {
            var begin = Offset(1.5 * direction, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween),
                child: child
            );
          }
      ),
          (route) => false
  );
}