// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import '../../modal/projectmodal.dart';
// import '../../module/HomePage/screen/homescreen.dart';
// import '../../module/Profile/screen/profileScreen.dart';
// import '../../module/Project/Project/screen/project.dart';
// import '../../module/services/screen/servicescreen.dart';
// import '../../utils/app_fonts.dart';

// class BottomNavController extends GetxController {
//    ProjectsItem? item;
//   final selectedIndex = 0.obs;
//    dynamic arguments;


//    /// which inner page is open inside a tab
//   final innerPage = Rxn<Widget>();
//   final innerTitle = RxnString();


//   /// root tab pages
//    final tabRoots = [
//     HomeScreen(),
//     ServiceScreen(),
//     ProjectPage(),
//     ProjectPage(), // notifications
//     ProfileScreen(item: null,),
//   ];

//   /// tab AppBars
//   final tabAppBars = <PreferredSizeWidget?>[

//     null,
//     AppBar(backgroundColor: Colors.white, title: Text("Services", style: AppFonts.allHeading()), leading: Icon(Icons.arrow_back_ios),),
//     AppBar(backgroundColor: Colors.white,title: Text("Projects",style: AppFonts.allHeading()), leading: Icon(Icons.arrow_back_ios),),
//     AppBar(backgroundColor: Colors.white,title: Text("Notifications", style: AppFonts.allHeading()), leading: Icon(Icons.arrow_back_ios),),
//     AppBar(backgroundColor: Colors.white,title: Text("Profile", style: AppFonts.allHeading()), leading: Icon(Icons.arrow_back_ios),),
//   ];

//   /// ALWAYS SAFE appBar
//   PreferredSizeWidget get currentAppBar {
//     // Inner page AppBar (Add Project, Designer, Services etc.)
//     if (innerTitle.value != null) {
//       return AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(innerTitle.value!, style: AppFonts.allHeading()),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: popInner,
//         ),

//       );
//     }

//     // Tab AppBar (Services, Projects, Profile...)
//     final bar = tabAppBars[selectedIndex.value];
//     if (bar != null) return bar;

//     // ✅ HOME → NO APPBAR
//     return const PreferredSize(
//       preferredSize: Size.zero,
//       child: SizedBox.shrink(),
//     );
//   }



//   /// page shown in body
//   Widget get currentPage {
//     return innerPage.value ?? tabRoots[selectedIndex.value];
//   }

//   /// switch tab
//   void changeIndex(int index) {
//     selectedIndex.value = index;
//     innerPage.value = null;
//     innerTitle.value = null;
//   }

//   /// open inner page WITH bottom nav
//    void openInner({
//      required Widget page,
//      required String title,
//      dynamic arguments,
//    }) {
//      innerPage.value = page;
//      innerTitle.value = title;

//      // store arguments manually
//      this.arguments = arguments;
//    }


//    /// close inner page
//   void popInner() {
//     innerPage.value = null;
//     innerTitle.value = null;
//   }
// }

