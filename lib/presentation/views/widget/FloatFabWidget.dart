import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../../resource/colors.dart';
import '../../../resource/dimens.dart';

class FloatFabWidget extends StatelessWidget {
  FloatFabWidget(this.icon,this.margin,this.function,this.open,{Key? key,this.size=Dimens.iconSize}) : super(key: key);

  final List<double> margin;
  final bool open;
  final IconData icon;
  final Function function;
  double size;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top:margin[0]==0?null:margin[0],
      bottom:margin[1]==0?null:margin[1],
      left:margin[2]==0?null:margin[2],
      right:margin[3]==0?null:margin[3],
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
          child: AnimatedPositioned(
            duration: const Duration(milliseconds: 3000),
            curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
            child: AnimatedOpacity(
              opacity: open ?  1.0:0.0,
              curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
              duration: const Duration(milliseconds: 250),
              child: FloatingActionButton(
                backgroundColor: AppColor.mainColor,
                onPressed: (){
                  function();
                },
                child: Icon(icon,
                    size: size),
              ),
            ),
          ),
      ),
    );
  }
}
