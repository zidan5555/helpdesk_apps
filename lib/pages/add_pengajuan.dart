import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk_apps/model/pengajuan.model.dart';
import 'package:helpdesk_apps/pages/progres_report.dart';
import 'package:helpdesk_apps/repository/laporan_progress.repo.dart';
import 'package:helpdesk_apps/repository/pengajuan.repo.dart';

class AddPengajuan extends StatefulWidget {
  const AddPengajuan({
    super.key,
    required this.lid,
    this.pengajuan,
  });

  final String lid;
  final Pengajuan? pengajuan;

  @override
  State<AddPengajuan> createState() => _AddPengajuanState();
}

class _AddPengajuanState extends State<AddPengajuan> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _deskripsiController = TextEditingController();

  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    Pengajuan? _pengajuan = widget.pengajuan;
    if (_pengajuan != null) {
      _titleController.text = _pengajuan.title;
      _deskripsiController.text = _pengajuan.deskripsi;
      isUpdate = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: isUpdate ? const Text('Update Pengajuan') : const Text('Buat Pengajuan'),
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
                      Pengajuan pengajuan = Pengajuan(
                          penid: '',
                          title: _titleController.text,
                          deskripsi: _deskripsiController.text,
                          createTime: DateTime.now(),
                          lid: widget.lid);
                      if (isUpdate == true) {
                        pengajuan.penid = _pengajuan!.penid;
                        pengajuan.status = _pengajuan.status;
                        PengajuanRepo.updatePengajuan(pengajuan: pengajuan).then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        PengajuanRepo.addPengajuan(pengajuan: pengajuan).then((res) {
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
