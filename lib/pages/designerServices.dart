import 'package:customer_app_planzaa/custom_widgets/choosePackage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:video_player/video_player.dart';
import '../../../../modal/designerPorfolioModal.dart';
import '../../../../modal/designerReviewModal.dart';
import '../../../../modal/designnermodal.dart';
// import '../../../../utils/app_fonts.dart';
// import '../../../../widget/controller/bottomnavcontroller.dart';
// import '../../../../widget/screen/choosePackage.dart';
// import '../../../Drawer/screen/drawer.dart';
// import '../../../services/screen/servicescreen.dart';
import '../controller/designerDetailController.dart';

class DesignerServices extends StatefulWidget {
  final DesignerItem item;
  final int designerId;

  const DesignerServices({
    super.key,
    required this.item,
    required this.designerId,
  });

  @override
  State<DesignerServices> createState() => _DesignerServicesState();
}

class _DesignerServicesState extends State<DesignerServices> {
  DesignerPortfolio? selectedPortfolio;
  DesignerPortfolio? selectedPortfolioDetail;
  bool isLoadingPortfolio = false;


  int selectedIndex = 0;

  // void _updateAppBarTitle() {
  //   final controller = Get.find<BottomNavController>();

  //   if (selectedIndex == 0) {
  //     controller.innerTitle.value = "Desrigner Sevices";
  //   } else if (selectedIndex == 1) {
  //     controller.innerTitle.value = selectedPortfolio == null
  //         ? "Portfolio"
  //         : "Portfolio Detail";
  //   } else if (selectedIndex == 2) {
  //     controller.innerTitle.value = "Proposal Screen";
  //   }
  // }

