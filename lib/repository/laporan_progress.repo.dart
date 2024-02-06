import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpdesk_apps/model/laporan_progres.model.dart';
import 'package:helpdesk_apps/repository/service.callback.dart';

class LaporanProgressRepo {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<ServiceCallback> addLaporanProgress({
    required LaporanProgress laporanProgress,
  }) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Progress berhasil ditambahkan');

      var addProgressRef = db
          .collection('laporan_progress')
          .withConverter(
              fromFirestore: LaporanProgress.fromFirestore,
              toFirestore: (LaporanProgress laporanProgres, options) =>
                  laporanProgres.toFirestore())
          .doc();
      laporanProgress.lpid = addProgressRef.id;
      await addProgressRef.set(laporanProgress).catchError((e) {
        print(e);
        serviceCallback =
            ServiceCallback(success: false, msg: 'Server Error. Gagal tambah progress');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Gagal tambah progress');
    }
  }

  static Future<ServiceCallback> updateLaporanProgress({
    required LaporanProgress laporanProgress,
  }) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Update progress berhasil');
      var uptLaporanProgressRef = db
          .collection('laporan_progress')
          .withConverter(
              fromFirestore: LaporanProgress.fromFirestore,
              toFirestore: (LaporanProgress laporanProgress, options) =>
                  laporanProgress.toFirestore())
          .doc(laporanProgress.lpid);
      await uptLaporanProgressRef.set(laporanProgress).catchError(
        (e) {
          print(e);
          serviceCallback =
              ServiceCallback(success: false, msg: 'Server error. Update progress gagal');
        },
      );
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Update Progress gagal');
    }
  }

  static Future<ServiceCallback> hapusLaporanProgress({
    required lpid,
  }) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Progress berhasil dihapus');
      db.collection('laporan_progress').doc(lpid).delete().catchError((e) {
        print(e);
        serviceCallback =
            ServiceCallback(success: false, msg: 'Server error. Progress gagal dihapus');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Progress gagal dihapus');
    }
  }
}
