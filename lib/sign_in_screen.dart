import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_manager.dart'; // Import AuthManager

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final authManager = Provider.of<AuthManager>(context, listen: false);
                    final success = await authManager.signIn(
                      _usernameController.text,
                      _passwordController.text,
                    );
                    if (success) {
                      // Navigation is handled in main.dart now, so no need to push here.
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid credentials')),
                      );
                    }
                  }
                },
                child: const Text('Sign In'),
              ),
              //Sign up button
              TextButton(
                onPressed: () {
                  // Navigate to a sign-up screen (you'd need to create this screen)
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
                  showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(
                      title: const Text('Sign Up'),
                      content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(labelText: 'Username'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(labelText: 'Email'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Email';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(labelText: 'Password'),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          )
                      ),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        },
                            child: const Text('Cancel')),
                        ElevatedButton(onPressed: () async{
                          if(_formKey.currentState!.validate()){
                            final authManager = Provider.of<AuthManager>(context, listen: false);
                            final success = await authManager.signUp(_usernameController.text, _passwordController.text, _emailController.text);
                            if(success){
                              //Close the Dialog
                              Navigator.pop(context);
                              //Show Success message
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful!')));
                            }
                            else{
                              // Show an error message if the user already exists.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Username or Email already exists')),
                              );
                            }
                          }
                        },
                            child: const Text('Sign Up'))
                      ],
                    );
                  });
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}