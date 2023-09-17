import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget{
  final String adId;

  const AdBanner({Key? key, required this.adId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AdBannerState();
}

class AdBannerState extends State<AdBanner>{
  BannerAd? bannerAd;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async{
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());
    if (size == null) return;
    bannerAd = BannerAd(adUnitId: widget.adId, size: size,
            request: const AdRequest(),
            listener: BannerAdListener(
                onAdLoaded: (ad) {
                  setState((){
                    bannerAd = ad as BannerAd;
                  });
                },
                onAdFailedToLoad: (ad, error) => dispose()));
    return bannerAd?.load();
  }

  @override
  Widget build(BuildContext context) {
    double width = bannerAd?.size.width.toDouble() ?? 0.0;
    double height = bannerAd?.size.height.toDouble() ?? 0.0;
    if (width < 0.0) width = 0.0;
    if (height < 0.0) height = 0.0;

    return SizedBox(height: height, width: width,
      child: (bannerAd != null) ? AdWidget(ad: bannerAd!) : Container());
  }

  @override
  dispose(){
    super.dispose();
    bannerAd?.dispose();
  }
}