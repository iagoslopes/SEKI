import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:logger/logger.dart';

class HardwarePage extends StatelessWidget {
  HardwarePage({Key? key}) : super(key: key);
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Hardware'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hardware Page'),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextFormField(
              controller: _marcaController,
              decoration: const InputDecoration(labelText: 'Marca'),
              obscureText: true,
            ),
            TextFormField(
              controller: _modeloController,
              decoration: const InputDecoration(labelText: 'Modelo'),
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
