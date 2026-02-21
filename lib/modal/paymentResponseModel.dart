class PaymentResponseModel {
  String? status;
  String? error;
  String? message;
  Data? data;

  PaymentResponseModel({this.status, this.error, this.message, this.data});

  PaymentResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? orderNumber;
  String? bookingNo;

  Data({this.orderNumber, this.bookingNo});

  Data.fromJson(Map<String, dynamic> json) {
    orderNumber = json['order_number'];
    bookingNo = json['booking_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_number'] = this.orderNumber;
    data['booking_no'] = this.bookingNo;
    return data;
  }
}
