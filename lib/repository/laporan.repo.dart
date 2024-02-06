import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helpdesk_apps/model/laporan.model.dart';
import 'package:helpdesk_apps/repository/service.callback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class LaporanRepo {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<ServiceCallback> addNewLaporan({
    required Laporan laporan,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pid = prefs.getString('pid');
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Laporan berhasil di kirim');

      if (pid == null) {
        return ServiceCallback(
            success: false,
            msg: 'Authentication error. Harap login terlebih dahulu',
            isNotLogin: true);
      }

      laporan.pid = pid;
      var addLaporanRef = db
          .collection('laporan')
          .withConverter(
              fromFirestore: Laporan.fromFirestore,
              toFirestore: (Laporan laporan, options) => laporan.toFirestore())
          .doc();
      laporan.lid = addLaporanRef.id;
      await addLaporanRef.set(laporan).catchError((e) {
        print(e);
        serviceCallback =
            ServiceCallback(success: false, msg: 'Server error. laporan gagal dikirim');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Laporan gagal dikirim');
    }
  }

  static Future<ServiceCallback> hapusLaporan({
    required lid,
  }) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Laporan berhasil dihapus');
      db.collection('laporan').doc(lid).delete().catchError((e) {
        print(e);
        serviceCallback =
            ServiceCallback(success: false, msg: 'Server error. Laporan gagal dihapus');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Laporan gagal dihapus');
    }
  }

  static Future<ServiceCallback> updateLaporan({required Laporan laporan}) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Laporan berhasil di update');
      var updateLaporanRef = db
          .collection('laporan')
          .withConverter(
              fromFirestore: Laporan.fromFirestore,
              toFirestore: (Laporan laporan, options) => laporan.toFirestore())
          .doc(laporan.lid);
      await updateLaporanRef.set(laporan).catchError((e) {
        print(e);
        serviceCallback =
            ServiceCallback(success: false, msg: 'Server error. Laporan gagal di udate');
      });

      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Gagal update laporan');
    }
  }

  static Future<ServiceCallback> updateStatus({
    required String status,
    required String lid,
  }) async {
    try {
      ServiceCallback serviceCallback =
          ServiceCallback(success: true, msg: 'Status berhasil di update');
      var newDataStatus = {'status': status};
      var updateStatusRef = db.collection('laporan').doc(lid);
      await updateStatusRef.set(newDataStatus, SetOptions(merge: true)).catchError((e) {
        print(e);
        serviceCallback =
            ServiceCallback(success: false, msg: 'Server error. Status gagal di update');
      });
      return serviceCallback;
    } catch (e) {
      print(e);
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Status gagal di update');
    }
  }

  static Future<ServiceCallback> uploadImage({
    required File? imageFile,
  }) async {
    try {
      ServiceCallback serviceCallback = ServiceCallback(success: true, msg: 'Berhasil upload file');

      String? imageUrl;
      if (imageFile != null) {
        final fileName = basename(imageFile.path);

        final ref = FirebaseStorage.instance.ref("images").child(fileName);
        await ref.putFile(imageFile);

        imageUrl = await ref.getDownloadURL();
        serviceCallback =
            ServiceCallback(success: true, msg: 'Berhasil upload file', data: imageUrl);
      } else {
        serviceCallback = ServiceCallback(success: true, msg: 'Berhasil upload file', data: null);
      }

      return serviceCallback;
    } catch (e) {
      // print(e);
      return ServiceCallback(success: false, msg: 'Terjadi kesalahan. Upload file gagal');
    }
  }
}
