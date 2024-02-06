// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class Pengajuan {
  String penid;
  String title;
  String deskripsi;
  String lid;
  DateTime createTime;
  String? status;

  Pengajuan({
    required this.penid,
    required this.title,
    required this.deskripsi,
    required this.lid,
    required this.createTime,
    this.status,
  });

  factory Pengajuan.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final createTimeToStr = data?['create_time'].toDate().toString();
    return Pengajuan(
      penid: data?['penid'],
      title: data?['title'],
      deskripsi: data?['deskripsi'],
      lid: data?['lid'],
      createTime: DateTime.parse(createTimeToStr!),
      status: data?['status'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (penid != null) "penid": penid,
      if (title != null) "title": title,
      if (deskripsi != null) "deskripsi": deskripsi,
      if (lid != null) "lid": lid,
      if (createTime != null) "create_time": createTime,
      "status": status,
    };
  }
}
