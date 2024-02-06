import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk_apps/model/person.model.dart';
import 'package:helpdesk_apps/repository/auth.repo.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

const List<String> list = <String>[
  'OPS1',
  'OPS2',
  'Sekper',
  'SPI',
  'SDM',
  'Akutansi',
  'Renstra',
  'Pengadaan',
  'IT',
  'Opset',
  'Pemasaran',
  'ACS',
];

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _namaController = TextEditingController();

  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Register Page',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    label: Text('Nama'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bagian',
                  style: TextStyle(fontSize: 12.5, color: Colors.black87),
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down_rounded),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: const Color(0xFF3A6344),
                  ),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    label: Text('Username'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username tidak boleh kosong";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Password tidak boleh kosong";
                    return null;
                  },
                  obscureText: true,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      var person = Person(
                        pid: '',
                        nama: _namaController.text,
                        username: _usernameController.text,
                        password: _passwordController.text,
                        bagian: dropdownValue,
                        role: 'Karyawan',
                      );
                      AuthRepo.authRegister(person: person).then((res) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(res.msg)));
                        if (res.success) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login_page', (route) => false);
                        }
                      });
                    }
                  },
                  child: const Text('Register'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/login_page', (route) => false);
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
