import 'package:customer_app_planzaa/common/utils.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ZegoService {
  static const int appID = 948287968;
  static const String appSign =
      "0eb5ab65ff17a3d2a0fc1300a4a9a7bb88d6e969c457cd34584ddc8ebe463808";

  static bool _isCallInitialized = false;
  static bool _isChatConnected = false;



  static Future<bool> login({
    required String userID,
    required String userName,
  }) async {
    try {
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
        events: ZegoUIKitPrebuiltCallEvents(
          onError: (error) {
            print("Call error code: ${error.code}");
            print("Call error message: ${error.message}");

            if (error.code == 6000281) {
              Utils.showToast(
                "User is offline or not available for calls.",
              );
            } else {
              Utils.showToast("Call failed: ${error.message}");
            }
          },
        ),
      );

      _isCallInitialized = true;

      // await ZIMKit().init(
      //   appID: appID,
      //   appSign: appSign,
      // );

      final errorCode = await ZIMKit().connectUser(
        id: userID,
        name: userName,
        avatarUrl: 'https://robohash.org/$userID.png',
      );

      if (errorCode != 0) return false;

      _isChatConnected = true;

      return true;
    } catch (e) {
      print("Zego login error: $e");
      return false;
    }
  }

  static Future<void> logout() async {
    await ZIMKit().disconnectUser();
    await ZegoUIKitPrebuiltCallInvitationService().uninit();

    _isCallInitialized = false;
    _isChatConnected = false;
  }

  static bool get isReady => _isCallInitialized && _isChatConnected;
}
