import 'package:customer_app_planzaa/common/assets.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/servicecontroller.dart';
import 'package:customer_app_planzaa/custom_widgets/architectpopup.dart';
import 'package:customer_app_planzaa/pages/addproject.dart';
import 'package:customer_app_planzaa/pages/servicecard.dart';
import 'package:customer_app_planzaa/pages/servicescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../modal/servicemodal.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onTabChange;
  const HomeScreen({super.key, this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //final ServiceController serviceController = Get.put(ServiceController(ServiceController(this)));
  //final homeServices = services.where((service) => !service.fullHome).toList();

  // final BottomNavController navController =
  // Get.put(BottomNavController(), permanent: true);

  late final ServiceController serviceController;
  @override
  void initState() {
    super.initState();
    serviceController = Get.put(ServiceController(this));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height * 0.05),
                    // Logo
                    ClipRect(
                      child: Align(
                        alignment: Alignment.center,
                        heightFactor: 1,
                        child: Image.asset(
                          Assets.appLogoPNG,
                          // 'assets/logo.png',
                          height: Get.height * 0.07,
                        ),
                      ),
                    ),

                    //const SizedBox(height: 20),

                    // Welcome Row
                    SizedBox(height: Get.height * 0.019),
                    Row(
                      //  crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Text section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.textView(
                                "Welcome to Planzaa 👋",
                                Get.width * 0.04,
                                CustomColors.black,
                                FontWeight.normal,
                              ),

                              SizedBox(height: Get.height * 0.009),
                              Utils.textView(
                                'From site survey to final design — everything you need to plan your home, in one place.',
                                Get.width * 0.03,
                                CustomColors.textGrey,
                                FontWeight.normal,
                              ),

                              SizedBox(height: Get.height * 0.02),

                              // Start Button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1F3C88),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6, // ⬅ reduce vertical space
                                    horizontal: 12,
                                  ),
                                  minimumSize: const Size(0, 36),
                                  tapTargetSize: MaterialTapTargetSize
                                      .shrinkWrap, // ⬅ removes extra tap area
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: () {
                                  widget.onTabChange?.call(1); // Switch to Services tab
                                 // Get.to(()=>PageController[pageIndex =1]);
                                  // setState(() {
                                  //   pageIndex = 1; // Service tab index
                                  //   appTitle = "Services";
                                  // });
                                },

                                child: Utils.textView(
                                  "Start a New Home Project", 
                                  Get.width * 0.03,
                                  CustomColors.white,
                                  FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //const SizedBox(width: 10),

                        // Image section
                        Image.asset(
                          Assets.housePNG,
                          //'assets/house.png',
                          height: Get.height * 0.14, //112px
                          width: Get.width * 0.45, //163px

                          fit: BoxFit.contain,
                        ),

                        //SizedBox(height: Get.height * 0.02),
                      ],
                    ),

                    SizedBox(height: Get.height * 0.018),
                    Utils.textView(
                      'Comprehensive Service For Your New Home',
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.bold,
                    ),

                    SizedBox(height: Get.height * 0.01),
                    Obx(() {
                      final fullHomeService = serviceController.services
                          .where((s) => s.fullHome)
                          .toList();

                      if (fullHomeService.isEmpty) {
                        return const SizedBox();
                      }

                      final item = fullHomeService.first;

                      return FullHomeContainer(item: item);
                    }),

                    // Container(
                    //   margin: const EdgeInsets.all(5),
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 8,
                    //     vertical: 5,
                    //   ),

                    //   decoration: BoxDecoration(
                    //     gradient: const LinearGradient(
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.topRight,
                    //       colors: [
                    //         Color(0x40C9DFFA), // #C9DFFA40 (with opacity)
                    //         Colors.white,
                    //       ],
                    //     ),
                    //     borderRadius: BorderRadius.circular(5),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.black.withOpacity(0.1),
                    //         blurRadius: 20,
                    //         offset: const Offset(0, 2),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // Top Row
                    //       Row(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           // Left Content
                    //           Expanded(
                    //             child: Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 // Title badge
                    //                 Utils.textView(
                    //                   'Full Home Package',
                    //                   Get.width * 0.03,
                    //                   CustomColors.black,
                    //                   FontWeight.bold,
                    //                 ),

                    //                 SizedBox(height: Get.height * 0.005),
                    //                 Utils.textView(
                    //                   'All-in-One solution, from idea to execution.',
                    //                   Get.width * 0.025,
                    //                   CustomColors.black,
                    //                   FontWeight.normal,
                    //                 ),

                    //                 SizedBox(height: Get.height * 0.003),

                    //                 _featureItem('2D & 3D Design'),
                    //                 _featureItem('Interior Design'),
                    //                 _featureItem('Structural Design'),
                    //                 _featureItem('Electrical & Plumbing'),
                    //                 _featureItem('Site Surveyors'),
                    //               ],
                    //             ),
                    //           ),

                    //           //const SizedBox(width: 12),

                    //           // Right Image + Badge
                    //           SizedBox(
                    //             width: Get.width * 0.5,
                    //             height:
                    //                 Get.height *
                    //                 0.175, // IMPORTANT: bounded height
                    //             child: Stack(
                    //               clipBehavior: Clip.none,
                    //               children: [
                    //                 Positioned(
                    //                   top: 1,
                    //                   right: 0,
                    //                   child: Container(
                    //                     width: Get.width * 0.5,
                    //                     height: Get.height * 0.17,
                    //                     decoration: BoxDecoration(
                    //                       borderRadius: BorderRadius.circular(
                    //                         100,
                    //                       ),
                    //                       boxShadow: [
                    //                         BoxShadow(
                    //                           color: Colors.black.withOpacity(
                    //                             0.15,
                    //                           ),
                    //                           blurRadius: 12,
                    //                           offset: const Offset(0, 6),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     child: ClipOval(
                    //                       child: Image.asset(
                    //                         Assets.house2PNG,
                    //                         // 'assets/h3.png',
                    //                         fit: BoxFit.cover,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),

                    //                 Positioned(
                    //                   top: 10,
                    //                   left: 90,
                    //                   child: Container(
                    //                     padding: const EdgeInsets.symmetric(
                    //                       horizontal: 12,
                    //                       vertical: 6,
                    //                     ),
                    //                     decoration: BoxDecoration(
                    //                       color: const Color(0xFFE28B2D),
                    //                       borderRadius: BorderRadius.circular(
                    //                         20,
                    //                       ),
                    //                     ),
                    //                     child: Utils.textView(
                    //                       'MOST POPULAR',
                    //                       Get.width * 0.02,
                    //                       CustomColors.black,
                    //                       FontWeight.bold,
                    //                     ),

                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),

                    //       //SizedBox(height: Get.height *  0.01),

                    //       // CTA Button
                    //       //const SizedBox(height: 6),
                    //       Row(
                    //         children: [
                    //           ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               backgroundColor: const Color(0xFF1F3C88),
                    //               padding: const EdgeInsets.symmetric(
                    //                 vertical: 6, // ⬅ reduce vertical space
                    //                 horizontal: 12,
                    //               ),
                    //               minimumSize: const Size(0, 32),

                    //               tapTargetSize: MaterialTapTargetSize
                    //                   .shrinkWrap, // ⬅ removes extra tap area
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(6),
                    //               ),
                    //             ),
                    //             onPressed: () {
                    //               showDialog(
                    //                 context: context,
                    //                 barrierDismissible: true,
                    //                 builder: (_) => const ArchitectPopup(),
                    //               );
                    //             },
                    //             child: Utils.textView(
                    //               "Start Full Home Design",
                    //               Get.width * 0.03,
                    //               CustomColors.white,
                    //               FontWeight.bold,
                    //             ),

                    //           ),

                    //           SizedBox(width: Get.width * 0.01),
                    //           // Rating
                    //           Expanded(
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 const Icon(
                    //                   Icons.star,
                    //                   color: Colors.amber,
                    //                   size: 20,
                    //                 ),
                    //                 SizedBox(width: Get.width * 0.015),

                    //                 Utils.textView(
                    //                   "4.8 rated by 1,200+ homeowners",
                    //                   Get.width * 0.02,
                    //                   CustomColors.textGrey,
                    //                   FontWeight.normal,
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: Get.height * 0.005),
                    Obx(() {
                      final homeServices = serviceController.services
                          .where((service) => !service.fullHome)
                          .toList();

                      if (homeServices.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1.9,
                            ),
                        itemCount: homeServices.length,
                        itemBuilder: (context, index) {
                          return ServiceCard(
                            item: homeServices[index],
                            index: index,
                          );
                        },
                      );
                    }),

                    // SizedBox(height: Get.height * 0.02),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F3C88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    // showDialog(
                    //   context: context,
                    //   barrierDismissible: true,
                    //   builder: (_) => const ArchitectPopup(projectId: project.id),
                    // );
                  },
                  child: Utils.textView(
                    "Next",

                    Get.height * 0.02,
                    CustomColors.white,
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullHomeContainer extends StatelessWidget {
  final ServiceItem item;

  const FullHomeContainer({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [Color(0x40C9DFFA), Colors.white],
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Utils.textView(
                      item.title,
                      Get.width * 0.03,
                      CustomColors.black,
                      FontWeight.bold,
                    ),

                    SizedBox(height: Get.height * 0.005),

                    Utils.textView(
                      'All-in-One solution, from idea to execution.',
                      Get.width * 0.025,
                      CustomColors.black,
                      FontWeight.normal,
                    ),

                    SizedBox(height: Get.height * 0.003),

                    _featureItem('2D & 3D Design'),
                    _featureItem('Interior Design'),
                    _featureItem('Structural Design'),
                    _featureItem('Electrical & Plumbing'),
                    _featureItem('Site Surveyors'),
                  ],
                ),
              ),

              SizedBox(
                width: Get.width * 0.5,
                height: Get.height * 0.175,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 1,
                      right: 0,
                      child: Container(
                        width: Get.width * 0.5,
                        height: Get.height * 0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/h3.png',
                            // item.image, // dynamic image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    if (item.isPopular)
                      Positioned(
                        top: 10,
                        left: 90,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE28B2D),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Utils.textView(
                            'MOST POPULAR',
                            Get.width * 0.02,
                            CustomColors.black,
                            FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3C88),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  // showDialog(
                  //   context: context,
                  //   barrierDismissible: true,
                  //   builder: (_) => const ArchitectPopup(),
                  // );
                },
                child: Utils.textView(
                  "Start ${item.title}",
                  Get.width * 0.03,
                  CustomColors.white,
                  FontWeight.bold,
                ),
              ),

              SizedBox(width: Get.width * 0.01),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: Get.width * 0.015),
                    Utils.textView(
                      "4.8 rated by 1,200+ homeowners",
                      Get.width * 0.02,
                      CustomColors.textGrey,
                      FontWeight.normal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _featureItem(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          Assets.checkPNG,
          // 'assets/check.png',
          height: 14,
          width: 14,
        ),
        const SizedBox(width: 4),
        Utils.textViewStyle(
          text,
          Get.width * 0.025,
          CustomColors.black,
          FontWeight.normal,
        ),
      ],
    ),
  );
}
