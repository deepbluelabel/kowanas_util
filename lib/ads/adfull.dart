import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdFull{
  final adId;
  final finishedCallback;
  InterstitialAd? _interstitialAd;

  AdFull({this.adId, this.finishedCallback}){
    InterstitialAd.load(
        adUnitId: adId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad){
              ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad) => finishedCallback()
              );
              print('full ad is loaded');
              _interstitialAd = ad;
            },
            onAdFailedToLoad: (err) {
              print('full ad loading is failed');
              finishedCallback();
            })
    );
  }

  show(){
    if(_interstitialAd == null){
      print('full ad loading is not initiated');
      finishedCallback();
    }else{
      print('full ad loading is showing');
      _interstitialAd?.show();
    }
  }
}