import 'package:fintina/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../pages/about_page.dart';
import '../pages/help_page.dart';
import '../pages/history_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/registration_page.dart';
import '../services/cache_service.dart';

class LeftDrawer extends ConsumerStatefulWidget {
  const LeftDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends ConsumerState<LeftDrawer> {
  bool isLogged = false;

  void _goTo(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final service = CacheService(prefs);
    await service.logout();
    ref.read(isLoggedStateProvider.notifier).state = false;
    _goTo(const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue isLogged_ = ref.watch(isLoggedProvider);

    isLogged_.whenData((data) {
      setState(() {
        isLogged = ref.read(isLoggedStateProvider);
      });
    });

    return SafeArea(
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  !isLogged
                      ? const SizedBox()
                      : Text(
                          'Bienvenu 😃',
                          style: TextStyle(
                            color: colors['lightBlue'],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: colors['lightBlue'],
                    ),
                  ),
                ],
              ),
              Divider(
                color: colors['lightBlue'],
              ),
              if (!isLogged) ...[
                DrawerButton(
                  icon: Icons.login,
                  text: 'Connexion',
                  onTap: () => _goTo(const LoginPage()),
                ),
                DrawerButton(
                  icon: Icons.app_registration,
                  text: 'Inscription',
                  onTap: () => _goTo(const RegistrationPage()),
                ),
              ],
              if (isLogged)
                DrawerButton(
                  icon: Icons.logout,
                  text: 'Deconnexion',
                  onTap: _logout,
                ),
              DrawerButton(
                icon: Icons.history,
                text: 'Historique',
                onTap: () {
                  if (ref.read(isLoggedStateProvider)) {
                    _goTo(const HistoryPage());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vous devez vous connecter pour accéder à cette page'),
                      ),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ),
                    );
                    _goTo(const LoginPage());
                  }
                },
              ),
              DrawerButton(
                icon: Icons.sort,
                text: 'Aide',
                onTap: () => _goTo(const HelpPage()),
              ),
              DrawerButton(
                icon: Icons.info,
                text: 'A propos',
                onTap: () => _goTo(const AboutPage()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: colors['lightBlue'],
              ),
              const SizedBox(width: 20),
              Text(
                text,
                style: TextStyle(
                  color: colors['lightBlue'],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
