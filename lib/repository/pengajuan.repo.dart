import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpdesk_apps/model/pengajuan.model.dart';
import 'package:helpdesk_apps/repository/service.callback.dart';

class PengajuanRepo {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<ServiceCallback> addPengajuan({
    required Pengajuan pengajuan,
  }) async {
    try {
      var serviceCallback =
          ServiceCallback(success: true, msg: 'Pengajuan berhasil dibuat');
      var addPengajuanRef = db
          .collection('pengajuan')
          .withConverter(
              fromFirestore: Pengajuan.fromFirestore,
              toFirestore: (Pengajuan pengajuan, options) =>
                  pengajuan.toFirestore())
          .doc();
      pengajuan.penid = addPengajuanRef.id;
      await addPengajuanRef.set(pengajuan).catchError((err) {
        print(err);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Pengajuan gagal dibuat');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Pengajuan gagal dikirim');
    }
  }

  static Future<ServiceCallback> updatePengajuan({
    required Pengajuan pengajuan,
  }) async {
    try {
      var serviceCallback =
          ServiceCallback(success: true, msg: 'Pengajuan berhasil di update');
      var uptPengajuanRef = db
          .collection('pengajuan')
          .withConverter(
              fromFirestore: Pengajuan.fromFirestore,
              toFirestore: (Pengajuan pengajuan, options) =>
                  pengajuan.toFirestore())
          .doc(pengajuan.penid);
      await uptPengajuanRef.set(pengajuan).catchError((err) {
        print(err);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Gagal update pengajuan');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Gagal update pengajuan');
    }
  }

  static Future<ServiceCallback> deletePengajuan({
    required String penid,
  }) async {
    try {
      var serviceCallback =
          ServiceCallback(success: true, msg: 'Pengajuan berjasil dihapus');
      await db.collection('pengajuan').doc(penid).delete().catchError((err) {
        print(err);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. Pengajuan gagal dihapus');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false, msg: 'Terjadi kesalahan. Pengajuan gagal dihapus');
    }
  }

  static Future<ServiceCallback> approveRejectPengajuan({
    required String penid,
    required String status,
  }) async {
    var statusText = 'Approve';
    if (status == 'Rejected') {
      statusText = 'Reject';
    }
    try {
      var serviceCallback = ServiceCallback(
          success: true, msg: 'Pengajuan berhasil di $statusText');
      await db
          .collection('pengajuan')
          .doc(penid)
          .update({"status": status}).catchError((err) {
        print(err);
        serviceCallback = ServiceCallback(
            success: false, msg: 'Server error. $statusText pengajuan gagal');
      });
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(
          success: false,
          msg: 'Terjadi kesalahan. $statusText pengajuan gagal');
    }
  }
}
