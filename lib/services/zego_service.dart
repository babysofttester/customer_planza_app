// chat working , calling sound, notification not checked

import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_zim/zego_zim.dart';
import 'notification_service.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class ZegoService {
  static const int appID = 948287968;
  static const String appSign =
      "0eb5ab65ff17a3d2a0fc1300a4a9a7bb88d6e969c457cd34584ddc8ebe463808";

  static bool _isInitialized = false;

  static Future<bool> login({
    required String userID,
    required String userName,
    GlobalKey<NavigatorState>? navigatorKey,
  }) async {
    try {
      if (_isInitialized) return true;

      print("🔧 Zego Init - User: $userID");

      /// 1️⃣ INIT CALL SERVICE
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
        invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
          onIncomingCallReceived: (
            String callID,
            ZegoCallUser caller,
            ZegoCallInvitationType callType,
            List<ZegoCallUser> callees,
            String customData,
          ) {
            FlutterRingtonePlayer().play(
              android: AndroidSounds.ringtone,
              looping: true,
            );
          },
          onIncomingCallCanceled: (_, __, ___) {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallTimeout: (_, __) {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallAcceptButtonPressed: () {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallDeclineButtonPressed: () {
            FlutterRingtonePlayer().stop();
          },
        ),
        requireConfig: (ZegoCallInvitationData data) {
          return ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
        },
      );

      /// 2️⃣ INIT ZIMKIT (THIS HANDLES ZIM LOGIN INTERNALLY)
      await ZIMKit().init(
        appID: appID,
        appSign: appSign,
      );

      final code = await ZIMKit().connectUser(
        id: userID,
        name: userName,
      );

      if (code != 0) {
        print("❌ ZIMKit login failed: $code");
        return false;
      }

      /// 3️⃣ SET MESSAGE LISTENER (STATIC CALLBACK)
      ZIMEventHandler.onPeerMessageReceived = (ZIM zim,
          List<ZIMMessage> messageList,
          ZIMMessageReceivedInfo info,
          String fromUserID) {
        for (var message in messageList) {
          if (message is ZIMTextMessage) {
            NotificationService.showNotification(
              title: fromUserID,
              body: message.message,
            );
          }
        }
      };

      ZIMEventHandler.onGroupMessageReceived = (ZIM zim,
          List<ZIMMessage> messageList,
          ZIMMessageReceivedInfo info,
          String fromGroupID) {
        for (var message in messageList) {
          if (message is ZIMTextMessage) {
            NotificationService.showNotification(
              title: "Group: $fromGroupID",
              body: message.message,
            );
          }
        }
      };

      _isInitialized = true;
      print("✅ Zego Service Initialized Successfully");

      return true;
    } catch (e) {
      print("❌ Zego login error: $e");
      return false;
    }
  }

  static Future<void> logout() async {
    await ZIMKit().disconnectUser();
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    _isInitialized = false;
  }

  static bool get isReady => _isInitialized;
}



