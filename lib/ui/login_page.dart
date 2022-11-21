import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapps/ui/register_page.dart';
import 'package:todoapps/ui/to_do_list_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login_page';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obsecureText = true;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox(),
              const Hero(tag: 'LOGIN', child: Text('Login Page')),
              const Text("Please Login with u're Account"),
              const SizedBox(
                height: 24,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Email"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _passwordController,
                obscureText: _obsecureText,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        icon: _obsecureText
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off)),
                    hintText: "Password"),
              ),
              const SizedBox(
                height: 8,
              ),
              MaterialButton(
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    final navigator = Navigator.of(context);
                    final email = _emailController.text;
                    final pass = _passwordController.text;
                    await _auth.signInWithEmailAndPassword(
                        email: email, password: pass);
                    Navigator.pushNamed(context, ToDoListPage.routeName);
                  } catch (err) {
                    final snakc = SnackBar(
                      content: Text(err.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snakc);
                  } finally {
                    _isLoading = false;
                  }
                },
                child: const Text('LOGIN'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return RegisterPage();
                      },
                    ));
                  },
                  child: const Text("Don't have a account? Register."))
            ],
          )),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
