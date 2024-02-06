import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk_apps/model/laporan.model.dart';
import 'package:helpdesk_apps/repository/laporan.repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class AddNewReport extends StatefulWidget {
  const AddNewReport({super.key, this.laporan});

  final Laporan? laporan;

  @override
  State<AddNewReport> createState() => _AddNewReportState();
}

class _AddNewReportState extends State<AddNewReport> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _jenisController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _catatanController = TextEditingController();

  bool isUpdate = false;

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future imgFormGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isUpdate = widget.laporan != null;
    final laporan = widget.laporan;
    String? imageFromDB;
    if (laporan != null) {
      _titleController.text = laporan.title;
      _jenisController.text = laporan.jenis;
      _deskripsiController.text = laporan.deskripsi;
      _catatanController.text = laporan.catatan ?? '';

      imageFromDB = laporan.image;
    }

    return Scaffold(
      appBar: AppBar(
        title: (isUpdate) ? const Text('Update Report') : const Text('Add New Report'),
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
                  controller: _jenisController,
                  decoration: const InputDecoration(label: Text('Jenis')),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Jenis tidak boleh kosong";
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
                TextFormField(
                  controller: _catatanController,
                  decoration: const InputDecoration(
                      label: Text('Catatan'),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Masukan catatan disini'),
                  keyboardType: TextInputType.multiline,
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  minLines: 5,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Laporan newLaporan = Laporan(
                        lid: '',
                        title: _titleController.text,
                        jenis: _jenisController.text,
                        deskripsi: _deskripsiController.text,
                        catatan: _catatanController.text,
                        pid: '',
                        createTime: DateTime.now(),
                        status: 'Open',
                      );

                      if (_image != null) {
                        await LaporanRepo.uploadImage(imageFile: _image).then((res) {
                          if (res.data != null) {
                            newLaporan.image = res.data;
                          }
                        });
                      } else {
                        newLaporan.image = imageFromDB;
                      }

                      if (isUpdate) {
                        final prefs = await SharedPreferences.getInstance();
                        final pid = prefs.getString('pid');
                        newLaporan.lid = laporan!.lid;
                        newLaporan.pid = pid!;
                        await LaporanRepo.updateLaporan(laporan: newLaporan).then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.isNotLogin == true) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login_page', (route) => false);
                          }
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      } else {
                        if (_image == null) {
                          newLaporan.image = null;
                        }
                        await LaporanRepo.addNewLaporan(laporan: newLaporan).then((res) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text(res.msg)));
                          if (res.isNotLogin == true) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login_page', (route) => false);
                          }
                          if (res.success) {
                            Navigator.pop(context);
                          }
                        });
                      }
                    }
                  },
                  child: isUpdate ? const Text('Update') : const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showPicker(context);
                  },
                  child: const Text('Pick image'),
                ),
                _image != null
                    ? Image.file(_image!)
                    : (imageFromDB != null && _image == null)
                        ? Image.network(imageFromDB)
                        : const Center(child: Text('No image selected')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    imgFormGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
