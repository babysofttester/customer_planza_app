

import 'dart:io';

import 'package:customer_app_planzaa/common/appBar.dart';
import 'package:customer_app_planzaa/common/assets.dart';
import 'package:customer_app_planzaa/common/common_text_field.dart';
import 'package:customer_app_planzaa/common/custom_colors.dart';
import 'package:customer_app_planzaa/common/utils.dart';
import 'package:customer_app_planzaa/controller/profileController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';

// import '../../../utils/app_color.dart';
// import '../../../utils/app_fonts.dart';
// import '../../HomePage/screen/homescreen.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  late ProfileController controller;

  @override
  void initState() {
    super.initState();

    controller = Get.find<ProfileController>();
    final profile = controller.customer;


    nameController = TextEditingController(text: profile?.name ?? '');
    phoneController = TextEditingController(text: profile?.phone ?? '');
    emailController = TextEditingController(text: profile?.email ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }


  File? profileImageFile;
  final ImagePicker _picker = ImagePicker();


Future<void> pickImage(ImageSource source) async {
  final XFile? pickedFile =
      await _picker.pickImage(source: source, imageQuality: 70);

  if (pickedFile != null) {
    setState(() {
      profileImageFile = File(pickedFile.path);
    });

    controller.profileImageFile = profileImageFile;  // ✅ important
  }
}


  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              const Text(
                "Choose Profile Photo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  late TextEditingController  nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
   
    appBar: const CustomAppBar(
  title: "Edit Profile",
),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
  radius: 80,
  backgroundImage: profileImageFile != null
      ? FileImage(profileImageFile!)
      : controller.customer?.avatar != null &&
              controller.customer!.avatar!.isNotEmpty
          ? NetworkImage(controller.customer!.avatar!)
          : const AssetImage("assets/images/profile.png") as ImageProvider,
),

                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: showImagePickerOptions,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: CustomColors.darkblue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.05),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Utils.textView(
                      "Name",
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.normal,
                    ),
                  
                  SizedBox(height: Get.height * 0.01),
                  // CommonTextField(
                  //     () {},
                  //     svg: Assets.emailSVG,
                  //     controller: nameController,
                  //     keyboardActionType: TextInputAction.done,
                  //     inputTypeKeyboard: TextInputType.emailAddress,
                  //     lineFormatter:
                  //         FilteringTextInputFormatter.singleLineFormatter,
                  //     hintText: "Enter your name",
                  //     maxLength: 999,
                  //     obscureText: false,
                  //     obscure: false,
                  //     onChanged: () {},
                  //   ),
                  _textField(
                    icon: Icons.person,
                    hint: "Enter your name",
                    controller: nameController,
                    readOnly: false,
                  ),
                  SizedBox(height: Get.height * 0.03),
Utils.textView(
                      "Phone",
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.normal,
                    ),
                  
                  SizedBox(height: Get.height * 0.01),
                  const SizedBox(height: 2),
                  _textField(
                    icon: Icons.phone,
                    hint: "Enter phone number",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                  ),

                  SizedBox(height: Get.height * 0.03),
                  Utils.textView(
                      "Email",
                      Get.width * 0.04,
                      CustomColors.black,
                      FontWeight.normal,
                    ),
                 
                  SizedBox(height: Get.height * 0.01),
                  _textField(
                    icon: Icons.email,
                    hint: "Enter email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: false,
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.04),
              SizedBox(
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
                      final controller = Get.find<ProfileController>();

                      controller.updateProfile( 
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        image: profileImageFile,
                      );


                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                  },
                  child:   Utils.textView(
                                  "Save",

                                  Get.height * 0.02,
                                  CustomColors.white,
                                  FontWeight.bold,
                                ),
                  // Text(
                  //   "Save",
                  //   style: TextStyle(fontSize: 15, color: Colors.white),
                  // ),
                ),
              
              
              ),

            ],
          ),
        ),
      ),


    );
  }
  Widget _textField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          // hintStyle: AppFonts.arcPop1(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor:  Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,

          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1F3C88)),
          ),
        ),
        cursorColor: const Color(0xFF1F3C88),
      ),
    );
  }
}
