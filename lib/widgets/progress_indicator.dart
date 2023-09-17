import 'package:flutter/material.dart';
import 'package:kowanas_util/resource/kowanas_font.dart';
import 'package:kowanas_util/resource/kowanas_screen.dart';

import 'image_loader.dart';

class KowanasProgressIndicator extends StatelessWidget{
  late ImageLoader indicatorImage;
  late Widget progressBarImages;
  final int index;
  final int min;
  final int max;
  final String? minLabel;
  final String? maxLabel;
  final double width;
  final double height;
  final double barImageRatio;
  final double indicatorImageRatio;
  final double indicatorRate;
  final bool progressBarFit;
  final bool showLabel;
  late int length;
  late int position;
  late double indicatorWidth;
  late double progressBarHeight;

  Widget _getProgressBarWidgets(barImage, barWidth, barHeight){
    if (progressBarFit){
      return ImageLoader(source: barImage, width: barWidth, height: barHeight,
          fit: BoxFit.cover);
    }else {
      final progressBarImage = ImageLoader(source: barImage,
          width: barWidth);
      final repeat = (width / barWidth).toInt();
      final widgets = <Widget>[];
      for (int i = 0; i < repeat; i++) {
        widgets.add(progressBarImage);
      }
      final remainingWidth = width - repeat * barWidth;
      widgets.add(ImageLoader(source: barImage, width: remainingWidth,
          height: barHeight, fit: BoxFit.fitHeight));
      return Row(children: widgets);
    }
  }

  KowanasProgressIndicator({Key? key, indicator, progressBar, required this.index,
    this.minLabel, this.maxLabel,
    this.min = 0, required this.max, required this.width, required this.height,
    required this.barImageRatio, required this.indicatorImageRatio,
    this.indicatorRate = 0.75, this.progressBarFit = false,
    this.showLabel = false}) : super(key: key){

    length = max - min;
    position = index-min;

    final indicatorHeight = height*indicatorRate;
    indicatorWidth = indicatorImageRatio*indicatorHeight;
    indicatorImage = ImageLoader(source: indicator, height: indicatorHeight);

    progressBarHeight = height*(1.0-indicatorRate);
    final progressBarWidth = (progressBarFit)
        ? width : barImageRatio*progressBarHeight;
    progressBarImages = _getProgressBarWidgets(progressBar, progressBarWidth,
        progressBarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final kf = KowanasFont();
    final ks = KowanasScreen(context);
    final indicatorX = (width - indicatorWidth) / (length - 1) * position;
    return SizedBox(width: width, height: height,
        child: Stack(children: [
          Positioned(left: indicatorX, child: indicatorImage),
          Positioned(bottom: 0.0, child: progressBarImages),
          (showLabel) ?
          Positioned(bottom: 0.0, child: Container(
              alignment: Alignment.center,
              width: width,
              height: progressBarHeight,
              padding: EdgeInsets.fromLTRB(ks.hsize(0.01), 0.0, ks.hsize(0.01), 0.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(minLabel ?? min.toString(),
                        style: kf.style(size: 0, weight: 400,
                        color: Colors.pink)),
                    Text(maxLabel ?? max.toString(),
                        style: kf.style(size: 0, weight: 400,
                        color: Colors.white))
                  ]))) : Container()
        ]));
  }
}