import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';

extension KowanasTrans on String {
  String get ktr {
    return HtmlUnescape().convert(this.tr);
  }
}
