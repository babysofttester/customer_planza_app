class PaymentHistoryResponseModel {
  String? status;
  String? error;
  String? message;
  Data? data;

  PaymentHistoryResponseModel(
      {this.status, this.error, this.message, this.data});

  PaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? paymentId;
  String? projectId;
  String? transactionId;
  String? paymentMethod;
  String? amount;
  String? status;
  String? paidDate;

  Result(
      {this.paymentId,
      this.projectId,
      this.transactionId,
      this.paymentMethod,
      this.amount,
      this.status,
      this.paidDate});

  Result.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    projectId = json['project_id'];
    transactionId = json['transaction_id'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    status = json['status'];
    paidDate = json['paid_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_id'] = this.paymentId;
    data['project_id'] = this.projectId;
    data['transaction_id'] = this.transactionId;
    data['payment_method'] = this.paymentMethod;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['paid_date'] = this.paidDate;
    return data;
  }
}
