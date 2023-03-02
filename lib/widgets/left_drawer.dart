import 'package:fintina/pages/about_page.dart';
import 'package:fintina/pages/help_page.dart';
import 'package:fintina/pages/history_page.dart';
import 'package:fintina/pages/registration_page.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../pages/login_page.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              const DrawerButton(
                icon: Icons.login,
                text: 'Connexion',
                destinationPage: LoginPage(),
              ),
              const DrawerButton(
                icon: Icons.app_registration,
                text: 'Inscription',
                destinationPage: RegistrationPage(),
              ),
              const DrawerButton(
                icon: Icons.history,
                text: 'Historique',
                destinationPage: HistoryPage(),
              ),
              const DrawerButton(
                icon: Icons.sort,
                text: 'Aide',
                destinationPage: HelpPage(),
              ),
              const DrawerButton(
                icon: Icons.info,
                text: 'A propos',
                destinationPage: AboutPage(),
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
    required this.destinationPage,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Widget destinationPage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return destinationPage;
              },
            ),
          );
        },
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
