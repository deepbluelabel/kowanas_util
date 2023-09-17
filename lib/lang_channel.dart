import 'package:flutter/services.dart';
import 'package:get/get.dart';

typedef UriHandler = void Function(String uri);
class LangChannel{
  LangChannel._internal();
  static final _instance = LangChannel._internal();
  factory LangChannel() => _instance;

  final _channel = BasicMessageChannel<String>('lang', StringCodec());
  UriHandler? _handler;

  setHandler(UriHandler handler){
    _handler = handler;
    _channel.setMessageHandler((message) async {
      _handler!(message ?? '');
      return message ?? '';
    });
  }
}