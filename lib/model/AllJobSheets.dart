class AllJobSheets {
  int? status;
  String? message;
  List<Data>? data;

  AllJobSheets({this.status, this.message, this.data});

  AllJobSheets.fromJson(Map<String, dynamic> json) {
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
  String? commentId;
  String? notes;
  String? status;
  String? pictureUrl;
  String? videoUrl;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.jobId,
        this.commentId,
        this.notes,
        this.status,
        this.pictureUrl,
        this.videoUrl,
        this.createdBy,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    commentId = json['comment_id'];
    notes = json['notes'];
    status = json['status'];
    pictureUrl = json['picture_url'];
    videoUrl = json['video_url'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_id'] = this.jobId;
    data['comment_id'] = this.commentId;
    data['notes'] = this.notes;
    data['status'] = this.status;
    data['picture_url'] = this.pictureUrl;
    data['video_url'] = this.videoUrl;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
