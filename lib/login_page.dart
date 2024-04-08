import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Faça login do usuário com email e senha
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtenha o UID do usuário autenticado
      String uid = userCredential.user!.uid;

      // Armazene o UID localmente usando shared_preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);

      // Verifique se é o primeiro acesso consultando o Firestore
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('information')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        bool primeiroAcesso = userDoc.data()!['first_access'] ?? false;

        await FirebaseFirestore.instance
            .collection('information')
            .doc(uid)
            .update({
          'data_access': FieldValue
              .serverTimestamp(), // Use FieldValue.serverTimestamp() para obter a hora atual no servidor
        });

        if (primeiroAcesso) {
          // Se for o primeiro acesso, redirecione para a tela de alteração de senha
          Navigator.pushReplacementNamed(context, '/alterar_senha');
        } else {
          // Se não for o primeiro acesso, redirecione para a tela principal
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Se o documento do usuário não existir, trate como desejar
        print('Documento do usuário não encontrado no Firestore.');
      }
    } catch (e) {
      // Trate os erros de autenticação
      print('Erro ao fazer login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
