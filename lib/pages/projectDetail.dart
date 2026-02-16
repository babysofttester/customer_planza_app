import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

import '../../../../modal/projectmodal.dart';
// import '../../../../utils/app_color.dart';
// import '../../../../utils/app_fonts.dart';
// import '../../../../utils/app_size.dart';
// import '../../../../widget/controller/bottomnavcontroller.dart';
// import '../../../Designer/Designer Services/screen/designerServices.dart';

class ProjectDetail extends StatefulWidget {
  final ProjectsItem? item;
  const ProjectDetail({super.key, this.item});

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

class _ProjectDetailState extends State<ProjectDetail> {

  /// 🔑 REQUIRED FOR EXPAND / COLLAPSE
  final Set<int> _expandedIndexes = {};

  final List<File> _uploadedFiles = [];
  final List<String> _uploadedFileNames = [];


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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
                      child:  Text(
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
    final services =
        widget.item?.subtitle.split(',').map((e) => e.trim()).toList() ?? [];

    final statusColor = _statusColor(widget.item?.status ?? '');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                /// PROJECT ID
                Row(
                  children: [
                    Text('Project ID ', 
                    // style: AppFonts.proHead2()
                    ),
                    Text(widget.item?.title ?? '',
                        // style: AppFonts.proHead()
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
                              Text('Adam Collins',
                                  // style: AppFonts.proMainHeading()
                                  ),
                              Text('Job ID: JP-43821',
                                  // style: AppFonts.payment1()
                                  ),
                            ],
                          ),
                          Row(
                            children: const [
                              Icon(Icons.chat_outlined,
                                  size: 18,
                                  //  color: AppColors.primary
                                   ),
                              SizedBox(width: 8),
                              Icon(Icons.phone_outlined,
                                  size: 18, 
                                  // color: AppColors.primary
                                  ),
                            ],
                          ),
                        ],
                      ),

                      // AppSizes.paySize(),
                      Divider(height: Get.height * 0.01),
                      // AppSizes.paySize(),

                      Text('Services', 
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
                            isCompleted: widget.item?.status == 'Completed',
                            showDownload: widget.item?.status == 'Completed',
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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('Adam Collins',
                                  // style:
                                  // AppFonts.proMainHeading()
                                  ),
                              Text('Job ID: JP-43821',
                                  // style: AppFonts.payment1()
                                  ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                              statusColor.withOpacity(0.12),
                              borderRadius:
                              BorderRadius.circular(5),
                            ),
                            child: Text(
                              widget.item?.status ?? '',
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

                      Text('Plot Detail',
                          // style: AppFonts.proHeading()
                          ),
                      // AppSizes.paySize(),

                      Row(
                        children: [
                          Text('Length : ',
                              // style: AppFonts.lbFont()
                              ),
                          const Text('50 feet'),
                          SizedBox(width: Get.width * 0.2),
                          Text('Breadth : ',
                              // style: AppFonts.lbFont()
                              ),
                          const Text('50 feet'),
                        ],
                      ),

                      // AppSizes.proSize(),
                      Divider(height: Get.height * 0.01),
                      // AppSizes.proSize(),

                      Text('Description',
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

                      Text('Attachment',
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
              Expanded(child: Text(title, 
              // style: AppFonts.payment()
              )),

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
                Text("File Name Here",
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
                padding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
                          Text(
                            _uploadedFileNames[index],
                            // style: AppFonts.payment(size: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Tap to view",
                            // style: AppFonts.payment1(size: 12),
                          ),
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

                          // IconButton(
                          //                           //   icon: const Icon(Icons.delete_outline, color: Colors.red),
                          //                           //   onPressed: () {
                          //                           //     setState(() {
                          //                           //       _uploadedFiles.removeAt(index);
                          //                           //       _uploadedFileNames.removeAt(index);
                          //                           //     });
                          //                           //   },
                          //                           // ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ]

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
        child: Image.asset('assets/bgImage.png',
            fit: BoxFit.cover),
      ),
    );
  }
}
