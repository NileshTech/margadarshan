import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:margadarshan/pages/a_pages_index.dart';

class DynamicLinkService {
  static final DynamicLinkService _dynamicLinkService =
      DynamicLinkService._internal();

  factory DynamicLinkService() => _dynamicLinkService;

  DynamicLinkService._internal();

  Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
    _handleDeepLink(data);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // 3a. handle link that has been retrieved
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');
      deepLink.queryParameters.forEach((key, value) {
        print('_handleDeepLink | key: $key | value: $value');
        if (key == 'route') {
          switch (value) {
            case 'matListScreen':
              YipliUtils.goToMatMenu();
              break;
            case 'playerListScreen':
              YipliUtils.goToPlayersPage();
              break;
          }
        }
      });
    }
  }
}
