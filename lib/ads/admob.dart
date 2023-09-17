
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdmobType {Banner}

typedef AdLoadedCallback = void Function();
class Admob{
  final adUnit;
  dynamic ad;
  final AdLoadedCallback onLoaded;
  bool loaded = false;

  Admob({this.adUnit, required this.onLoaded});

  load(){
    switch(adUnit.type){
      case AdmobType.Banner:
        ad = BannerAd(adUnitId: adUnit.uid, size: AdSize.banner,
                      request: AdRequest(),
                      listener: BannerAdListener(onAdLoaded: (_){
                        loaded = true;
                        onLoaded();
                      },
                      onAdFailedToLoad: (ad, error) => dispose()));
    }
    ad.load();
  }

  dispose(){
    loaded = false;
    ad?.dispose();
  }
}