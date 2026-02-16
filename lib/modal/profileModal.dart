class ProfileModel {
  final int? id;          // ✅ ADD THIS
  final String username;
  final String email;
  final String phone;
  final String name;
  final String? avatar;

  ProfileModel({
     this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.name,
    this.avatar,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
    );
  }
}
