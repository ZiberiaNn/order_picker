import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_picker/presentation/providers/auth_provider.dart';
import 'package:order_picker/presentation/screens/orders_screen.dart';

import '../widgets/basic_form_button.dart';
import '../widgets/basic_form_field.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: Text(
                  "Welcome to Order Picker",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: BasicFormField(
                textController: emailController,
                labelText: "Username",
                hintText: "Enter your username.",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: BasicFormField(
                textController: passwordController,
                obscureText: true,
                labelText: "Password",
                hintText: "Enter your password.",
              ),
            ),
            BasicFormButton(
                text: "Log In",
                onPressed: () async {
                  bool logged = await ref
                      .read(authProvider.notifier)
                      .login(emailController.text, passwordController.text);
                  if (context.mounted) {
                    logged
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const OrdersView()))
                        : showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Error'),
                              content:
                                  const Text('Usuario o contraseña incorrecto'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          );
                  }
                }),
            BasicFormButton(
              text: "Register",
              onPressed: () => print("register"),
            ),
          ],
        ),
      ),
    );
  }
}
