class ServiceFilesResponseModel {
  String? status;
  String? error;
  String? message;
  Data? data;

  ServiceFilesResponseModel({this.status, this.error, this.message, this.data});

  ServiceFilesResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? submissionId;
  String? title;

  Data({this.submissionId, this.title});

  Data.fromJson(Map<String, dynamic> json) {
    submissionId = json['submission_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submission_id'] = this.submissionId;
    data['title'] = this.title;
    return data;
  }
}
