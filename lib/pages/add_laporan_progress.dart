import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk_apps/model/laporan_progres.model.dart';
import 'package:helpdesk_apps/pages/progres_report.dart';
import 'package:helpdesk_apps/repository/laporan_progress.repo.dart';

class AddLaporanProgress extends StatefulWidget {
  const AddLaporanProgress({
    super.key,
    required this.lid,
    this.laporanProgress,
  });

  final String lid;
  final LaporanProgress? laporanProgress;

  @override
  State<AddLaporanProgress> createState() => _AddLaporanProgressState();
}

List<String> list = <String>[
  'Jam',
  'Hari',
];

class _AddLaporanProgressState extends State<AddLaporanProgress> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _estimasiController = TextEditingController();

  bool isUpdate = false;

  String satuanEstimasi = list.first;

  @override
  Widget build(BuildContext context) {
    LaporanProgress? _laporanProgress = widget.laporanProgress;
    if (_laporanProgress != null) {
      _titleController.text = _laporanProgress.title;
      _deskripsiController.text = _laporanProgress.deskripsi;
      isUpdate = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: isUpdate ? const Text('Update Progress') : const Text('Tambah Progress'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(label: Text('Title')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Title tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _estimasiController,
                        decoration: const InputDecoration(
                          label: Text('Estimasi Pengerjaan'),
                          // border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Title tidak boleh kosong";
                          }
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: satuanEstimasi,
                        isExpanded: true,
                        itemHeight: null,
                        elevation: 16,
                        onChanged: (String? value) async {},
                        items: list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                TextFormField(
                  controller: _deskripsiController,
                  decoration: const InputDecoration(
                      label: Text('Deksripsi'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Masukan deskripsi disini'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 5,
                  validator: (value) {
                    return value == null || value.isEmpty ? 'Deskripsi tidak boleh kosong' : null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      LaporanProgress laporanProgress = LaporanProgress(
                        lpid: '',
                        title: _titleController.text,
                        deskripsi: _deskripsiController.text,
                        createTime: DateTime.now(),
                        lid: widget.lid,
                        estimasi: _estimasiController.text,
                        satuanEstimasi: satuanEstimasi,
                      );
                      if (isUpdate == true) {
                        laporanProgress.lpid = _laporanProgress!.lpid;
                        LaporanProgressRepo.updateLaporanProgress(laporanProgress: laporanProgress)
                            .then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        LaporanProgressRepo.addLaporanProgress(laporanProgress: laporanProgress)
                            .then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      }
                    }
                  },
                  child: isUpdate ? const Text('Update') : const Text('Add'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
