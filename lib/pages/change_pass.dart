import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk_apps/repository/auth.repo.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
                  'Login Page',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Password tidak boleh kosong";
                    if (value != _confirmPasswordController.text) return "Password tidak sama";
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Konfirmasi Password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Konfirmasi Password tidak boleh kosong";
                    if (value != _newPasswordController.text) return "Password tidak sama";
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      AuthRepo.resetPassword(
                        username: _usernameController.text,
                        newPassword: _newPasswordController.text,
                      ).then((res) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(res.msg)));
                        if (res.success) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login_page', (route) => false);
                        }
                      });
                      // AuthRepo.authLogin(
                      //   username: _usernameController.text,
                      //   password: _newPasswordController.text,
                      // ).then((res) {
                      //   ScaffoldMessenger.of(context)
                      //     ..removeCurrentSnackBar()
                      //     ..showSnackBar(SnackBar(content: Text(res.msg)));
                      //   if (res.success) {
                      //     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      //   }
                      // });
                    }
                  },
                  child: const Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
