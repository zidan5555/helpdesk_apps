// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String pid;
  String nama;
  String username;
  String password;
  String? bagian;
  String role; // Teknisi/Karyawan

  Person({
    required this.pid,
    required this.nama,
    required this.username,
    required this.password,
    required this.bagian,
    required this.role,
  });

  factory Person.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Person(
      pid: data?['pid'],
      nama: data?['nama'],
      username: data?['username'],
      password: data?['password'],
      bagian: data?['bagian'],
      role: data?['role'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (pid != null) "pid": pid,
      if (nama != null) "nama": nama,
      if (username != null) "username": username,
      if (password != null) "password": password,
      "bagian": bagian,
      if (role != null) "role": role,
    };
  }
}
