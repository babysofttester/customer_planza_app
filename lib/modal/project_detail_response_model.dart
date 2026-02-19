class ProjectDetailResponseModel {
  String? status;
  String? error;
  String? message;
  Data? data;

  ProjectDetailResponseModel(
      {this.status, this.error, this.message, this.data});

  ProjectDetailResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? projectId;
  String? projectNumber;
  Designer? designer;
  List<Services>? services;
  Surveyor? surveyor;

  Result(
      {this.projectId,
      this.projectNumber,
      this.designer,
      this.services,
      this.surveyor});

  Result.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    projectNumber = json['project_number'];
    designer = json['designer'] != null
        ? new Designer.fromJson(json['designer'])
        : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(new Services.fromJson(v));
      });
    }
    surveyor = json['surveyor'] != null
        ? new Surveyor.fromJson(json['surveyor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['project_number'] = this.projectNumber;
    if (this.designer != null) {
      data['designer'] = this.designer!.toJson();
    }
    if (this.services != null) {
      data['services'] = this.services!.map((v) => v.toJson()).toList();
    }
    if (this.surveyor != null) {
      data['surveyor'] = this.surveyor!.toJson();
    }
    return data;
  }
}

class Designer {
  String? id;
  String? bookingNo;
  String? name;
  String? avatar;

  Designer({this.id, this.bookingNo, this.name, this.avatar});

  Designer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingNo = json['booking_no'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_no'] = this.bookingNo;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Services {
  int? serviceId;
  String? serviceName;
  String? status;
  List<dynamic>? submissions;

  Services({this.serviceId, this.serviceName, this.status, this.submissions});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    status = json['status'];
    submissions = json['submissions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['status'] = status;
    data['submissions'] = submissions;
    return data;
  }
}

class Surveyor {
  String? id;
  String? bookingNo;
  String? name;
  WorkDetail? workDetail;
  List<dynamic>? files;
  ProjectData? projectData;

  Surveyor({
    this.id,
    this.bookingNo,
    this.name,
    this.workDetail,
    this.files,
    this.projectData,
  });

  Surveyor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingNo = json['booking_no'];
    name = json['name'];

    workDetail = json['work_detail'] != null
        ? WorkDetail.fromJson(json['work_detail'])
        : null;

    files = json['files'];   // ✅ simple direct assign

    projectData = json['projectData'] != null
        ? ProjectData.fromJson(json['projectData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['booking_no'] = bookingNo;
    data['name'] = name;

    if (workDetail != null) {
      data['work_detail'] = workDetail!.toJson();
    }

    data['files'] = files;  // ✅ no map(), no toJson()

    if (projectData != null) {
      data['projectData'] = projectData!.toJson();
    }

    return data;
  }
}



class WorkDetail {
  double? length;
  double? breadth;
  String? description;

  WorkDetail({this.length, this.breadth, this.description});

  WorkDetail.fromJson(Map<String, dynamic> json) {
    length = _parseDouble(json['length']);
    breadth = _parseDouble(json['breath']); 
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'length': length,
      'breath': breadth,
      'description': description,
    };
  }


  double? _parseDouble(dynamic value) {
    if (value == null || value == '') return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString());
  }
}

class ProjectData {
  int? projectId;
  String? state;
  String? city;
  int? floor;
  double? length;
  double? breadth;
  String? projectLat;
  String? projectLng;
  List<ProjectImages>? projectImages;
  List<ProjectServices>? projectServices;

  ProjectData(
      {this.projectId,
      this.state,
      this.city,
      this.floor,
      this.length,
      this.breadth,
      this.projectLat,
      this.projectLng,
      this.projectImages,
      this.projectServices});

  ProjectData.fromJson(Map<String, dynamic> json) {
    projectId = json['projectId'];
    state = json['state'];
    city = json['city'];
    floor = json['floor'];
    length = json['length'];
    breadth = json['breadth'];
    projectLat = json['project_lat'];
    projectLng = json['project_lng'];
    if (json['project_images'] != null) {
      projectImages = <ProjectImages>[];
      json['project_images'].forEach((v) {
        projectImages!.add(new ProjectImages.fromJson(v));
      });
    }
    if (json['project_services'] != null) {
      projectServices = <ProjectServices>[];
      json['project_services'].forEach((v) {
        projectServices!.add(new ProjectServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectId'] = this.projectId;
    data['state'] = this.state;
    data['city'] = this.city;
    data['floor'] = this.floor;
    data['length'] = this.length;
    data['breadth'] = this.breadth;
    data['project_lat'] = this.projectLat;
    data['project_lng'] = this.projectLng;
    if (this.projectImages != null) {
      data['project_images'] =
          this.projectImages!.map((v) => v.toJson()).toList();
    }
    if (this.projectServices != null) {
      data['project_services'] =
          this.projectServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProjectImages {
  int? id;
  String? file;

  ProjectImages({this.id, this.file});

  ProjectImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['file'] = this.file;
    return data;
  }
}

class ProjectServices {
  int? id;

  ProjectServices({this.id});

  ProjectServices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
