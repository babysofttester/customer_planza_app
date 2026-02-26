import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/projectDetailController.dart';
import 'package:customer_app_planzaa/services/zego_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:permission_handler/permission_handler.dart';

class ProjectDetail extends StatefulWidget {
  final int projectId;

  const ProjectDetail({super.key, required this.projectId});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class ServiceFile {
  final File file;
  final String fileName;

  ServiceFile({
    required this.file,
    required this.fileName,
  });
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
    // controller.loadServiceFiles(widget.projectId, widget.serviceId);
  }

  Map<int, List<ServiceFile>> _serviceFiles = {};

  Future<void> _pickFile(int serviceId) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result == null) return;

    for (final picked in result.files) {
      if (picked.path == null) continue;

      final file = File(picked.path!);
      _showFileNameDialog(file, serviceId);
    }
  }

  void _showFileNameDialog(File file, int serviceId) {
    final nameController = TextEditingController();

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
                /// Title
                const Text(
                  "Enter File Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                /// TextField
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "File name",
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),

                const SizedBox(height: 20),

                /// Save Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F3C88),
                    ),
                    onPressed: () {
                      _uploadFilesToServer(serviceId);
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;

                      setState(() {
                        _serviceFiles.putIfAbsent(serviceId, () => []);
                        _serviceFiles[serviceId]!.add(
                          ServiceFile(
                            file: file,
                            fileName: name,
                          ),
                        );
                      });

                      Navigator.pop(context);
                    },
                    child: Utils.textView(
                      "Save",
                      Get.width * 0.04,
                      CustomColors.white,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _uploadFilesToServer(int serviceId) async {
    final files = _serviceFiles[serviceId];

    if (files == null || files.isEmpty) {
      Utils.showToast("Please select files first");
      return;
    }

    List<Map<String, String>> images = [];

    for (final item in files) {
      final bytes = await item.file.readAsBytes();
      final base64String = base64Encode(bytes);
      final extension = item.file.path.split('.').last;

      images.add({
        "file_name": item.fileName,
        "file_base64": "data:image/$extension;base64,$base64String",
      });
    }

    await controller.uploadServiceFiles(
      projectId: widget.projectId,
      serviceId: serviceId,
      title: "My Service Files",
      images: images,
    );

    // setState(() {
    //   _serviceFiles.remove(serviceId);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.white,
      appBar: const CustomAppBar(title: "Project Detail"),
      body: Obx(() {
        final model = controller.projectDetailModel.value;

        if (model.data == null || model.data!.result == null) {
          return const Center();
        }

        final result = model.data!.result!;
        final services = result.services ?? [];
        final status = services.isNotEmpty ? services.first.status ?? "" : "";
        final statusColor = _statusColor(status);
        //  final serviceFiles = _serviceFiles[serviceId] ?? [];

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

                      Utils.textView(
                        'Services',
                        Get.width * 0.04,
                        CustomColors.black,
                        FontWeight.w500,
                      ),

                      const SizedBox(height: 10),

                      /// SERVICES LIST
                      ///

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
                            showDownload: status == 'Completed',
                            serviceId:
                                int.tryParse(service.serviceId ?? '') ?? 0,
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
                              Utils.textView(
                                result.surveyor?.name ?? "",
                                Get.width * 0.04,
                                CustomColors.black,
                                FontWeight.w500,
                              ),
                              Utils.textView(
                                "Booking No: ${result.surveyor?.bookingNo ?? ""}",
                                Get.width * 0.035,
                                CustomColors.black,
                                FontWeight.w400,
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
                            child: Utils.textView(
                              status,
                              Get.width * 0.03,
                              statusColor,
                              FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      Divider(height: Get.height * 0.03),
                      Utils.textView(
                        "Plot Detail",
                        Get.width * 0.04,
                        CustomColors.black,
                        FontWeight.w500,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Utils.textView(
                            "Length : ",
                            Get.width * 0.038,
                            CustomColors.black,
                            FontWeight.w500,
                          ),
                          Utils.textView(
                            result.surveyor?.workDetail?.length ?? "",
                            Get.width * 0.038,
                            CustomColors.black,
                            FontWeight.normal,
                          ),
                          const SizedBox(width: 40),
                          Utils.textView(
                            "Breadth : ",
                            Get.width * 0.038,
                            CustomColors.black,
                            FontWeight.w500,
                          ),
                          Utils.textView(
                            result.surveyor?.workDetail?.breath ?? "",
                            Get.width * 0.038,
                            CustomColors.black,
                            FontWeight.normal,
                          ),
                        ],
                      ),
                      Divider(height: Get.height * 0.03),
                      Utils.textView(
                        "Description",
                        Get.width * 0.038,
                        CustomColors.black,
                        FontWeight.w500,
                      ),
                      const SizedBox(height: 6),
                      Utils.textView(
                        result.surveyor?.workDetail?.description ?? "",
                        Get.width * 0.038,
                        CustomColors.black,
                        FontWeight.normal,
                      ),
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

  Future<void> _startChat() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUserID = prefs.getString("user_id");
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

    log("===== PEER CHAT OPEN =====");
    log("Customer: $currentUserID");
    log("Designer: $designerID");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ZIMKitMessageListPage(
          conversationID: designerID,
          conversationType: ZIMConversationType.peer,
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

  Future<void> _startCall() async {
    // request microphone & camera permissions before calling
    await Permission.microphone.request();
    await Permission.camera.request();

    final prefs = await SharedPreferences.getInstance();

    final currentUserID = prefs.getString("user_id");
    final currentUserName = prefs.getString("user_name");

    if (currentUserID == null || currentUserName == null) {
      Utils.showToast("Error: User not logged in");
      return;
    }

    final result = controller.projectDetailModel.value.data?.result;
    final targetUserID = result?.designer?.id?.toString();
    final targetUserName = result?.designer?.name ?? "Designer";

    if (targetUserID == null || targetUserID.isEmpty) {
      Utils.showToast("Error: Designer not found");
      return;
    }

    log("===== CALL INVITATION =====");
    log("Caller: $currentUserID ($currentUserName)");
    log("Callee: $targetUserID ($targetUserName)");

    try {
      log("📞 Starting voice call...");

      /// Generate unique call ID
      final String callID =
          "${currentUserID}_${targetUserID}_${DateTime.now().millisecondsSinceEpoch}";

      log("📞 Sending call invitation with callID $callID");

      await ZegoUIKitPrebuiltCallInvitationService().send(
        isVideoCall: false,
        invitees: [
          ZegoCallUser(targetUserID, targetUserName),
        ],
        callID: callID,
      );
      log("✅ Invitation sent");

      /// Navigate to call screen with Zego UI
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
              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
              events: ZegoUIKitPrebuiltCallEvents(
                onCallEnd: (event, defaultAction) {
                  // ensure the call page closes when the session ends
                  defaultAction.call();
                  Get.back();
                },
              ),
            );
          },
        ),
      );

      log("✅ Call screen opened successfully");
    } catch (e) {
      log("❌ Call error: $e");

      String message = "Unable to place call.";

      if (e.toString().contains("107026") ||
          e.toString().contains("all called user not registered")) {
        message = "User is offline or not available for calls.";
      }

      Utils.showToast("Call Failed: $message");
    }
  }

  ///

  Widget _projectRow({
    required String title,
    required bool isCompleted,
    required bool showDownload,
    required bool isExpanded,
    required int serviceId,
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
                child: Utils.textView(
                  title,
                  Get.width * 0.04,
                  CustomColors.black,
                  FontWeight.normal,
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
                  child: _expandedServiceContent(serviceId),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _expandedServiceContent(int serviceId) {
    final files = _serviceFiles[serviceId] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 12),

        /// Upload Box
        GestureDetector(
          onTap: () => _pickFile(serviceId),
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
              child: Column(
                children: const [
                  Icon(Icons.add_circle_outline,
                      size: 36, color: Color(0xFF1F3C88)),
                  SizedBox(height: 6),
                  Text("Upload File"),
                ],
              ),
            ),
          ),
        ),

        /// Preview Files
        if (files.isNotEmpty) ...[
          const SizedBox(height: 16),
          Column(
            children: List.generate(files.length, (index) {
              final item = files[index];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.fileName,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_rounded),
                        onPressed: () => OpenFile.open(item.file.path),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ],
      ],
    );
  }
}
