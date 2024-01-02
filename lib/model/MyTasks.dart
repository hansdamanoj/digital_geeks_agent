class MyTasks {
  int? status;
  String? message;
  Data? data;

  MyTasks({this.status, this.message, this.data});

  MyTasks.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Countries>? countries;
  List<LeadSource>? leadSource;
  String? loggedInUserId;
  List<Sales>? sales;
  List<Null>? technicainData;
  List<Users>? users;
  String? loggedInUserIs;
  List<FollowUps>? followUps;
  List<AppointmentsFollowUps>? appointmentsFollowUps;
  List<PotentialsFollowUps>? potentialsFollowUps;
  List<CallStatus>? callStatus;

  Data(
      {this.countries,
        this.leadSource,
        this.loggedInUserId,
        this.sales,
        this.technicainData,
        this.users,
        this.loggedInUserIs,
        this.followUps,
        this.appointmentsFollowUps,
        this.potentialsFollowUps,
        this.callStatus});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = <Countries>[];
      json['countries'].forEach((v) {
        countries!.add(new Countries.fromJson(v));
      });
    }
    if (json['leadSource'] != null) {
      leadSource = <LeadSource>[];
      json['leadSource'].forEach((v) {
        leadSource!.add(new LeadSource.fromJson(v));
      });
    }
    loggedInUserId = json['loggedInUserId'];
    if (json['sales'] != null) {
      sales = <Sales>[];
      json['sales'].forEach((v) {
        sales!.add(new Sales.fromJson(v));
      });
    }
    // if (json['technicainData'] != null) {
    //   technicainData = <Null>[];
    //   json['technicainData'].forEach((v) {
    //     technicainData!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    loggedInUserIs = json['loggedInUserIs'];
    if (json['followUps'] != null) {
      followUps = <FollowUps>[];
      json['followUps'].forEach((v) {
        followUps!.add(new FollowUps.fromJson(v));
      });
    }
    if (json['appointmentsFollowUps'] != null) {
      appointmentsFollowUps = <AppointmentsFollowUps>[];
      json['appointmentsFollowUps'].forEach((v) {
        appointmentsFollowUps!.add(new AppointmentsFollowUps.fromJson(v));
      });
    }
    if (json['potentialsFollowUps'] != null) {
      potentialsFollowUps = <PotentialsFollowUps>[];
      json['potentialsFollowUps'].forEach((v) {
        potentialsFollowUps!.add(new PotentialsFollowUps.fromJson(v));
      });
    }
    if (json['callStatus'] != null) {
      callStatus = <CallStatus>[];
      json['callStatus'].forEach((v) {
        callStatus!.add(new CallStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countries != null) {
      data['countries'] = this.countries!.map((v) => v.toJson()).toList();
    }
    if (this.leadSource != null) {
      data['leadSource'] = this.leadSource!.map((v) => v.toJson()).toList();
    }
    data['loggedInUserId'] = this.loggedInUserId;
    if (this.sales != null) {
      data['sales'] = this.sales!.map((v) => v.toJson()).toList();
    }
    // if (this.technicainData != null) {
    //   data['technicainData'] =
    //       this.technicainData!.map((v) => v.toJson()).toList();
    // }
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['loggedInUserIs'] = this.loggedInUserIs;
    if (this.followUps != null) {
      data['followUps'] = this.followUps!.map((v) => v.toJson()).toList();
    }
    if (this.appointmentsFollowUps != null) {
      data['appointmentsFollowUps'] =
          this.appointmentsFollowUps!.map((v) => v.toJson()).toList();
    }
    if (this.potentialsFollowUps != null) {
      data['potentialsFollowUps'] =
          this.potentialsFollowUps!.map((v) => v.toJson()).toList();
    }
    if (this.callStatus != null) {
      data['callStatus'] = this.callStatus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Countries {
  int? id;
  String? iso;
  String? name;
  String? nicename;
  String? iso3;
  String? numcode;
  String? phonecode;

  Countries(
      {this.id,
        this.iso,
        this.name,
        this.nicename,
        this.iso3,
        this.numcode,
        this.phonecode});

  Countries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iso = json['iso'];
    name = json['name'];
    nicename = json['nicename'];
    iso3 = json['iso3'];
    numcode = json['numcode'];
    phonecode = json['phonecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iso'] = this.iso;
    data['name'] = this.name;
    data['nicename'] = this.nicename;
    data['iso3'] = this.iso3;
    data['numcode'] = this.numcode;
    data['phonecode'] = this.phonecode;
    return data;
  }
}

class LeadSource {
  int? id;
  String? title;
  String? status;
  Null? createdAt;
  Null? updatedAt;

  LeadSource(
      {this.id, this.title, this.status, this.createdAt, this.updatedAt});

  LeadSource.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Sales {
  int? id;
  String? country;
  Null? leadSource;
  String? businessName;
  String? clientFname;
  String? clientLname;
  String? mobile;
  String? altPhone;
  String? email;
  String? warrantyStatus;
  String? address1;
  String? address2;
  String? state;
  String? city;
  Null? landmark;
  String? pinCode;
  String? phone;
  String? website;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;

  Sales(
      {this.id,
        this.country,
        this.leadSource,
        this.businessName,
        this.clientFname,
        this.clientLname,
        this.mobile,
        this.altPhone,
        this.email,
        this.warrantyStatus,
        this.address1,
        this.address2,
        this.state,
        this.city,
        this.landmark,
        this.pinCode,
        this.phone,
        this.website,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt});

  Sales.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    leadSource = json['lead_source'];
    businessName = json['business_name'];
    clientFname = json['client_fname'];
    clientLname = json['client_lname'];
    mobile = json['mobile'];
    altPhone = json['alt_phone'];
    email = json['email'];
    warrantyStatus = json['warranty_status'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    state = json['state'];
    city = json['city'];
    landmark = json['landmark'];
    pinCode = json['pin_code'];
    phone = json['phone'];
    website = json['website'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country'] = this.country;
    data['lead_source'] = this.leadSource;
    data['business_name'] = this.businessName;
    data['client_fname'] = this.clientFname;
    data['client_lname'] = this.clientLname;
    data['mobile'] = this.mobile;
    data['alt_phone'] = this.altPhone;
    data['email'] = this.email;
    data['warranty_status'] = this.warrantyStatus;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['state'] = this.state;
    data['city'] = this.city;
    data['landmark'] = this.landmark;
    data['pin_code'] = this.pinCode;
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Users {
  int? id;
  String? salutation;
  String? name;
  String? phone;
  Null? mobile;
  String? email;
  String? privillage;
  String? photo;
  String? designation;
  String? country;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  Users(
      {this.id,
        this.salutation,
        this.name,
        this.phone,
        this.mobile,
        this.email,
        this.privillage,
        this.photo,
        this.designation,
        this.country,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salutation = json['salutation'];
    name = json['name'];
    phone = json['phone'];
    mobile = json['mobile'];
    email = json['email'];
    privillage = json['privillage'];
    photo = json['photo'];
    designation = json['designation'];
    country = json['country'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salutation'] = this.salutation;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['privillage'] = this.privillage;
    data['photo'] = this.photo;
    data['designation'] = this.designation;
    data['country'] = this.country;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class FollowUps {
  int? id;
  String? commentId;
  String? assignedTo;
  String? assignedBy;
  String? status;
  String? accepted;
  String? createdBy;
  String? createdAt;
  Null? updatedBy;
  String? updatedAt;
  String? commentsJobId;
  String? commentsSalesId;
  String? commentsComment;
  String? commentsCGroup;
  String? commentsStatus;
  String? commentsClosedBy;
  String? commentsCreatedBy;
  Null? commentsUpdatedBy;
  String? salesId;
  String? salesCountry;
  Null? salesLeadSource;
  Null? salesBusinessName;
  String? salesClientFname;
  String? salesClientLname;
  String? salesMobile;
  Null? salesAltPhone;
  String? salesEmail;
  String? salesWarrantyStatus;
  String? salesAddress1;
  Null? salesAddress2;
  String? salesState;
  String? salesCity;
  Null? salesLandmark;
  String? salesPinCode;
  Null? salesPhone;
  Null? salesWebsite;
  String? salesCreatedBy;
  Null? salesUpdatedBy;
  String? salesCreatedAt;
  String? salesUpdatedAt;

  FollowUps(
      {this.id,
        this.commentId,
        this.assignedTo,
        this.assignedBy,
        this.status,
        this.accepted,
        this.createdBy,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.commentsJobId,
        this.commentsSalesId,
        this.commentsComment,
        this.commentsCGroup,
        this.commentsStatus,
        this.commentsClosedBy,
        this.commentsCreatedBy,
        this.commentsUpdatedBy,
        this.salesId,
        this.salesCountry,
        this.salesLeadSource,
        this.salesBusinessName,
        this.salesClientFname,
        this.salesClientLname,
        this.salesMobile,
        this.salesAltPhone,
        this.salesEmail,
        this.salesWarrantyStatus,
        this.salesAddress1,
        this.salesAddress2,
        this.salesState,
        this.salesCity,
        this.salesLandmark,
        this.salesPinCode,
        this.salesPhone,
        this.salesWebsite,
        this.salesCreatedBy,
        this.salesUpdatedBy,
        this.salesCreatedAt,
        this.salesUpdatedAt});

  FollowUps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentId = json['comment_id'];
    assignedTo = json['assigned_to'];
    assignedBy = json['assigned_by'];
    status = json['status'];
    accepted = json['accepted'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    commentsJobId = json['comments_job_id'];
    commentsSalesId = json['comments_sales_id'];
    commentsComment = json['comments_comment'];
    commentsCGroup = json['comments_c_group'];
    commentsStatus = json['comments_status'];
    commentsClosedBy = json['comments_closed_by'];
    commentsCreatedBy = json['comments_created_by'];
    commentsUpdatedBy = json['comments_updated_by'];
    salesId = json['sales_id'];
    salesCountry = json['sales_country'];
    salesLeadSource = json['sales_lead_source'];
    salesBusinessName = json['sales_business_name'];
    salesClientFname = json['sales_client_fname'];
    salesClientLname = json['sales_client_lname'];
    salesMobile = json['sales_mobile'];
    salesAltPhone = json['sales_alt_phone'];
    salesEmail = json['sales_email'];
    salesWarrantyStatus = json['sales_warranty_status'];
    salesAddress1 = json['sales_address_1'];
    salesAddress2 = json['sales_address_2'];
    salesState = json['sales_state'];
    salesCity = json['sales_city'];
    salesLandmark = json['sales_landmark'];
    salesPinCode = json['sales_pin_code'];
    salesPhone = json['sales_phone'];
    salesWebsite = json['sales_website'];
    salesCreatedBy = json['sales_created_by'];
    salesUpdatedBy = json['sales_updated_by'];
    salesCreatedAt = json['sales_created_at'];
    salesUpdatedAt = json['sales_updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_id'] = this.commentId;
    data['assigned_to'] = this.assignedTo;
    data['assigned_by'] = this.assignedBy;
    data['status'] = this.status;
    data['accepted'] = this.accepted;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    data['comments_job_id'] = this.commentsJobId;
    data['comments_sales_id'] = this.commentsSalesId;
    data['comments_comment'] = this.commentsComment;
    data['comments_c_group'] = this.commentsCGroup;
    data['comments_status'] = this.commentsStatus;
    data['comments_closed_by'] = this.commentsClosedBy;
    data['comments_created_by'] = this.commentsCreatedBy;
    data['comments_updated_by'] = this.commentsUpdatedBy;
    data['sales_id'] = this.salesId;
    data['sales_country'] = this.salesCountry;
    data['sales_lead_source'] = this.salesLeadSource;
    data['sales_business_name'] = this.salesBusinessName;
    data['sales_client_fname'] = this.salesClientFname;
    data['sales_client_lname'] = this.salesClientLname;
    data['sales_mobile'] = this.salesMobile;
    data['sales_alt_phone'] = this.salesAltPhone;
    data['sales_email'] = this.salesEmail;
    data['sales_warranty_status'] = this.salesWarrantyStatus;
    data['sales_address_1'] = this.salesAddress1;
    data['sales_address_2'] = this.salesAddress2;
    data['sales_state'] = this.salesState;
    data['sales_city'] = this.salesCity;
    data['sales_landmark'] = this.salesLandmark;
    data['sales_pin_code'] = this.salesPinCode;
    data['sales_phone'] = this.salesPhone;
    data['sales_website'] = this.salesWebsite;
    data['sales_created_by'] = this.salesCreatedBy;
    data['sales_updated_by'] = this.salesUpdatedBy;
    data['sales_created_at'] = this.salesCreatedAt;
    data['sales_updated_at'] = this.salesUpdatedAt;
    return data;
  }
}

class AppointmentsFollowUps {
  String? followUpsId;
  String? followUpsCommentId;
  String? followUpsAssignedTo;
  String? followUpsAssignedBy;
  String? followUpsStatus;
  String? followUpsAccepted;
  String? followUpsCreatedBy;
  String? followUpsCreatedAt;
  Null? followUpsUpdatedBy;
  String? followUpsUpdatedAt;
  String? commentsJobId;
  String? commentsSalesId;
  String? commentsComment;
  String? commentsCGroup;
  String? commentsStatus;
  Null? commentsClosedBy;
  String? commentsCreatedBy;
  Null? commentsUpdatedBy;
  String? appointmentsId;
  String? appointmentsCreator;
  String? appointmentsCountry;
  Null? appointmentsLeadSource;
  Null? appointmentsBusinessName;
  String? appointmentsClientFname;
  String? appointmentsClientLname;
  String? appointmentsMobile;
  Null? appointmentsAltPhone;
  String? appointmentsEmail;
  String? appointmentsAddress1;
  String? appointmentsAddress2;
  String? appointmentsState;
  String? appointmentsCity;
  String? appointmentsPinCode;
  Null? appointmentsOnSiteTechnician;
  Null? appointmentsOnSiteTechnicianName;
  String? appointmentsAppointedTo;
  String? appointmentsAppointmentDate;
  String? appointmentsAppointmentTime;
  Null? appointmentsWebsite;
  Null? appointmentsComments;
  String? appointmentsCommentsByCustomer;
  String? appointmentsQuotedPrice;
  String? appointmentsStatus;
  Null? appointmentsLastUpdatedAt;
  Null? appointmentsLastUpdatedBy;
  String? appointmentsCreatedAt;
  String? appointmentsUpdatedAt;

  AppointmentsFollowUps(
      {this.followUpsId,
        this.followUpsCommentId,
        this.followUpsAssignedTo,
        this.followUpsAssignedBy,
        this.followUpsStatus,
        this.followUpsAccepted,
        this.followUpsCreatedBy,
        this.followUpsCreatedAt,
        this.followUpsUpdatedBy,
        this.followUpsUpdatedAt,
        this.commentsJobId,
        this.commentsSalesId,
        this.commentsComment,
        this.commentsCGroup,
        this.commentsStatus,
        this.commentsClosedBy,
        this.commentsCreatedBy,
        this.commentsUpdatedBy,
        this.appointmentsId,
        this.appointmentsCreator,
        this.appointmentsCountry,
        this.appointmentsLeadSource,
        this.appointmentsBusinessName,
        this.appointmentsClientFname,
        this.appointmentsClientLname,
        this.appointmentsMobile,
        this.appointmentsAltPhone,
        this.appointmentsEmail,
        this.appointmentsAddress1,
        this.appointmentsAddress2,
        this.appointmentsState,
        this.appointmentsCity,
        this.appointmentsPinCode,
        this.appointmentsOnSiteTechnician,
        this.appointmentsOnSiteTechnicianName,
        this.appointmentsAppointedTo,
        this.appointmentsAppointmentDate,
        this.appointmentsAppointmentTime,
        this.appointmentsWebsite,
        this.appointmentsComments,
        this.appointmentsCommentsByCustomer,
        this.appointmentsQuotedPrice,
        this.appointmentsStatus,
        this.appointmentsLastUpdatedAt,
        this.appointmentsLastUpdatedBy,
        this.appointmentsCreatedAt,
        this.appointmentsUpdatedAt});

  AppointmentsFollowUps.fromJson(Map<String, dynamic> json) {
    followUpsId = json['follow_ups_id'];
    followUpsCommentId = json['follow_ups_comment_id'];
    followUpsAssignedTo = json['follow_ups_assigned_to'];
    followUpsAssignedBy = json['follow_ups_assigned_by'];
    followUpsStatus = json['follow_ups_status'];
    followUpsAccepted = json['follow_ups_accepted'];
    followUpsCreatedBy = json['follow_ups_created_by'];
    followUpsCreatedAt = json['follow_ups_created_at'];
    followUpsUpdatedBy = json['follow_ups_updated_by'];
    followUpsUpdatedAt = json['follow_ups_updated_at'];
    commentsJobId = json['comments_job_id'];
    commentsSalesId = json['comments_sales_id'];
    commentsComment = json['comments_comment'];
    commentsCGroup = json['comments_c_group'];
    commentsStatus = json['comments_status'];
    commentsClosedBy = json['comments_closed_by'];
    commentsCreatedBy = json['comments_created_by'];
    commentsUpdatedBy = json['comments_updated_by'];
    appointmentsId = json['appointments_id'];
    appointmentsCreator = json['appointments_creator'];
    appointmentsCountry = json['appointments_country'];
    appointmentsLeadSource = json['appointments_lead_source'];
    appointmentsBusinessName = json['appointments_business_name'];
    appointmentsClientFname = json['appointments_client_fname'];
    appointmentsClientLname = json['appointments_client_lname'];
    appointmentsMobile = json['appointments_mobile'];
    appointmentsAltPhone = json['appointments_alt_phone'];
    appointmentsEmail = json['appointments_email'];
    appointmentsAddress1 = json['appointments_address_1'];
    appointmentsAddress2 = json['appointments_address_2'];
    appointmentsState = json['appointments_state'];
    appointmentsCity = json['appointments_city'];
    appointmentsPinCode = json['appointments_pin_code'];
    appointmentsOnSiteTechnician = json['appointments_on_site_technician'];
    appointmentsOnSiteTechnicianName =
    json['appointments_on_site_technician_name'];
    appointmentsAppointedTo = json['appointments_appointed_to'];
    appointmentsAppointmentDate = json['appointments_appointment_date'];
    appointmentsAppointmentTime = json['appointments_appointment_time'];
    appointmentsWebsite = json['appointments_website'];
    appointmentsComments = json['appointments_comments'];
    appointmentsCommentsByCustomer = json['appointments_comments_by_customer'];
    appointmentsQuotedPrice = json['appointments_quoted_price'];
    appointmentsStatus = json['appointments_status'];
    appointmentsLastUpdatedAt = json['appointments_last_updated_at'];
    appointmentsLastUpdatedBy = json['appointments_last_updated_by'];
    appointmentsCreatedAt = json['appointments_created_at'];
    appointmentsUpdatedAt = json['appointments_updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['follow_ups_id'] = this.followUpsId;
    data['follow_ups_comment_id'] = this.followUpsCommentId;
    data['follow_ups_assigned_to'] = this.followUpsAssignedTo;
    data['follow_ups_assigned_by'] = this.followUpsAssignedBy;
    data['follow_ups_status'] = this.followUpsStatus;
    data['follow_ups_accepted'] = this.followUpsAccepted;
    data['follow_ups_created_by'] = this.followUpsCreatedBy;
    data['follow_ups_created_at'] = this.followUpsCreatedAt;
    data['follow_ups_updated_by'] = this.followUpsUpdatedBy;
    data['follow_ups_updated_at'] = this.followUpsUpdatedAt;
    data['comments_job_id'] = this.commentsJobId;
    data['comments_sales_id'] = this.commentsSalesId;
    data['comments_comment'] = this.commentsComment;
    data['comments_c_group'] = this.commentsCGroup;
    data['comments_status'] = this.commentsStatus;
    data['comments_closed_by'] = this.commentsClosedBy;
    data['comments_created_by'] = this.commentsCreatedBy;
    data['comments_updated_by'] = this.commentsUpdatedBy;
    data['appointments_id'] = this.appointmentsId;
    data['appointments_creator'] = this.appointmentsCreator;
    data['appointments_country'] = this.appointmentsCountry;
    data['appointments_lead_source'] = this.appointmentsLeadSource;
    data['appointments_business_name'] = this.appointmentsBusinessName;
    data['appointments_client_fname'] = this.appointmentsClientFname;
    data['appointments_client_lname'] = this.appointmentsClientLname;
    data['appointments_mobile'] = this.appointmentsMobile;
    data['appointments_alt_phone'] = this.appointmentsAltPhone;
    data['appointments_email'] = this.appointmentsEmail;
    data['appointments_address_1'] = this.appointmentsAddress1;
    data['appointments_address_2'] = this.appointmentsAddress2;
    data['appointments_state'] = this.appointmentsState;
    data['appointments_city'] = this.appointmentsCity;
    data['appointments_pin_code'] = this.appointmentsPinCode;
    data['appointments_on_site_technician'] = this.appointmentsOnSiteTechnician;
    data['appointments_on_site_technician_name'] =
        this.appointmentsOnSiteTechnicianName;
    data['appointments_appointed_to'] = this.appointmentsAppointedTo;
    data['appointments_appointment_date'] = this.appointmentsAppointmentDate;
    data['appointments_appointment_time'] = this.appointmentsAppointmentTime;
    data['appointments_website'] = this.appointmentsWebsite;
    data['appointments_comments'] = this.appointmentsComments;
    data['appointments_comments_by_customer'] =
        this.appointmentsCommentsByCustomer;
    data['appointments_quoted_price'] = this.appointmentsQuotedPrice;
    data['appointments_status'] = this.appointmentsStatus;
    data['appointments_last_updated_at'] = this.appointmentsLastUpdatedAt;
    data['appointments_last_updated_by'] = this.appointmentsLastUpdatedBy;
    data['appointments_created_at'] = this.appointmentsCreatedAt;
    data['appointments_updated_at'] = this.appointmentsUpdatedAt;
    return data;
  }
}

class PotentialsFollowUps {
  int? id;
  String? potId;
  String? callType;
  String? callDate;
  String? callTime;
  String? callOutcome;
  String? followUpDate;
  String? followedUpBy;
  String? callNote;
  String? updatedBy;
  String? updatedAt;
  String? createdBy;
  String? createdAt;
  String? potentialsId;
  String? potentialsCreatedBy;
  String? potentialsCountry;
  Null? potentialsBusinessName;
  String? potentialsClientFname;
  String? potentialsClientLname;
  String? potentialsMobile;
  Null? potentialsAltPhone;
  String? potentialsEmail;
  String? potentialsAddress1;
  Null? potentialsAddress2;
  String? potentialsState;
  String? potentialsCity;
  Null? potentialsLandmark;
  String? potentialsPinCode;
  Null? potentialsWebsite;
  String? potentialsCallStatus;
  String? potentialsCreatedAt;
  String? potentialsUpdatedAt;

  PotentialsFollowUps(
      {this.id,
        this.potId,
        this.callType,
        this.callDate,
        this.callTime,
        this.callOutcome,
        this.followUpDate,
        this.followedUpBy,
        this.callNote,
        this.updatedBy,
        this.updatedAt,
        this.createdBy,
        this.createdAt,
        this.potentialsId,
        this.potentialsCreatedBy,
        this.potentialsCountry,
        this.potentialsBusinessName,
        this.potentialsClientFname,
        this.potentialsClientLname,
        this.potentialsMobile,
        this.potentialsAltPhone,
        this.potentialsEmail,
        this.potentialsAddress1,
        this.potentialsAddress2,
        this.potentialsState,
        this.potentialsCity,
        this.potentialsLandmark,
        this.potentialsPinCode,
        this.potentialsWebsite,
        this.potentialsCallStatus,
        this.potentialsCreatedAt,
        this.potentialsUpdatedAt});

  PotentialsFollowUps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    potId = json['pot_id'];
    callType = json['call_type'];
    callDate = json['call_date'];
    callTime = json['call_time'];
    callOutcome = json['call_outcome'];
    followUpDate = json['follow_up_date'];
    followedUpBy = json['followed_up_by'];
    callNote = json['call_note'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    potentialsId = json['potentials_id'];
    potentialsCreatedBy = json['potentials_created_by'];
    potentialsCountry = json['potentials_country'];
    potentialsBusinessName = json['potentials_business_name'];
    potentialsClientFname = json['potentials_client_fname'];
    potentialsClientLname = json['potentials_client_lname'];
    potentialsMobile = json['potentials_mobile'];
    potentialsAltPhone = json['potentials_alt_phone'];
    potentialsEmail = json['potentials_email'];
    potentialsAddress1 = json['potentials_address_1'];
    potentialsAddress2 = json['potentials_address_2'];
    potentialsState = json['potentials_state'];
    potentialsCity = json['potentials_city'];
    potentialsLandmark = json['potentials_landmark'];
    potentialsPinCode = json['potentials_pin_code'];
    potentialsWebsite = json['potentials_website'];
    potentialsCallStatus = json['potentials_call_status'];
    potentialsCreatedAt = json['potentials_created_at'];
    potentialsUpdatedAt = json['potentials_updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pot_id'] = this.potId;
    data['call_type'] = this.callType;
    data['call_date'] = this.callDate;
    data['call_time'] = this.callTime;
    data['call_outcome'] = this.callOutcome;
    data['follow_up_date'] = this.followUpDate;
    data['followed_up_by'] = this.followedUpBy;
    data['call_note'] = this.callNote;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['potentials_id'] = this.potentialsId;
    data['potentials_created_by'] = this.potentialsCreatedBy;
    data['potentials_country'] = this.potentialsCountry;
    data['potentials_business_name'] = this.potentialsBusinessName;
    data['potentials_client_fname'] = this.potentialsClientFname;
    data['potentials_client_lname'] = this.potentialsClientLname;
    data['potentials_mobile'] = this.potentialsMobile;
    data['potentials_alt_phone'] = this.potentialsAltPhone;
    data['potentials_email'] = this.potentialsEmail;
    data['potentials_address_1'] = this.potentialsAddress1;
    data['potentials_address_2'] = this.potentialsAddress2;
    data['potentials_state'] = this.potentialsState;
    data['potentials_city'] = this.potentialsCity;
    data['potentials_landmark'] = this.potentialsLandmark;
    data['potentials_pin_code'] = this.potentialsPinCode;
    data['potentials_website'] = this.potentialsWebsite;
    data['potentials_call_status'] = this.potentialsCallStatus;
    data['potentials_created_at'] = this.potentialsCreatedAt;
    data['potentials_updated_at'] = this.potentialsUpdatedAt;
    return data;
  }
}

class CallStatus {
  int? id;
  String? name;
  String? status;
  Null? createdAt;
  Null? updatedAt;

  CallStatus({this.id, this.name, this.status, this.createdAt, this.updatedAt});

  CallStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
