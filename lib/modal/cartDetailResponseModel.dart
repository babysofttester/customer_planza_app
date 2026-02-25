class CartDetailResponseModel {
  String? status;
  String? error;
  String? message;
  Data? data;

  CartDetailResponseModel({this.status, this.error, this.message, this.data});

  CartDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  Result? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? orderNo;
  int? projectId;
  String? jobType;
  String? plotSize;
  Designer? designer;
  List<Services>? services;
  String? surveyorTotal;
  String? subTotal;
  String? taxPercent;
  String? taxAmount;
  String? grandTotal;

  Result(
      {this.orderNo,
      this.projectId,
      this.jobType,
      this.plotSize,
      this.designer,
      this.services,
      this.surveyorTotal,
      this.subTotal,
      this.taxPercent,
      this.taxAmount,
      this.grandTotal});

  Result.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    projectId = json['project_id'];
    jobType = json['job_type'];
    plotSize = json['plot_size'];
    designer = json['designer'] != null
        ? new Designer.fromJson(json['designer'])
        : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    surveyorTotal = json['surveyor_total'];
    subTotal = json['sub_total'];
    taxPercent = json['tax_percent'];
    taxAmount = json['tax_amount'];
    grandTotal = json['grand_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.orderNo;
    data['project_id'] = this.projectId;
    data['job_type'] = this.jobType;
    data['plot_size'] = this.plotSize;
    if (this.designer != null) {
      data['designer'] = this.designer!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['surveyor_total'] = this.surveyorTotal;
    data['sub_total'] = this.subTotal;
    data['tax_percent'] = this.taxPercent;
    data['tax_amount'] = this.taxAmount;
    data['grand_total'] = this.grandTotal;
    return data;
  }
}

class Designer {
  int? id;
  String? name;
  String? avatar;

  Designer({this.id, this.name, this.avatar});

  Designer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Services {
  int? serviceId;
  String? serviceName;
  String? totalPrice;

  Services({this.serviceId, this.serviceName, this.totalPrice});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['total_price'] = this.totalPrice;
    return data;
  }
}
