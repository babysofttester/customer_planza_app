class OrderHistoryResponseModel {
  String? status;
  String? error;
  String? message;
  Data? data;

  OrderHistoryResponseModel({this.status, this.error, this.message, this.data});

  OrderHistoryResponseModel.fromJson(Map<String, dynamic> json) {
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
  List<Result>? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  String? bookingNo;
  int? projectId;
  String? role;
  int? userId;
  String? userName;
  String? assignedAt;
  String? amount;
  String? projectStatus;
  int? isReview;

  Result(
      {this.bookingNo,
      this.projectId,
      this.role,
      this.userId,
      this.userName,
      this.assignedAt,
      this.amount,
      this.projectStatus,
      this.isReview});

  Result.fromJson(Map<String, dynamic> json) {
    bookingNo = json['booking_no'];
    projectId = json['project_id'];
    role = json['role'];
    userId = json['user_id'];
    userName = json['user_name'];
    assignedAt = json['assigned_at'];
    amount = json['amount'];
    projectStatus = json['project_status'];
    isReview = json['is_review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_no'] = this.bookingNo;
    data['project_id'] = this.projectId;
    data['role'] = this.role;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['assigned_at'] = this.assignedAt;
    data['amount'] = this.amount;
    data['project_status'] = this.projectStatus;
    data['is_review'] = this.isReview;
    return data;
  }
}
