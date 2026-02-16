class SignInResponseModel {
  String? status;
  String? error;
  String? message;
  List<Null>? data;

  SignInResponseModel({this.status, this.error, this.message, this.data});

  SignInResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Null>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
  
    return data;
  }
}
