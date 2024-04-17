import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _nivelController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _geradorController = TextEditingController();

  Future<String?> _getUsuarioLogado() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usuarioLogado = prefs.getString('usuarioLogado');

    if (usuarioLogado != null) {
      return usuarioLogado;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Register Page'),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextFormField(
              controller: _empresaController,
              decoration: const InputDecoration(labelText: 'Empresa'),
            ),
            TextFormField(
              controller: _nivelController,
              decoration: const InputDecoration(labelText: 'Nível de Acesso'),
            ),
            TextFormField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              controller: _geradorController,
              decoration: const InputDecoration(labelText: 'Gerador de senha'),
            ),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future sendEmail({user_name, user_email, user_subject, message}) async {
    final service_id = 'service_3v4rnsl';
    final template_id = 'template_iecf4gn';
    final user_id = 'vfwarZrM3MChAFVqG';

    var url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    try {
      var response = await http.post(url,
          headers: {
            'origin': 'http://localhost',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'service_id': service_id,
            'template_id': template_id,
            'user_id': user_id,
            'template_params': {
              'user_name': user_name,
              'user_email': user_email,
              'user_subject': user_subject,
              'message': message,
            },
          }));

      print('[Enviado] ${response.body}');
    } catch (e) {
      print('[Erro ao enviar email]');
    }
  }

  void _register(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String nome = _nomeController.text.trim();
    String empresa = _empresaController.text.trim();
    String nivel = _nivelController.text.trim();
    String status = _statusController.text.trim();
    String user_name = nome;
    String user_email = email;
    String user_subject = 'Criação de Usuário';
    String message =
        'Seu usuário foi criado com sucesso! Para entrar no sistema, acesse com o e-mail: $email e senha: $password .';
    String? usuarioLogado = await _getUsuarioLogado();

    var logger = Logger(
      printer: PrettyPrinter(),
    );

    try {
      // Registrar usuário no Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obter o UID do usuário registrado
      String uid = userCredential.user!.uid;

      // Agora você pode usar o UID para associar documentos no Firestore
      // Por exemplo, você pode criar um documento na coleção 'users' com o UID como identificador
      await FirebaseFirestore.instance.collection('Usuarios').doc(uid).set({
        'Email': email,
        'IDempresa': empresa,
        'IDnivel': nivel,
        'Nome': nome,
        'Status': status,
        // Outros campos...
      });

      await FirebaseFirestore.instance
          .collection('DetalheUsuario')
          .doc(uid)
          .set({
        'PrimeiroAcesso': true,
        'QuemCriou': usuarioLogado,
        // Outros campos...
      });

      // Se o registro for bem-sucedido, chame a função sendEmail
      await sendEmail(
        user_name: user_name,
        user_email: user_email,
        user_subject: user_subject,
        message: message,
      );

      print('Usuário registrado com sucesso!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        logger.d('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        logger.d('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        logger.d('The email is invalidl.');
      } else if (e.code == 'email-already-in-use') {
        logger.d('The account already exists for that email.');
      } else {
        logger.d('User and/or password is invalid.');
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
