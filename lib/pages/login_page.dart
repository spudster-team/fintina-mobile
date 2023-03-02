import 'package:dio/dio.dart';
import 'package:fintina/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:status_alert/status_alert.dart';

import '../services/rest_api_service.dart';
import 'home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final service = HttpRestApiService(Dio());

  void _login() async {
    setState(() {
      isLoading = true;
    });

    final res = await service.login(
      usernameController.text,
      passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    res.fold(
      (l) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l)));
        StatusAlert.show(
          context,
          duration: const Duration(
            seconds: 2,
          ),
          title: 'Connexion échouée',
          subtitle: l,
          configuration: const IconConfiguration(icon: Icons.error),
        );
      },
      (r) {
        ref.read(isLoggedStateProvider.notifier).state = true;
        StatusAlert.show(
          context,
          duration: const Duration(
            seconds: 2,
          ),
          title: r,
          configuration: const IconConfiguration(icon: Icons.check),
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return const HomePage();
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Connexion'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer(),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: "Nom d'utilisateur",
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Mot de passe",
                  ),
                ),
                const SizedBox(height: 50),
                Visibility(
                  visible: isLoading,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Visibility(
                  visible: !isLoading,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: const Text("Se connecter"),
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
