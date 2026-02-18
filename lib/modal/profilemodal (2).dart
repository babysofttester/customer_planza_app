// import 'dart:io';
// import 'package:dio/dio.dart';

// import '../../../core/api/api_constant.dart';
// import '../../../core/api/api_endpoint.dart';
// import '../../../core/storage/token_services.dart';

// class ProfileApi {
//   final Dio dio = Dio();

//   /// GET PROFILE
//   Future<Response> getProfile() async {
//     final token = await TokenService.getToken();

//     return await dio.get(
//       ApiConstants.getProfile,
//       options: Options(
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//       ),
//     );
//   }

//   /// UPDATE PROFILE
//   Future<Response> updateProfile({
//     required int id,
//     required String name,
//     required String email,
//     File? image,
//   }) async {
//     final token = await TokenService.getToken();

//     FormData formData = FormData.fromMap({
//       'id': id,
//       'name': name,
//       'email': email,
//       if (image != null)
//         'image': await MultipartFile.fromFile(
//           image.path,
//           filename: image.path.split('/').last,
//         ),
//     });

//     return await dio.post(
//       ApiEndpoints.updateProfile,
//       data: formData,
//       options: Options(
//         headers: {
//           "Authorization": "Bearer $token",
//           "Accept": "application/json",
//         },
//       ),
//     );
//   }
// }
