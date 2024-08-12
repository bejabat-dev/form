import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Utils {
  final db = FirebaseDatabase.instance;
  static Text bintang = const Text(
    '*',
    style: TextStyle(color: Colors.red),
  );

  Future<void> register(BuildContext context, dynamic data) async {
    await db.ref('Murid').child('aris').set(data).catchError((e) {
      return;
    }).whenComplete(() {
      showCustomDialog(context);
    });
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:
                Text('Pendaftaran berhasil! Silahkan tunggu konfirmasi admin.'),
            actions: [
              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Konfirmasi")),
              )
            ],
          );
        });
  }

  void showLoadingDialog(BuildContext context) async {}
}
