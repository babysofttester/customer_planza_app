// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart' show GetNavigation;
// import 'package:planzaa_app/module/HomePage/screen/homescreen.dart';
//
// import '../../../modal/projectmodal.dart';
// import '../../../utils/app_color.dart';
// import '../../../utils/app_fonts.dart';
// import '../../../widget/controller/bottomnavcontroller.dart';
// import '../../Project/Project/screen/project.dart';
//
//
// class AppDrawer extends StatelessWidget {
//   final ProjectsItem item;
//   final File? profileImageFile;
//
//   const AppDrawer({
//     super.key,
//     this.profileImageFile, required this.item,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final BottomNavController nav = Get.find<BottomNavController>();
//
//     return Drawer(
//       backgroundColor: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//                SizedBox(height: Get.height * 0.05),
//               Row(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.25),
//                           blurRadius: 12,
//                           spreadRadius: 2,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: CircleAvatar(
//                       radius: 40,
//                       backgroundImage: profileImageFile != null
//                           ? FileImage(profileImageFile!)
//                           : const AssetImage("assets/profile.png") as ImageProvider,
//                     ),
//                   ),
//                   SizedBox(width: Get.width * 0.05),
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Text(
//                         "Farhan Kaleem",
//                         style: AppFonts.allSubHeading(),
//                                        ),
//                        Text(
//                          "Farhan Kaleem",
//                          style: AppFonts.allSubsubHeading(),
//                        ),
//                      ],
//                    ),
//                 ],
//               ),
//
//
//               SizedBox(height: Get.height * 0.04),
//
//
//               _drawerItem(context, Icons.home_outlined, "Dashboard", () {
//                 nav.changeIndex(0); // Home tab
//               }),
//               _drawerItem(context,Icons.file_copy_outlined, "Projects", () {
//                 nav.changeIndex(2); // Projects tab
//               }),
//               _drawerItem(context, Icons.card_travel, "Order History", () {
//                 nav.openInner(
//                   page: ProjectPage(item: item,),
//                   title: "Order History",
//                 );
//               }),
//               _drawerItem(context, Icons.payment, "Payment History", () {
//                 nav.openInner(
//                   page: ProjectPage(item: item,),
//                   title: "Order History",
//                 );
//               }),
//               _drawerItem(context, Icons.engineering_outlined, "Surveyor", () {
//                 nav.openInner(
//                   page: ProjectPage(item: item,),
//                   title: "Order History",
//                 );
//               }),
//               _drawerItem(context, Icons.person_outline_rounded, "Profile Page", () {
//                 nav.openInner(
//                   page: ProjectPage(item: item,),
//                   title: "Order History",
//                 );
//               }),
//               _drawerItem(context, Icons.lock_outline_rounded, "Forgot Password", () {
//                 nav.openInner(
//                   page: ProjectPage(item: item,),
//                   title: "Order History",
//                 );
//               }),
//               _drawerItem(context, Icons.delete_outline, "Delete Profile", () {
//                 nav.openInner(
//                   page: ProjectPage(item: item,),
//                   title: "Order History",
//                 );
//               }),
//               _drawerItem(context, Icons.email_outlined, "Support", () {
//                 nav.openInner(
//                   page: ProjectPage(item: item,),
//                   title: "Order History",
//                 );
//               }),
//               _drawerItem(context, Icons.privacy_tip_outlined, "Privacy Policy", () {
//                 nav.openInner(
//                   page: ProjectPage(item: item,),
//                   title: "Order History",
//                 );
//               }),
//               _drawerItem(context,
//                 Icons.logout,
//                 "Logout",
//                     () {
//
//                 },
//                 isLogout: true,
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _drawerItem(
//       BuildContext context,
//       IconData icon,
//       String title,
//       VoidCallback onTap, {
//         bool isLogout = false,
//       }) {
//     return Column(
//       children: [
//         ListTile(
//           leading: Icon(
//             icon,
//             color: isLogout ? Colors.red : Colors.black,
//           ),
//           title: Text(
//             title,
//             style: AppFonts.drawerFont(
//               color: isLogout ? Colors.red : Colors.black,
//             ),
//           ),
//           onTap: () {
//             Navigator.pop(context);
//             onTap();
//           },
//         ),
//         const Divider(
//           height: 1,
//           thickness: 0.8,
//           color: AppColors.textSecondary1,
//         ),
//       ],
//     );
//   }
//
//
//
// }
