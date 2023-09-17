import 'package:get/get.dart';

enum LoadingState { loading, loaded }
typedef LoadingHandler = Future<void> Function();
class LoadingController extends GetxController{
  final String nextPageName;
  final state = LoadingState.loading.obs;

  LoadingController({required this.nextPageName});

  load(LoadingHandler handler) async{
    await handler();
    state.value = LoadingState.loaded;
    Get.toNamed(nextPageName);
  }
}