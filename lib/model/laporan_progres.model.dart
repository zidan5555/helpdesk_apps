// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanProgress {
  String lpid;
  String title;
  String deskripsi;
  DateTime createTime;
  String lid;
  String? estimasi;
  String? satuanEstimasi;

  LaporanProgress({
    required this.lpid,
    required this.title,
    required this.deskripsi,
    required this.createTime,
    required this.lid,
    this.estimasi,
    this.satuanEstimasi,
  });

  factory LaporanProgress.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final createTimeToStr = data?['create_time'].toDate().toString();
    return LaporanProgress(
      lpid: data?['lpid'],
      title: data?['title'],
      deskripsi: data?['deskripsi'],
      createTime: DateTime.parse(createTimeToStr!),
      lid: data?['lid'],
      estimasi: data?['estimasi'],
      satuanEstimasi: data?['satuan_estimasi'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (lpid != null) "lpid": lpid,
      if (title != null) "title": title,
      if (deskripsi != null) "deskripsi": deskripsi,
      if (createTime != null) "create_time": createTime,
      if (lid != null) "lid": lid,
      "estimasi": estimasi,
      "satuan_estimasi": satuanEstimasi,
    };
  }
}
