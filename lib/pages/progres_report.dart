import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:helpdesk_apps/model/laporan.model.dart';
import 'package:helpdesk_apps/model/laporan_progres.model.dart';
import 'package:helpdesk_apps/model/pengajuan.model.dart';
import 'package:helpdesk_apps/model/person.model.dart';
import 'package:helpdesk_apps/pages/add_laporan_progress.dart';
import 'package:helpdesk_apps/pages/add_pengajuan.dart';
import 'package:helpdesk_apps/repository/laporan.repo.dart';
import 'package:helpdesk_apps/repository/laporan_progress.repo.dart';
import 'package:helpdesk_apps/repository/pengajuan.repo.dart';
import 'package:helpdesk_apps/repository/service.callback.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressReport extends StatefulWidget {
  const ProgressReport(
      {super.key, required this.laporan, this.laporanProgress});

  final Laporan laporan;
  final LaporanProgress? laporanProgress;

  @override
  State<ProgressReport> createState() => _ProgressReportState();
}

List<String> list = <String>[
  'Open',
  'In Progress',
  'Done',
];

class _ProgressReportState extends State<ProgressReport> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var _pid;
  var _role;

  String dropdownValue = list.first;

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final pid = prefs.getString('pid');
    final role = prefs.getString('role');

    setState(() {
      _pid = pid;
      _role = role;
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: const Color(0xFF3A6344),
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.note_add_rounded, color: Colors.white),
          backgroundColor: const Color.fromRGBO(89, 150, 104, 1),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPengajuan(lid: widget.laporan.lid),
              ),
            );
          },
          label: 'Minta Pengajuan',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: const Icon(Icons.create, color: Colors.white),
          backgroundColor: const Color.fromRGBO(89, 150, 104, 1),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddLaporanProgress(
                  lid: widget.laporan.lid,
                ),
              ),
            );
          },
          label: 'Tambah Progress',
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var catatan = widget.laporan.catatan;
    if (catatan == null || catatan.isEmpty) {
      catatan = '-';
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF1EDEF),
      appBar: AppBar(
        title: const Text("Detail Laporan"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 4),
            _tabSection(context),
          ],
        ),
      ),
      floatingActionButton: _role == 'Teknisi' ? buildSpeedDial() : null,
    );
  }

  Widget _tabSection(BuildContext context) {
    Color statusColor = const Color(0xff4fc3f7);
    Color btnStatusColor = const Color(0xffffb74d);
    dropdownValue = widget.laporan.status;
    switch (widget.laporan.status) {
      case 'Done':
        statusColor = const Color(0xff81c784);
        break;
      case 'In Progress':
        statusColor = const Color(0xffffb74d);
        btnStatusColor = const Color(0xff81c784);
        break;
    }
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: const Color(0xFF3A6344),
            child: const TabBar(
              labelColor: Colors.white,
              indicatorColor: Color(0xFFF1EDEF),
              tabs: [
                Tab(text: "Detail"),
                Tab(text: "Progress"),
                Tab(text: "Pengajuan"),
              ],
            ),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height - 130,
            // height: MediaQuery.of(context).size.height,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView(
                    children: [
                      // Container(
                      //   color: statusColor,
                      //   padding: const EdgeInsets.all(8),
                      //   child: Text(
                      //     widget.laporan.status,
                      //     textAlign: TextAlign.center,
                      //     style: const TextStyle(
                      //         fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFF1EDEF)),
                      //   ),
                      // ),
                      // DropdownButton<String>(
                      //   value: dropdownValue,
                      //   isExpanded: true,
                      //   icon: const Icon(Icons.arrow_drop_down_rounded),
                      //   elevation: 16,
                      //   underline: Container(
                      //     height: 2,
                      //     color: const Color(0xFF3A6344),
                      //   ),
                      //   onChanged: (String? value) async {
                      //     if (value != null) {
                      //       ServiceCallback serviceCallback = await LaporanRepo.updateStatus(
                      //           status: value, lid: widget.laporan.lid);
                      //       ScaffoldMessenger.of(context)
                      //         ..removeCurrentSnackBar()
                      //         ..showSnackBar(SnackBar(content: Text(serviceCallback.msg)));
                      //     }
                      //     setState(() {
                      //       widget.laporan.status = value!;
                      //     });
                      //   },
                      //   items: list.map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),
                      // const SizedBox(height: 16),
                      if (_role == 'Teknisi')
                        ElevatedButton(
                          onPressed: () async {
                            var newStatus =
                                widget.laporan.status == 'In Progress'
                                    ? 'Done'
                                    : 'In Progress';
                            await db
                                .collection("laporan")
                                .where('status',
                                    whereIn: ['In Progress', 'Open'])
                                .where('create_time',
                                    isLessThan: widget.laporan.createTime)
                                .count()
                                .get()
                                .then(
                                  (res) {
                                    var jum = res.count;
                                    if (jum > 0) {
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(const SnackBar(
                                            content: Text(
                                          "FAILED. Masih ada antrian yang lebih awal masuk yang belum selesai.",
                                        )));
                                    } else {
                                      LaporanRepo.updateStatus(
                                              status: newStatus,
                                              lid: widget.laporan.lid)
                                          .then((res) {
                                        setState(() {
                                          widget.laporan.status = newStatus;
                                        });
                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                              SnackBar(content: Text(res.msg)));
                                      });
                                    }
                                  },
                                  onError: (e) => print("Error completing: $e"),
                                );
                            // await LaporanRepo.updateStatus(
                            //         status: newStatus, lid: widget.laporan.lid)
                            //     .then((res) {
                            //   setState(() {
                            //     widget.laporan.status = newStatus;
                            //   });
                            //   ScaffoldMessenger.of(context)
                            //     ..removeCurrentSnackBar()
                            //     ..showSnackBar(SnackBar(content: Text(res.msg)));
                            // });
                          },
                          child: Text((widget.laporan.status == 'In Progress')
                              ? 'Done'
                              : (widget.laporan.status == 'Done')
                                  ? 'Reporgress'
                                  : 'Progress'),
                        ),
                      const SizedBox(height: 8),
                      if (widget.laporan.image != null)
                        ElevatedButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => Dialog(
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(widget.laporan.image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: const Text('Preview image')),
                      Container(
                        color: const Color(0xFF3A6344),
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          "Detail Laporan",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF1EDEF)),
                        ),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text(
                          "Status:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A6344),
                          ),
                        ),
                        subtitle: Container(
                          color: statusColor,
                          padding: const EdgeInsets.all(4),
                          margin: const EdgeInsets.only(top: 4),
                          child: Text(
                            widget.laporan.status,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text(
                          "Title:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A6344),
                          ),
                        ),
                        subtitle: Text(widget.laporan.title),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text(
                          "Jenis:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A6344),
                          ),
                        ),
                        subtitle: Text(widget.laporan.jenis),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text(
                          "Deskripsi:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A6344),
                          ),
                        ),
                        subtitle: Text(widget.laporan.deskripsi),
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        title: const Text(
                          "Catatan:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3A6344),
                          ),
                        ),
                        subtitle: Text(widget.laporan.catatan == null
                            ? '-'
                            : widget.laporan.catatan!),
                      ),

                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        color: const Color(0xFF3A6344),
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          "Detail Pengirim",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF1EDEF)),
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot<Person>>(
                        stream: db
                            .collection('person')
                            .withConverter(
                                fromFirestore: Person.fromFirestore,
                                toFirestore: (Person person, options) =>
                                    person.toFirestore())
                            .doc(widget.laporan.pid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          var personRef = snapshot.data;
                          if (personRef != null && personRef.data() != null) {
                            var person = personRef.data()!;
                            return Column(
                              children: [
                                ListTile(
                                  tileColor: Colors.white,
                                  title: const Text(
                                    "Nama Pengirim:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3A6344),
                                    ),
                                  ),
                                  subtitle: Text(person.nama),
                                ),
                                ListTile(
                                  tileColor: Colors.white,
                                  title: const Text(
                                    "Nama Pengirim:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3A6344),
                                    ),
                                  ),
                                  subtitle: Text(person.bagian!),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      )
                      // ListTile(
                      //   tileColor: Colors.white,
                      //   title: const Text(
                      //     "Nama Pengirim:",
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       color: Color(0xFF3A6344),
                      //     ),
                      //   ),
                      //   subtitle: Text(widget.laporan.pid),
                      // ),
                    ],
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot<LaporanProgress>>(
                    stream: db
                        .collection('laporan_progress')
                        .withConverter(
                            fromFirestore: LaporanProgress.fromFirestore,
                            toFirestore:
                                (LaporanProgress laporanProgress, options) =>
                                    laporanProgress.toFirestore())
                        .where('lid', isEqualTo: widget.laporan.lid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final querySanps = snapshot.data;

                      if (querySanps != null && querySanps.docs.isNotEmpty) {
                        final listLaporanProgress = querySanps.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: listLaporanProgress.length,
                          itemBuilder: (context, index) {
                            final laporanProgress =
                                listLaporanProgress[index].data();
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: const Icon(Icons.delete_forever),
                              ),
                              key: ValueKey<String>(laporanProgress.lpid),
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                if (_role == 'Karyawan') {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                        content: Text("Permission denied")));
                                  return false;
                                }
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Hapus Laporan"),
                                      content: const Text(
                                          "Apakah anda yakin akan menghapus laporan ini?"),
                                      actions: <Widget>[
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (DismissDirection direction) async {
                                LaporanProgressRepo.hapusLaporanProgress(
                                        lpid: laporanProgress.lpid)
                                    .then((res) {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                        SnackBar(content: Text(res.msg)));
                                });
                              },
                              child: ListTile(
                                tileColor: Colors.white,
                                title: Text(laporanProgress.title),
                                subtitle: Text(laporanProgress.deskripsi),
                                shape: const Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF3A6344),
                                    width: 1,
                                  ),
                                ),
                                onTap: () {
                                  if (_role == 'Teknisi') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AddLaporanProgress(
                                          lid: laporanProgress.lid,
                                          laporanProgress: laporanProgress,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                        child: Text('Belum ada progres'),
                      );
                    },
                  ),
                ),
                Container(
                  child: StreamBuilder<QuerySnapshot<Pengajuan>>(
                    stream: db
                        .collection('pengajuan')
                        .withConverter(
                            fromFirestore: Pengajuan.fromFirestore,
                            toFirestore: (Pengajuan pengajuan, options) =>
                                pengajuan.toFirestore())
                        .where('lid', isEqualTo: widget.laporan.lid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final querySanps = snapshot.data;

                      if (querySanps != null && querySanps.docs.isNotEmpty) {
                        final listPengajuan = querySanps.docs;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: listPengajuan.length,
                          itemBuilder: (context, index) {
                            final pengajuan = listPengajuan[index].data();
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: const Icon(Icons.delete_forever),
                              ),
                              key: ValueKey<String>(pengajuan.penid),
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                if (_role == 'Karyawan') {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(const SnackBar(
                                        content: Text("Permission denied")));
                                  return false;
                                }
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Hapus Laporan"),
                                      content: const Text(
                                          "Apakah anda yakin akan menghapus laporan ini?"),
                                      actions: <Widget>[
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('No'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (DismissDirection direction) async {
                                PengajuanRepo.deletePengajuan(
                                        penid: pengajuan.penid)
                                    .then((res) {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                        SnackBar(content: Text(res.msg)));
                                });
                              },
                              child: ListTile(
                                tileColor: pengajuan.status == 'Approved'
                                    ? Colors.green[200]
                                    : (pengajuan.status == 'Rejected')
                                        ? Colors.red[200]
                                        : Colors.white,
                                title: Text(pengajuan.title),
                                subtitle: Text(pengajuan.deskripsi),
                                shape: const Border(
                                  bottom: BorderSide(
                                    color: Color(0xFF3A6344),
                                    width: 1,
                                  ),
                                ),
                                onTap: () {
                                  if (_role == 'Teknisi') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AddPengajuan(
                                          lid: pengajuan.lid,
                                          pengajuan: pengajuan,
                                        ),
                                      ),
                                    );
                                  } else {
                                    showAlertDialog(BuildContext context) {
                                      // set up the buttons
                                      Widget cancelButton = TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context, 'Cancel');
                                        },
                                      );
                                      Widget rejectButton = TextButton(
                                        child: const Text(
                                          "Reject",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          await PengajuanRepo
                                                  .approveRejectPengajuan(
                                                      penid: pengajuan.penid,
                                                      status: 'Rejected')
                                              .then((res) {
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                  content: Text(res.msg)));
                                            Navigator.pop(context, 'Reject');
                                          });
                                        },
                                      );
                                      Widget approveButton = TextButton(
                                        child: const Text("Approve"),
                                        onPressed: () async {
                                          await PengajuanRepo
                                                  .approveRejectPengajuan(
                                                      penid: pengajuan.penid,
                                                      status: 'Approved')
                                              .then((res) {
                                            ScaffoldMessenger.of(context)
                                              ..removeCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                  content: Text(res.msg)));
                                            Navigator.pop(context, 'Approve');
                                          });
                                        },
                                      );
                                      // set up the AlertDialog
                                      AlertDialog alert = AlertDialog(
                                        title: const Text("AlertDialog"),
                                        content: const Text(
                                            "Apakah anda akan menyetujui pengajuan ini ?"),
                                        actions: [
                                          cancelButton,
                                          rejectButton,
                                          approveButton,
                                        ],
                                      );
                                      // show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    }

                                    showAlertDialog(context);
                                  }
                                },
                              ),
                            );
                          },
                        );
                      }

                      return const Center(
                        child: Text('Belum ada Pengajuan'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