// not checked calling ringtone working, notification of chat message but chat not working 
/* import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_zim/zego_zim.dart';
import 'notification_service.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class ZegoService {
  static const int appID = 948287968;
  static const String appSign =
      "0eb5ab65ff17a3d2a0fc1300a4a9a7bb88d6e969c457cd34584ddc8ebe463808";

  static bool _isInitialized = false;
  static ZIM? _zim;

  static Future<bool> login({
    required String userID,
    required String userName,
    GlobalKey<NavigatorState>? navigatorKey,
  }) async {
    try {
      if (_isInitialized) return true;

      print("🔧 Zego Init - User: $userID");

      /// =========================
      /// 1️⃣ INIT CALL SERVICE
      /// =========================
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
        invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
          onIncomingCallReceived: (
            String callID,
            ZegoCallUser caller,
            ZegoCallInvitationType callType,
            List<ZegoCallUser> callees,
            String customData,
          ) {
            FlutterRingtonePlayer().play(
              android: AndroidSounds.ringtone,
              looping: true,
            );
          },
          onIncomingCallCanceled: (_, __, ___) {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallTimeout: (_, __) {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallAcceptButtonPressed: () {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallDeclineButtonPressed: () {
            FlutterRingtonePlayer().stop();
          },
        ),
        requireConfig: (ZegoCallInvitationData data) {
          return ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
        },
      );

      /// =========================
      /// 2️⃣ INIT ZIM ENGINE
      /// =========================
      _zim = ZIM.create(
        ZIMAppConfig()..appID = appID,
      );

      await _zim!.login(
        userID,
        ZIMLoginConfig()..userName = userName,
      );

      /// =========================
      /// 3️⃣ SET STATIC MESSAGE LISTENERS
      /// =========================

      ZIMEventHandler.onPeerMessageReceived = (ZIM zim,
          List<ZIMMessage> messageList,
          ZIMMessageReceivedInfo info,
          String fromUserID) {
        for (var message in messageList) {
          if (message is ZIMTextMessage) {
            print("📩 Peer message from $fromUserID: ${message.message}");

            NotificationService.showNotification(
              title: fromUserID,
              body: message.message ?? '',
            );
          }
        }
      };

      ZIMEventHandler.onGroupMessageReceived = (ZIM zim,
          List<ZIMMessage> messageList,
          ZIMMessageReceivedInfo info,
          String fromGroupID) {
        for (var message in messageList) {
          if (message is ZIMTextMessage) {
            NotificationService.showNotification(
              title: "Group: $fromGroupID",
              body: message.message ?? '',
            );
          }
        }
      };

      /// =========================
      /// 4️⃣ INIT ZIMKIT (CHAT UI)
      /// =========================
      await ZIMKit().init(
        appID: appID,
        appSign: appSign,
      );

      final code = await ZIMKit().connectUser(
        id: userID,
        name: userName,
      );

      if (code != 0) {
        print("❌ ZIMKit login failed: $code");
        return false;
      }

      _isInitialized = true;
      print("✅ Zego Service Initialized Successfully for User: $userID");

      return true;
    } catch (e) {
      print("❌ Zego login error: $e");
      return false;
    }
  }

  static Future<void> logout() async {
    await _zim?.logout();
    await ZIMKit().disconnectUser();
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    _isInitialized = false;
  }

  static bool get isReady => _isInitialized;
}
 */


// actually working accept calling ringtone , and notification not coming 
/* import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'notification_service.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class ZegoService {
  static const int appID = 948287968;
  static const String appSign =
      "0eb5ab65ff17a3d2a0fc1300a4a9a7bb88d6e969c457cd34584ddc8ebe463808";

  static bool _isInitialized = false;

  static Future<bool> login({
    required String userID,
    required String userName,
    GlobalKey<NavigatorState>? navigatorKey,
  }) async {
    try {
      if (_isInitialized) return true;

      print("🔧 Zego Init - User: $userID");

      /// CALL INIT WITH PROPER CONFIGURATION
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
        invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
          onIncomingCallReceived: (String callID,
              ZegoCallUser caller,
              ZegoCallInvitationType callType,
              List<ZegoCallUser> callees,
              String customData) {
            // play ringtone when call arrives
            // create an instance because play/stop are instance methods
            FlutterRingtonePlayer()
                .play(
              android: AndroidSounds.ringtone,
              looping: true,
            )
                .catchError((e) {
              print("ringtone play error: $e");
            });
          },
          onIncomingCallCanceled:
              (String callID, ZegoCallUser caller, String customData) {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallTimeout: (String callID, ZegoCallUser caller) {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallAcceptButtonPressed: () {
            FlutterRingtonePlayer().stop();
          },
          onIncomingCallDeclineButtonPressed: () {
            FlutterRingtonePlayer().stop();
          },
        ),
        requireConfig: (ZegoCallInvitationData data) {
          print("📱 Call config created");
          return ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
        },
      );

      /// CHAT INIT
      await ZIMKit().init(
        appID: appID,
        appSign: appSign,
      );

      final code = await ZIMKit().connectUser(
        id: userID,
        name: userName,
      );

      if (code != 0) {
        print("❌ ZIM login failed: $code");
        return false;
      }

      _isInitialized = true;
      print("✅ Zego Service Initialized Successfully for User: $userID");
      return true;
    } catch (e) {
      print("❌ Zego login error: $e");
      return false;
    }
  }

  static Future<void> logout() async {
    await ZIMKit().disconnectUser();
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
    _isInitialized = false;
  }

  static bool get isReady => _isInitialized;
}
 */