import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  Future<String?> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usuarioLogado = prefs.getString('usuarioLogado');

    if (usuarioLogado != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('Usuarios')
          .doc(usuarioLogado)
          .get();

      if (userDoc.exists) {
        String? userName = userDoc.data()?['Nome'];
        return userName;
      } else {
        print('Documento do usuário não encontrado no Firestore.');
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('usuarioLogado'); // Remova o UID do SharedPreferences

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future: _getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar o nome do usuário.');
                } else {
                  String? userName = snapshot.data;
                  return Text(
                    userName != null
                        ? 'Bem-vindo,\n$userName!'
                        : 'Usuário desconhecido.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  );
                }
              },
            ),
            SizedBox(height: 20), // Espaçamento entre o texto e o botão
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Registrar Novo Usuário'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hardware');
              },
              child: Text('Registrar Novo hardware'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/group');
              },
              child: Text('Registrar Novo Grupo'),
            ),
          ],
        ),
      ),
    );
  }
}
