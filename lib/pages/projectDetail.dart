import 'dart:developer';

import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/projectDetailController.dart';
// import 'package:customer_app_planzaa/services/zego_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ProjectDetail extends StatefulWidget {
  final int projectId;

  const ProjectDetail({super.key, required this.projectId});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return const Color(0xFF53AC40);
    case 'in progress':
    case 'pending':
      return const Color(0xFF6F67C5);
    default:
      return Colors.grey;
  }
}

class _ProjectDetailState extends State<ProjectDetail>
    with TickerProviderStateMixin {
  final Set<int> _expandedIndexes = {};
  // final List<File> _uploadedFiles = [];
  // final List<String> _uploadedFileNames = [];

  late ProjectDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ProjectDetailController(this, widget.projectId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Project Detail"),
      body: Obx(() {
        final model = controller.projectDetailModel.value;

        if (model.data == null || model.data!.result == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final result = model.data!.result!;
        final services = result.services ?? [];
        final status = services.isNotEmpty ? services.first.status ?? "" : "";
        final statusColor = _statusColor(status);

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                /// PROJECT ID
                Row(
                  children: [
                    Utils.textView(
                      'Project ID ',
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.w500,
                    ),
                    Utils.textView(
                      result.projectId?.toString() ?? "",
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.w600,
                    ),
                  ],
                ),

                SizedBox(height: Get.height * 0.02),

                /// ================= DESIGNER CARD =================
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.textView(
                                result.designer?.name ?? "",
                                Get.width * 0.04,
                                CustomColors.black,
                                FontWeight.w500,
                              ),
                              Utils.textView(
                                "Booking No: ${result.designer?.bookingNo ?? ""}",
                                Get.width * 0.035,
                                CustomColors.black,
                                FontWeight.w400,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              ///  CHAT BUTTON
                              GestureDetector(
                                onTap: () => _startChat(),
                                child: const Icon(
                                  Icons.chat_outlined,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),

                              /// 📞 CALL BUTTON
                              GestureDetector(
                                onTap: () => _startCall(),
                                child: const Icon(
                                  Icons.phone_outlined,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),

                          /// CALL BUTTON
                          // GestureDetector(
                          //   onTap: () => _startCall(),
                          //   child: const Icon(
                          //     Icons.phone_outlined,
                          //     size: 20,
                          //   ),
                          // ),
                        ],
                      ),

                      Divider(height: Get.height * 0.03),

                      const Text("Services"),

                      const SizedBox(height: 10),

                      /// SERVICES LIST
                      ...services.asMap().entries.map((entry) {
                        final index = entry.key;
                        final service = entry.value;
                        final isCompleted =
                            service.status?.toLowerCase() == "completed";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _projectRow(
                            title: service.serviceName ?? "",
                            isCompleted: isCompleted,
                            isExpanded: _expandedIndexes.contains(index),
                            onArrowTap: () {
                              setState(() {
                                _expandedIndexes.contains(index)
                                    ? _expandedIndexes.remove(index)
                                    : _expandedIndexes.add(index);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// ================= SURVEYOR CARD =================
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(result.surveyor?.name ?? ""),
                              Text(
                                "Booking No: ${result.surveyor?.bookingNo ?? ""}",
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(height: Get.height * 0.03),
                      const Text("Plot Detail"),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text("Length : "),
                          Text(result.surveyor?.workDetail?.length ?? ""),
                          const SizedBox(width: 40),
                          const Text("Breadth : "),
                          Text(result.surveyor?.workDetail?.breath ?? ""),
                        ],
                      ),
                      Divider(height: Get.height * 0.03),
                      const Text("Description"),
                      const SizedBox(height: 6),
                      Text(result.surveyor?.workDetail?.description ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// ================= SERVICE ROW =================
  Widget _projectRow({
    required String title,
    required bool isCompleted,
    required bool isExpanded,
    required VoidCallback onArrowTap,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: Text(title)),
              Icon(
                isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                color: isCompleted ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onArrowTap,
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
              ),
            ],
          ),
        ),
        if (isExpanded)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text("Submissions coming soon..."),
          ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

/*   /// ================= START CHAT =================
  Future<void> _startChat() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUserID = prefs.getString("user_id");
    final currentUserName = prefs.getString("user_name");

    if (currentUserID == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    final result = controller.projectDetailModel.value.data?.result;

    final targetUserID =
        result?.designer?.id?.toString(); //   hardcoded 5
    final targetUserName = result?.designer?.name ?? "Designer";

    if (targetUserID == null || targetUserID.isEmpty) {
      Get.snackbar("Error", "Designer not found");
      return;
    }

    log("===== CHAT OPEN =====");
    log("Current User: $currentUserID");
    log("Target User: $targetUserID");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ZIMKitMessageListPage(
          conversationID: targetUserID,
          conversationType: ZIMConversationType.peer,

          ///  Custom AppBar with Call Button
          appBarBuilder: (context, defaultAppBar) {
            return AppBar(
              title: Text(targetUserName),
              actions: [
                IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    ///  Voice Call
                    ZegoUIKitPrebuiltCallInvitationService().send(
                      isVideoCall: false,
                      invitees: [
                        ZegoCallUser(
                          targetUserID,
                          targetUserName,
                        ),
                      ],
                    );
                  },
                ),
             ],
            );
          },
        ),
      ),
    );
  }
 */

  Future<void> _startChat() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUserID = prefs.getString("user_id");
    final currentUserName = prefs.getString("user_name");

    if (currentUserID == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    final result = controller.projectDetailModel.value.data?.result;

    final designerID = result?.designer?.id?.toString();
    final designerName = result?.designer?.name ?? "Designer";

    if (designerID == null || designerID.isEmpty) {
      Get.snackbar("Error", "Designer not found");
      return;
    }

    ///  Create unique room id
    final roomID = "${currentUserID}_$designerID";
    final roomName = "${currentUserName}_$designerName";
    log("===== GROUP CHAT OPEN =====");
    log("Room ID: $roomID");

    try {
      await ZIMKit().createGroup(
        roomName, // group name
        [designerID], // invite list (must be List<String>)
        id: roomID, //  custom group ID
      );
    } catch (e) {
      log("Group may already exist: $e");
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ZIMKitMessageListPage(
          conversationID: roomID,
          conversationType: ZIMConversationType.group,
          appBarBuilder: (context, defaultAppBar) {
            return AppBar(
              title: Text(designerName),
              actions: [
                IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () {
                    ZegoUIKitPrebuiltCallInvitationService().send(
                      isVideoCall: false,
                      invitees: [
                        ZegoCallUser(designerID, designerName),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// ================= START CALL =================
  Future<void> _startCall() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUserID = prefs.getString("user_id");
    final currentUserName = prefs.getString("user_name");

    if (currentUserID == null || currentUserName == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    final result = controller.projectDetailModel.value.data?.result;
    final targetUserID = result?.designer?.id?.toString();
    final targetUserName = result?.designer?.name ?? "Designer";

    if (targetUserID == null || targetUserID.isEmpty) {
      Get.snackbar("Error", "Designer not found");
      return;
    }

    log("===== CALL INVITATION =====");
    log("Caller: $currentUserID");
    log("Callee: $targetUserID");

    ZegoUIKitPrebuiltCallInvitationService().send(
      isVideoCall: false,
      invitees: [
        ZegoCallUser(
          targetUserID,
          targetUserName,
        ),
      ],
    );
  }
}




/* import 'dart:io';

import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/projectDetailController.dart';
import 'package:customer_app_planzaa/modal/projectmodal.dart';
import 'package:customer_app_planzaa/services/zego_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:customer_app_planzaa/services/zego_service.dart';

class ProjectDetail extends StatefulWidget {
  final int projectId;

  const ProjectDetail({super.key, required this.projectId});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

/// STATUS COLOR
Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'completed':
      return const Color(0xFF53AC40);
    case 'in progress':
    case 'pending':
      return const Color(0xFF6F67C5);
    default:
      return Colors.grey;
  }
}

class _ProjectDetailState extends State<ProjectDetail>
    with TickerProviderStateMixin {
  final Set<int> _expandedIndexes = {};

  final List<File> _uploadedFiles = [];
  final List<String> _uploadedFileNames = [];

  late ProjectDetailController projectsDetailController;

  @override
  void initState() {
    super.initState();
    projectsDetailController = Get.put(
      ProjectDetailController(this, widget.projectId),
    );
  }

  @override
  void dispose() {
    projectsDetailController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      for (final file in result.files) {
        if (file.path != null) {
          _showFileNameDialog(File(file.path!));
        }
      }
    }
  }

  void _showFileNameDialog(File file) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          insetPadding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                const Text(
                  "Enter File Name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                /// TEXT FIELD
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "File name",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

                const SizedBox(height: 20),

                /// ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F3C88),
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (controller.text.trim().isEmpty) return;

                        setState(() {
                          _uploadedFiles.add(file);
                          _uploadedFileNames.add(controller.text.trim());
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                        "Save",
                        // style: AppFonts.bookButton(),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (controller.text.trim().isEmpty) return;
                    //
                    //     setState(() {
                    //       _uploadedFiles.add(file);
                    //       _uploadedFileNames.add(controller.text.trim());
                    //     });
                    //
                    //     Navigator.pop(context);
                    //   },
                    //   child: const Text("Save"),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final services =
    //    projectsDetailController.projectDetailModel.value .item.subtitle.split(',').map((e) => e.trim()).toList() ?? [];

    // final statusColor = _statusColor(widget.item.status ?? '');

    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Project Detail"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                /// PROJECT ID
                Row(
                  children: [
                    Utils.textView(
                      'Project ID ',
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.w500,
                    ),
                    Utils.textView(
                      projectsDetailController
                          .projectDetailModel
                          .value
                          .data!
                          .result!
                          .projectId
                          .toString(),
                      // widget.item.title,
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.w600,
                    ),
                  ],
                ),

                SizedBox(height: Get.height * 0.02),

                /// ================= SERVICES CARD =================
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.textView(
                                'Adam Collins',
                                Get.width * 0.04,
                                CustomColors.black,
                                FontWeight.w500,
                              ),
                              // Text(
                              //   'Adam Collins',
                              //   // style: AppFonts.proMainHeading()
                              // ),
                              Utils.textView(
                                'Job ID: JP-43821',
                                Get.width * 0.04,
                                CustomColors.black,
                                FontWeight.w500,
                              ),
                              // Text(
                              //   'Job ID: JP-43821',
                              //   // style: AppFonts.payment1()
                              // ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Optional: open chat page
                                },
                                child: const Icon(
                                  Icons.chat_outlined,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () async {
                                  await _startCall();
                                },
                                child: const Icon(
                                  Icons.phone_outlined,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // AppSizes.paySize(),
                      Divider(height: Get.height * 0.01),

                      // AppSizes.paySize(),
                      Text(
                        'Services',
                        // style: AppFonts.proHeading()
                      ),
                      // AppSizes.paySize(),

                      /// SERVICES LIST
                      ...services.asMap().entries.map((entry) {
                        final index = entry.key;
                        final service = entry.value;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _projectRow(
                            title: service,
                            isCompleted: widget.item.status == 'Completed',
                            showDownload: widget.item.status == 'Completed',
                            isExpanded: _expandedIndexes.contains(index),
                            onArrowTap: () {
                              setState(() {
                                if (_expandedIndexes.contains(index)) {
                                  _expandedIndexes.remove(index);
                                } else {
                                  _expandedIndexes.add(index);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),

                /// ================= SURVEYOR CARD =================
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Adam Collins',
                                // style:
                                // AppFonts.proMainHeading()
                              ),
                              Text(
                                'Job ID: JP-43821',
                                // style: AppFonts.payment1()
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              widget.item.status ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // AppSizes.proSize(),
                      Divider(height: Get.height * 0.01),

                      // AppSizes.paySize(),
                      Text(
                        'Plot Detail',
                        // style: AppFonts.proHeading()
                      ),

                      // AppSizes.paySize(),
                      Row(
                        children: [
                          Text(
                            'Length : ',
                            // style: AppFonts.lbFont()
                          ),
                          const Text('50 feet'),
                          SizedBox(width: Get.width * 0.2),
                          Text(
                            'Breadth : ',
                            // style: AppFonts.lbFont()
                          ),
                          const Text('50 feet'),
                        ],
                      ),

                      // AppSizes.proSize(),
                      Divider(height: Get.height * 0.01),

                      // AppSizes.proSize(),
                      Text(
                        'Description',
                        // style: AppFonts.proHeading()
                      ),
                      // AppSizes.paySize(),
                      Text(
                        'Nunc imperdiet ante dui, in fermentum turpis condimentum eu.',
                        // style: AppFonts.payment1(),
                      ),

                      // AppSizes.proSize(),
                      Divider(height: Get.height * 0.01),

                      // AppSizes.proSize(),
                      Text(
                        'Attachment',
                        // style: AppFonts.proHeading()
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _attachmentItem(),
                          const SizedBox(width: 12),
                          _attachmentItem(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= SERVICE ROW =================
  Widget _projectRow({
    required String title,
    required bool isCompleted,
    required bool showDownload,
    required bool isExpanded,
    required VoidCallback onArrowTap,
  }) {
    return Column(
      children: [
        /// MAIN ROW
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  // style: AppFonts.payment()
                ),
              ),

              Icon(
                isCompleted
                    ? Icons.check_circle
                    : Icons.check_circle_outline_rounded,
                color: isCompleted ? Colors.green : Colors.orange,
                size: 20,
              ),

              if (showDownload) ...[
                const SizedBox(width: 10),
                const Icon(
                  Icons.cloud_download_outlined,
                  color: Color(0xFF1F3C88),
                  size: 20,
                ),
              ],

              const SizedBox(width: 10),

              GestureDetector(
                onTap: onArrowTap,
                child: Container(
                  height: 26,
                  width: 26,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B2B2B),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// 👇 EXPANDED CONTENT INSIDE ROW
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isExpanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _expandedServiceContent(),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  /// ================= EXPANDED CONTENT =================
  Widget _expandedServiceContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER ROW
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "File Name Here",
                  // style: AppFonts.payment(size: 15)
                ),
                Text(
                  "Jan 02, 2025",
                  // style: AppFonts.payment1().copyWith(fontSize: 12),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1F3C88),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Download",
                // style: AppFonts.button(height: 1.0),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 12),

        /// ================= UPLOAD BOX =================
        GestureDetector(
          onTap: _pickFile,
          child: DottedBorder(
            options: RectDottedBorderOptions(
              dashPattern: const [6, 4],
              color: Colors.grey,
              strokeWidth: 1,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              color: const Color(0xFFF7F6F3),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 36,
                    color: Color(0xFF1F3C88),
                  ),
                  SizedBox(height: 6),
                  Text("Upload File"),
                ],
              ),
            ),
          ),
        ),

        /// ================= UPLOADED FILE PREVIEW =================
        if (_uploadedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),

          Column(
            children: List.generate(_uploadedFiles.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_uploadedFileNames[index]),
                          const SizedBox(height: 4),
                          Text("Tap to view"),
                        ],
                      ),

                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              OpenFile.open(_uploadedFiles[index].path);
                            },
                            child: const Text("View"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _attachmentItem() {
    return Container(
      height: 80,
      width: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF78AAD6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('assets/images/bgImage.png', fit: BoxFit.cover),
      ),
    );
  }

  Future<void> _startCall() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUserID = prefs.getString("user_id");
    final currentUserName = prefs.getString("user_name");

    if (currentUserID == null || currentUserName == null) {
      Get.snackbar("Error", "User not logged in");
      return;
    }

    /// 🔹 This should come from your API
    /// For example:
    /// widget.item.designerId
    final String targetUserID = widget.item.designerId.toString();

    /// Generate unique call ID
    final String callID =
        "${currentUserID}_$targetUserID_${DateTime.now().millisecondsSinceEpoch}";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ZegoUIKitPrebuiltCall(
            appID: ZegoService.appID,
            appSign: ZegoService.appSign,
            userID: currentUserID,
            userName: currentUserName,
            callID: callID,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
              ..invitees = [ZegoUIKitUser(id: targetUserID, name: "Designer")],
          );
        },
      ),
    );
  }
}
 */