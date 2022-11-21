import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
              const Hero(tag: 'Register', child: Text('Register Page')),
              const Text("Create U'Re Account"),
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
                    await _auth.createUserWithEmailAndPassword(
                        email: email, password: pass);
                    navigator.pop(context);
                  } catch (err) {
                    final snakc = SnackBar(
                      content: Text(err.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snakc);
                  } finally {
                    _isLoading = false;
                  }
                },
                child: const Text('Register'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Already have account? Login.'))
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
