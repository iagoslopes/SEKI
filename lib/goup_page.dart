import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:logger/logger.dart';

class GroupPage extends StatelessWidget {
  GroupPage({Key? key}) : super(key: key);
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _empresapaiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Grupo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Group Page'),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextFormField(
              controller: _empresapaiController,
              decoration: const InputDecoration(labelText: 'EmpresaPai'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
