import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk_apps/model/laporan.model.dart';
import 'package:helpdesk_apps/model/pengajuan.model.dart';
import 'package:helpdesk_apps/pages/karyawan/add_new_report.dart';
import 'package:helpdesk_apps/pages/progres_report.dart';
import 'package:helpdesk_apps/repository/laporan.repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportListKaryawan extends StatefulWidget {
  const ReportListKaryawan({super.key});

  @override
  State<ReportListKaryawan> createState() => _ReportListKaryawanState();
}

class _ReportListKaryawanState extends State<ReportListKaryawan>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var _pid;
  var _role;
  var _username;
  late TabController _tabController;

  var dataPengajuan = {};

  Future<Null> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final pid = prefs.getString('pid');
    final role = prefs.getString('role');
    final username = prefs.getString('username');

    setState(() {
      _pid = pid;
      _role = role;
      _username = username;
    });

    var dataLap = await db
        .collection('laporan')
        .withConverter(
            fromFirestore: Laporan.fromFirestore,
            toFirestore: (Laporan laporan, options) => laporan.toFirestore())
        .where('pid', isEqualTo: _pid)
        .get()
        .then((res) {
      return res.docs;
    });

    if (dataLap.isNotEmpty) {
      for (var data in dataLap) {
        final Laporan lap = data.data();
        await db
            .collection("pengajuan")
            .where("status", isNull: true)
            .where('lid', isEqualTo: lap.lid)
            .count()
            .get()
            .then(
          (res) {
            setState(() {
              dataPengajuan[lap.lid] = res.count;
            });
          },
          onError: (e) {
            print("Error completing: $e");
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var query = db
        .collection('laporan')
        .withConverter(
            fromFirestore: Laporan.fromFirestore,
            toFirestore: (Laporan laporan, options) => laporan.toFirestore())
        .where('pid', isEqualTo: _pid);
    if (_role == 'Teknisi') {
      query = db.collection('laporan').withConverter(
          fromFirestore: Laporan.fromFirestore,
          toFirestore: (Laporan laporan, options) => laporan.toFirestore());
    }

    TabBar iniTabBar = TabBar(
      indicatorColor: Colors.white,
      controller: _tabController,
      tabs: const [
        Tab(text: 'All'),
        Tab(text: 'Open'),
        Tab(text: 'Progress'),
        Tab(text: 'Done'),
      ],
    );
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF3A6344),
            child: Text(
              'Welcome, $_username',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          PreferredSize(
            preferredSize: iniTabBar.preferredSize,
            child: Material(
              color: const Color(0xFF3A6344),
              child: Theme(
                //<-- SEE HERE
                data: ThemeData().copyWith(splashColor: Colors.redAccent),
                child: iniTabBar,
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                containerListReport(query),
                containerListReport(query.where('status', isEqualTo: 'Open')),
                containerListReport(query.where('status', isEqualTo: 'In Progress')),
                containerListReport(query.where('status', isEqualTo: 'Done')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _role == 'Karyawan'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/add_new_report');
              },
            )
          : null,
    );
  }

  Widget containerListReport(query) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot<Laporan>>(
        stream: query.orderBy('create_time', descending: false).snapshots(),
        builder: (context, snapshot) {
          final querySanps = snapshot.data;
          if (querySanps != null && querySanps.docs.isNotEmpty) {
            final listLaporan = querySanps.docs;
            return RefreshIndicator(
              onRefresh: _pullRefresh,
              child: ListView.builder(
                itemCount: listLaporan.length,
                itemBuilder: (context, index) {
                  final laporan = listLaporan[index].data();
                  return Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<String>(laporan.lid),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Hapus Laporan"),
                            content: const Text("Apakah anda yakin akan menghapus laporan ini?"),
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
                      LaporanRepo.hapusLaporan(lid: laporan.lid).then((res) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(res.msg)));
                      });
                    },
                    child: Card(
                      child: ListTile(
                        tileColor:
                            dataPengajuan[laporan.lid] != null && dataPengajuan[laporan.lid] > 0
                                ? Colors.yellow[200]
                                : Colors.white,
                        leading: Container(
                          height: double.infinity,
                          child: const Icon(
                            Icons.library_books_rounded,
                            color: Color(0xFF3A6344),
                          ),
                        ),
                        title: Text(laporan.title),
                        subtitle: Text(
                          laporan.deskripsi,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProgressReport(
                                laporan: laporan,
                              ),
                            ),
                          );
                        },
                        onLongPress: () {
                          if (_role == 'Karyawan') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNewReport(
                                  laporan: laporan,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: Text('Belum ada laporan'),
          );
        },
      ),
    );
  }

  Future<void> _pullRefresh() async {
    await getSharedPrefs();
    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }
}
