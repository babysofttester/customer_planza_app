import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/pages/homescreen.dart';
import 'package:customer_app_planzaa/pages/order_history.dart';
import 'package:customer_app_planzaa/pages/profileScreen.dart';
import 'package:customer_app_planzaa/pages/project.dart';
import 'package:customer_app_planzaa/pages/servicescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class Home extends StatefulWidget {
  
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  RxBool toUSEOBX = true.obs;

  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  // ignore: unused_field
  final _controller = NotchBottomBarController(index: 1);
  double fourthDepth = 50;
  late AnimationController _animationController;
  int maxCount = 5;

  late SharedPreferences prefs;

  // int pageIndex = 0;
  int? pageIndex;
  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(vsync: this);
  //   load();

  //     pageIndex = 0;

  // final pages = [
  //   HomeScreen(
  //     onTabChange: (index) {
  //       setState(() {
  //         pageIndex = index;

  //         if (index == 0) appTitle = "Home";
  //         if (index == 1) appTitle = "Services";
  //         if (index == 2) appTitle = "Projects";
  //         if (index == 3) appTitle = "Order History";
  //         if (index == 4) appTitle = "Profile";
  //       });
  //     },
  //   ),
  //   const ServiceScreen(),
  //   ProjectPage(),
  //   const OrderHistory(),
  //   const ProfileScreen(),
  // ];
  // }

  late List<Widget> pages;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);

    pageIndex = 0;

    pages = [
      HomeScreen(
        onTabChange: (index) {
          setState(() {
            pageIndex = index;

            if (index == 0) appTitle = "Home";
            if (index == 1) appTitle = "Services";
            if (index == 2) appTitle = "Projects";
            if (index == 3) appTitle = "Order History";
            if (index == 4) appTitle = "Profile";
          });
        },
      ),
      const ServiceScreen(), 
      ProjectPage(),
      const OrderHistory(),
   ProfileScreen(
  onTabChange: (index) {
    setState(() {  
      pageIndex = index;

      if (index == 0) appTitle = "Home";
      if (index == 1) appTitle = "Services";
      if (index == 2) appTitle = "Projects";
      if (index == 3) appTitle = "Order History";
      if (index == 4) appTitle = "Profile";
    });
  },
),
    ];

    load();
  }

  load() async {
    pageIndex = 0;

    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // final pages = [
  //   const HomeScreen(),
  //   const ServiceScreen(),
  //   ProjectPage(),
  //   const OrderHistory(),
  //   const ProfileScreen(),

  //   // const Goals(),
  //   // const Obstacles(),
  //   // const Actionss(),
  //   // const Level(),
  //   // const ShareScreen(),
  // ];

  String appTitle = "Planza";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: pageIndex == 0
          ? null
          : AppBar(
              toolbarHeight: MediaQuery.of(context).size.width < 600
                  ? Get.width * 0.15
                  : Get.width * 0.075,
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              // leading:

              //     Padding(
              //         padding: MediaQuery.of(context).size.width < 600
              //             ? EdgeInsets.all(Get.width * 0.02)
              //             : EdgeInsets.all(Get.width * 0.01),
              //         child: Text("")),
              title: Utils.textView(
                appTitle,
                MediaQuery.of(context).size.width < 600
                    ? Get.width * 0.05
                    : Get.width * 0.03,
                CustomColors.black,
                FontWeight.bold,
              ),
              centerTitle: true,
              actions: [
                // GestureDetector( 
                //   onTap: () async {
                    
                //     Get.to(() => const ProfileScreen());
                //   },
                //   child: Container(
                //     margin: EdgeInsets.only(right: Get.width * 0.03),
                //     // width: 55,
                //     //               height: 55,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       border:
                //           Border.all(color: CustomColors.textGrey, width: 2),
                //       // color: _emojis[i] == null
                //       //     ? Colors.transparent
                //       //     : CustomColors.black,
                //     ),
                //     // decoration: BoxDecoration(),
                //     child: const Icon(
                //       Icons.person_outline,
                //       color: CustomColors.textGrey,
                //     ) /* IconButton(
                //       icon: const Icon(
                //         Icons.person_outline,
                //         color: CustomColors.textGrey,
                //       ),
                //       onPressed: () async {
                //         Get.to(() => const Profile());
                //       },
                //     ), */
                //     ,
                //   ),
                // ),
              
              ],
            ),
      body: pages[pageIndex!],
      extendBody: true,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 75,
          decoration: const BoxDecoration(
            color: CustomColors.white,
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(20),
            //   topRight: Radius.circular(20),
            // ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 8,
            //   )
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 0;
                    appTitle = "Home";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pageIndex == 0 ? Icons.home : Icons.home_outlined,
                      color: pageIndex == 0
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: pageIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: pageIndex == 0
                            ? const Color(0xFF1E3A8A)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 1;
                    appTitle = "Services";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pageIndex == 1 ? Icons.settings : Icons.settings_outlined,
                      color: pageIndex == 1
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Services",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: pageIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: pageIndex == 1
                            ? const Color(0xFF1E3A8A)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 2;
                    appTitle = "Projects";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pageIndex == 2
                          ? Icons.file_copy
                          : Icons.file_copy_outlined,
                      color: pageIndex == 2
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Projects",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: pageIndex == 2
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: pageIndex == 2
                            ? const Color(0xFF1E3A8A)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 3;
                    appTitle = "Order History";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pageIndex == 3
                          ? Icons.receipt_long
                          : Icons.receipt_long_outlined,
                      color: pageIndex == 3
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Order History",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: pageIndex == 3
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: pageIndex == 3
                            ? const Color(0xFF1E3A8A)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pageIndex = 4;
                    appTitle = "Profile";
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      pageIndex == 4 ? Icons.person : Icons.person_outline,
                      color: pageIndex == 4
                          ? const Color(0xFF1E3A8A)
                          : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: pageIndex == 4
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: pageIndex == 4
                            ? const Color(0xFF1E3A8A)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // );
  }
}
