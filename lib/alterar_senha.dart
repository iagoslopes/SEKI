import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirstAccessPage extends StatelessWidget {
  FirstAccessPage({Key? key}) : super(key: key);
  final TextEditingController _passwordController = TextEditingController();

  void _changePassword(BuildContext context) async {
    String newPassword = _passwordController.text.trim();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Atualize a senha no Firebase Authentication
        await user.updatePassword(newPassword);

        // Atualize o campo 'primeiro_acesso' no Firestore
        FirebaseFirestore.instance
            .collection('information')
            .doc(user.uid)
            .update({
          'first_access': false,
        });

        // Senha atualizada com sucesso
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Senha atualizada com sucesso.')));

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        // Trate os erros ao atualizar a senha
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao atualizar a senha: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Senha'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Nova Senha'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _changePassword(context),
              child: Text('Alterar Senha'),
            ),
          ],
        ),
      ),
    );
  }
}
