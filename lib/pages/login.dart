import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:helpdesk_apps/repository/auth.repo.dart';
import 'package:helpdesk_apps/repository/service.callback.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    label: Text('Password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Password tidak boleh kosong";
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(_passwordController.text);
                      AuthRepo.authLogin(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      ).then((res) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(res.msg)));
                        if (res.success) {
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        }
                      });
                    }
                  },
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/register_page', (route) => false);
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/reset_password');
                  },
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
