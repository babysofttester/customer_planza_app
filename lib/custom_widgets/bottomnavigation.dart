// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/bottomnavcontroller.dart';

// class BottomNavBar extends StatelessWidget {
//   BottomNavBar({super.key});

//   final BottomNavController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => BottomNavigationBar(
//       currentIndex: controller.selectedIndex.value,
//       onTap: controller.changeIndex,
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Colors.white,
//       selectedItemColor: AppColors.primary,
//       unselectedItemColor: Colors.grey,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           activeIcon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.settings_outlined),
//           activeIcon: Icon(Icons.settings),
//           label: 'Services',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.file_copy_outlined),
//           activeIcon: Icon(Icons.file_copy),
//           label: 'Projects',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.notifications_none_outlined),
//           activeIcon: Icon(Icons.notifications),
//           label: 'Notifications',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           activeIcon: Icon(Icons.person),
//           label: 'Profile',
//         ),
//       ],
//     ));
//   }
// }

