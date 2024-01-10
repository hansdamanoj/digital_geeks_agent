class AllInvoices {
  int? status;
  String? message;
  List<Data>? data;

  AllInvoices({this.status, this.message, this.data});

  AllInvoices.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? jobId;
  String? callChargeFrequency;
  String? hourlyServiceCharge;
  String? hours;
  String? visitingFee;
  String? discount;
  String? gst;
  String? cardProcessingFee;
  String? totalAmount;
  String? status;
  Null? txnId;
  String? module;
  String? createdBy;
  Null? updatedBy;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.jobId,
        this.callChargeFrequency,
        this.hourlyServiceCharge,
        this.hours,
        this.visitingFee,
        this.discount,
        this.gst,
        this.cardProcessingFee,
        this.totalAmount,
        this.status,
        this.txnId,
        this.module,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    callChargeFrequency = json['call_charge_frequency'];
    hourlyServiceCharge = json['hourly_service_charge'];
    hours = json['hours'];
    visitingFee = json['visiting_fee'];
    discount = json['discount'];
    gst = json['gst'];
    cardProcessingFee = json['card_processing_fee'];
    totalAmount = json['total_amount'];
    status = json['status'];
    txnId = json['txn_id'];
    module = json['module'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['call_charge_frequency'] = this.callChargeFrequency;
    data['hourly_service_charge'] = this.hourlyServiceCharge;
    data['hours'] = this.hours;
    data['visiting_fee'] = this.visitingFee;
    data['discount'] = this.discount;
    data['gst'] = this.gst;
    data['card_processing_fee'] = this.cardProcessingFee;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    data['txn_id'] = this.txnId;
    data['module'] = this.module;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
