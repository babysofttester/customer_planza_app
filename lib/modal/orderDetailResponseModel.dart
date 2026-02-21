class OrderDetailResponseModel {
  String? status;
  String? error;
  String? message;
  Data? data;

  OrderDetailResponseModel({this.status, this.error, this.message, this.data});

  OrderDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? bookingNo;
  int? projectId;
  String? projectNumber;
  String? projectStatus;
  String? plotSize;
  Designer? designer;
  List<Services>? services;
  Null? surveyor;

  Result(
      {this.bookingNo,
      this.projectId,
      this.projectNumber,
      this.projectStatus,
      this.plotSize,
      this.designer,
      this.services,
      this.surveyor});

  Result.fromJson(Map<String, dynamic> json) {
    bookingNo = json['booking_no'];
    projectId = json['project_id'];
    projectNumber = json['project_number'];
    projectStatus = json['project_status'];
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
    surveyor = json['surveyor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_no'] = this.bookingNo;
    data['project_id'] = this.projectId;
    data['project_number'] = this.projectNumber;
    data['project_status'] = this.projectStatus;
    data['plot_size'] = this.plotSize;
    if (this.designer != null) {
      data['designer'] = this.designer!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    data['surveyor'] = this.surveyor;
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
  String? status;

  Services({this.serviceId, this.serviceName, this.totalPrice, this.status});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    totalPrice = json['total_price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['total_price'] = this.totalPrice;
    data['status'] = this.status;
    return data;
  }
}
