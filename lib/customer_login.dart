import 'package:flutter/material.dart';
class CustomerLogin extends StatelessWidget {
    const CustomerLogin({super.key});
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(title: const Text('Customer Login')),
        body: Center(
            child: Column (
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                    const Text('Customer Login Page', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Login functionality not implemented yet'))
                            );
                        },
                        child: const Text('Login/SignUp'),
                    ),
                ],
            ),
        ),
    );
    }
}