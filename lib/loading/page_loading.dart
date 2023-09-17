import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:kowanas_util/loading/loading_controller.dart';

class PageLoading extends GetView<LoadingController>{
  Widget? loadingUI;

  Widget _getDefaultLoadingUI(){
    return Center(child: CircularProgressIndicator());
  }

  PageLoading({this.loadingUI}){
    loadingUI ??= _getDefaultLoadingUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loadingUI
    );
  }
}