  void _showVideoPopup(String videoUrl)
  {
    print("VIDEO URL: ${videoUrl}");

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(10),
        child: _VideoPlayerWidget(videoUrl: videoUrl),

      ),
    );
  }

  void _showImagePopup(String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    // _updateAppBarTitle();
    Get.put(DesignerDetailController()).fetchDesignerDetail(widget.designerId);


  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DesignerDetailController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.designer == null) {
          return const Scaffold(body: Center(child: Text("No Data Found")));
        }

        final item = controller.designer!;

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: _designerCard(item),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _tabBar(),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: [
                        _servicesTab(item),
                        _portfolioTab(item),
                        _reviewTab(item),
                      ],
                    ),
                  ),
                ],
              ),
              _bottomBookButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _servicesTab(DesignerItem item) {
    if (item.services.isEmpty) {
      return const Center(child: Text("No Services Available"));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemCount: item.services.length,
      itemBuilder: (context, index) {
        final service = item.services[index];

        return _serviceTile(
          title: service['service_name'] ?? '',
          price: "${item.currencySymbol}${service['price']}",
        );
      },
    );
  }

  Widget _portfolioTab(DesignerItem item) {
    final controller = Get.find<DesignerDetailController>();


    if (isLoadingPortfolio) {
      return const Center(child: CircularProgressIndicator());
    }


    if (selectedPortfolioDetail != null) {
      return _portfolioDetail(selectedPortfolioDetail!);
    }


    if (item.portfolios.isEmpty) {
      return const Center(child: Text("No Portfolio Found"));
    }


    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemCount: item.portfolios.length,
      itemBuilder: (context, index) {
        final portfolio = item.portfolios[index];

        return GestureDetector(
          onTap: () async {
            setState(() {
              isLoadingPortfolio = true;
            });

            final detail =
            await controller.getPortfolioDetails(portfolio['id']);

            setState(() {
              selectedPortfolioDetail = detail;
              isLoadingPortfolio = false;
            });

            // _updateAppBarTitle();
          },
          child: _portfolioTile(
            title: portfolio['title'] ?? '',
            year: portfolio['year'] ?? '',
            image: portfolio['first_image'] ?? '',
          ),
        );
      },
    );
  }


  Widget _portfolioDetail(DesignerPortfolio portfolio) {
    String baseUrl = "http://192.168.1.188/planzaa-live/";

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedPortfolioDetail = null;
                  });
                  // _updateAppBarTitle();
                },
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 6),
                    Text("Back"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(portfolio.title, 
                  // style: AppFonts.heading(size: 16)
                  ),
                  Text(
                    portfolio.year,
                    // style: AppFonts.prosubHead(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                portfolio.description.replaceAll("\\r\\n", "\n"),
                // style: AppFonts.prosubSubCont(),
              ),

              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: portfolio.media.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final media = portfolio.media[index];

                  // ✅ Create full URL ONCE here
                  String fullUrl = media.fileUrl.startsWith("http")
                      ? media.fileUrl
                      : baseUrl + media.fileUrl;

                  return GestureDetector(
                    onTap: () {
                      if (media.mediaType == "video") {
                        _showVideoPopup(fullUrl);
                      } else {
                        _showImagePopup(fullUrl);
                      }
                    },
                    child: media.mediaType == "video"
                        ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black12,
                      ),
                      child: const Center(
                        child: Icon(Icons.play_circle_fill, size: 40),
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fullUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          "assets/bgImage.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },


              ),
            ],
          ),
        ),

        // /// BOOK BUTTON
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   bottom: 0,
        //   child: Container(
        //     padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.15),
        //           blurRadius: 12,
        //           offset: const Offset(0, -4),
        //         ),
        //       ],
        //     ),
        //     child: SafeArea(
        //       top: false,
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: const Color(0xFF1F3C88),
        //           padding: const EdgeInsets.symmetric(vertical: 14),
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10),
        //           ),
        //         ),
        //         onPressed: () {},
        //         child: Text("Book", style: AppFonts.bookButton()),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _reviewTab(DesignerItem item) {
    if (item.reviews.isEmpty) {
      return const Center(child: Text("No Reviews Yet"));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
      itemCount: item.reviews.length,
      itemBuilder: (context, index) {
        final review = item.reviews[index];

        int rating = review['rating'] ?? 0;

        return _reviewTile(
          name: review['customer'] ?? '',
          comment: review['comment'] ?? '',
          rating: rating,
          date: review['date'] ?? '',
          image: review['avtar'] ?? '',
        );
      },
    );
  }

  Widget _designerCard(DesignerItem item) {
    int rating = item.rating;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, 
                // style: AppFonts.desHead()
                ),
                const SizedBox(height: 4),

                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.orangeAccent,
                    );
                  }),
                ),

                const SizedBox(height: 4),

                Text(
                  "${item.projectsDone} Projects",
                  // style: AppFonts.prosubHead(),
                ),

                Text(
                  "${item.currencySymbol}${item.amount}",
                  // style: AppFonts.prosubHead(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceTile({required String title, required String price}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(getServiceImage(title), height: 55, width: 55),
          const SizedBox(width: 12),

          Expanded(child: Text(title, 
          // style: AppFonts.heading(size: 16)
          )
          ),

          Text(
            '${price} /sq.ft',
            // price,
            // style: AppFonts.prosubHead(color: const Color(0xFF1F3C88)),
          ),
        ],
      ),
    );
  }

  Widget _portfolioTile({
    required String title,
    required String year,
    required String image,
  }) {
    String baseUrl = "http://192.168.1.188/planzaa-live/";

    // If API returns only image name, attach base url
    String fullImageUrl = image.isNotEmpty && image.startsWith("http")
        ? image
        : baseUrl + image;



    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: image.isEmpty
                ? Image.asset(
                    "assets/bgImage.png",
                    height: 80,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    fullImageUrl,
                    height: 80,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/bgImage.png",
                        height: 80,
                        width: 100,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, 
              // style: AppFonts.heading(size: 16)
              ),
              Text(
                year,
                // style: AppFonts.prosubHead(
                //   size: 12,
                //   color: const Color(0xFF1F3C88),
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reviewTile({
    required String name,
    required String comment,
    required int rating,
    required String date,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 22, backgroundImage: NetworkImage(image)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                    //  style: AppFonts.heading(size: 14)
                     ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 14,
                          color: Colors.orangeAccent,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, 
          // style: AppFonts.prosubHead(size: 13)
          ),
          const SizedBox(height: 8),
          Text(date, 
          // style: AppFonts.prosubHead(size: 12, color: Colors.grey)
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    final titles = ["Services", "Portfolio", "Review"];

    return Row(
      children: List.generate(titles.length, (index) {
        final bool isSelected = selectedIndex == index;

        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
                selectedPortfolio = null; // reset detail when switching tab
              });
              // _updateAppBarTitle();
            },
            child: Container(
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1F3C88) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                titles[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF1F3C88),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _tabItem(String title, int index) {
    bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
            selectedPortfolio = null;
          });
          // _updateAppBarTitle();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected
                    ? const Color(0xFF1F3C88)
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF1F3C88) : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBookButton() {
    final int designerId; // ✅ must be declared
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F3C88),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Get.to(() => ChoosePackage(designerId: widget.designerId));
            },
            child: Text("Book Now", 
            // style: AppFonts.bookButton()
            ),
          ),
        ),
      ),
    );
  }
}
class _VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const _VideoPlayerWidget({required this.videoUrl});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    }).catchError((error) {
      print("VIDEO ERROR: $error");
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : const CircularProgressIndicator(),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: IconButton(
            icon: Icon(
              _controller.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}
