import 'package:flutter/material.dart';
import 'package:prak_auth_test/access_services.dart';
import 'package:prak_auth_test/login_screen.dart';
import 'package:prak_auth_test/main_screen.dart';
import 'package:prak_auth_test/register_screen.dart';
import 'package:provider/provider.dart';

class AccessScreen extends StatelessWidget {
  const AccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Aplikasi Anda",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text("Login"),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () async{
                  final loggedIn = await context.read<AccessServices>().signInWithGoogle(
                    showSnackbar: (msg) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(msg),
                        ),
                      );
                    },
                  );
                  if(loggedIn){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                    );
                  }
                },
                child: const Text("Login With Google"),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
