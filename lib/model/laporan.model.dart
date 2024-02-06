// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class Laporan {
  String lid;
  String title;
  String jenis;
  String deskripsi;
  String? catatan;
  String pid;
  DateTime createTime;
  String status;
  String? image;

  Laporan({
    required this.lid,
    required this.title,
    required this.jenis,
    required this.deskripsi,
    required this.catatan,
    required this.pid,
    required this.createTime,
    required this.status,
    this.image,
  });

  factory Laporan.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final createTimeToStr = data?['create_time'].toDate().toString();
    return Laporan(
      lid: data?['lid'],
      title: data?['title'],
      jenis: data?['jenis'],
      deskripsi: data?['deskripsi'],
      catatan: data?['catatan'],
      pid: data?['pid'],
      createTime: DateTime.parse(createTimeToStr!),
      status: data?['status'],
      image: data?['image'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (lid != null) "lid": lid,
      if (title != null) "title": title,
      if (jenis != null) "jenis": jenis,
      if (deskripsi != null) "deskripsi": deskripsi,
      "catatan": catatan,
      if (pid != null) "pid": pid,
      if (createTime != null) "create_time": createTime,
      if (status != null) "status": status,
      "image": image,
    };
  }
}
