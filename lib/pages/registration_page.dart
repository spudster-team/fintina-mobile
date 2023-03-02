import 'package:dio/dio.dart';
import 'package:fintina/pages/home_page.dart';
import 'package:fintina/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../services/rest_api_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final service = HttpRestApiService(Dio());

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void _register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final res = await service.register(
        usernameController.text,
        emailController.text,
        passwordController.text,
      );

      setState(() {
        isLoading = false;
      });

      res.fold(
        (l) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l)));
        },
        (r) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(r)));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }), (route) => false);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Inscription'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset(
                    'assets/images/logo1.png',
                  ),
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: "Nom d'utilisateur",
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Adresse e-mail",
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Mot de passe",
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez entrer une valeur';
                    } else {
                      if (value.length < 8) {
                        return 'Veuillez saisir au moins 8 caractères';
                      }
                    }
                  },
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Confirmation mot de passe",
                  ),
                  validator: (value) {
                    if (value != passwordController.text) {
                      return 'Veuillez entrer des mots de passe identiques';
                    }
                  },
                ),
                Visibility(
                  visible: isLoading,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Visibility(
                  visible: !isLoading,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text("S'incrire"),
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
