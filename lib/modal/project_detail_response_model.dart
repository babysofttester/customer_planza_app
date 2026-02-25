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
  String? projectId;
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
  String? serviceId;
  String? serviceName;
  String? status;
  String? amount;
  List<Submissions>? submissions;

  Services({this.serviceId, this.serviceName, this.status,this.amount,  this.submissions});

  Services.fromJson(Map<String, dynamic> json) {
    serviceId = json['service_id'];
    serviceName = json['service_name'];
    status = json['status'];
     amount = json['amount'];
    if (json['submissions'] != null) {
      submissions = <Submissions>[];
      json['submissions'].forEach((v) {
        submissions!.add(new Submissions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['status'] = this.status;
    if (this.submissions != null) {
      data['submissions'] = this.submissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Submissions {
  String? submissionId;
  String? userType;
  String? userId;
  String? title;
  String? description;
  List<String>? files;

  Submissions(
      {this.submissionId,
      this.userType,
      this.userId,
      this.title,
      this.description,
      this.files});

  Submissions.fromJson(Map<String, dynamic> json) {
    submissionId = json['submission_id'];
    userType = json['user_type'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    files = json['files'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['submission_id'] = this.submissionId;
    data['user_type'] = this.userType;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['files'] = this.files;
    return data;
  }
}

class Surveyor {
  String? id;
  String? bookingNo;
  String? name;
  WorkDetail? workDetail;
  List<String>? files;
  ProjectData? projectData;

  Surveyor(
      {this.id,
      this.bookingNo,
      this.name,
      this.workDetail,
      this.files,
      this.projectData});

  Surveyor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingNo = json['booking_no'];
    name = json['name'];
    workDetail = json['work_detail'] != null
        ? new WorkDetail.fromJson(json['work_detail'])
        : null;
    files = json['files'].cast<String>();
    projectData = json['projectData'] != null
        ? new ProjectData.fromJson(json['projectData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_no'] = this.bookingNo;
    data['name'] = this.name;
    if (this.workDetail != null) {
      data['work_detail'] = this.workDetail!.toJson();
    }
    data['files'] = this.files;
    if (this.projectData != null) {
      data['projectData'] = this.projectData!.toJson();
    }
    return data;
  }
}

class WorkDetail {
  String? length;
  String? breath;
  String? description;

  WorkDetail({this.length, this.breath, this.description});

  WorkDetail.fromJson(Map<String, dynamic> json) {
    length = json['length'];
    breath = json['breath'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['breath'] = this.breath;
    data['description'] = this.description;
    return data;
  }
}

class ProjectData {
  String? projectId;
  String? state;
  String? city;
  String? floor;
  String? length;
  String? breadth;
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
  String? id;
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
  String? id;

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
