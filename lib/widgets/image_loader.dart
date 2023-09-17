import 'package:flutter/cupertino.dart';

enum ImageType {asset, network}
class ImageLoader extends StatelessWidget{
  final double? width;
  final double? height;
  final String source;
  final BoxFit? fit;
  late Image image;

  ImageLoader({Key? key, this.width, this.height, required this.source,
    this.fit}) : super(key: key){
    image = _getImage(source, fit);
  }

  _getImage(source, fit){
    final ImageType imageType = ImageType.asset;
    final fit = _getFit(width, height);

    switch(imageType){
      case ImageType.asset:
      default:
        return Image.asset(source, fit: fit);
    }
  }

  _getFit(width, height){
    if (fit != null) return fit;
    if (width == null && height != null) return BoxFit.fitHeight;
    if (width != null && height == null) return BoxFit.fitWidth;
    if (width != null && height != null) return BoxFit.cover;
    if (width == null && height == null) return BoxFit.none;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: image);
  }
}