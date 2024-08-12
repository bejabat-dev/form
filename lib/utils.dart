import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form/register.dart';

class Utils {
  static Color myColor = const Color.fromARGB(255, 193, 193, 193);
  final db = FirebaseDatabase.instance;
  static Text bintang = const Text(
    '*',
    style: TextStyle(color: Colors.red),
  );

  Future<void> register(BuildContext context, String nama, dynamic data) async {
    showLoadingDialog(context);
    await db.ref('Murid').child(nama).set(data).catchError((e) {
      Navigator.pop(context);
      showCustomDialog(context, 'Terjadi kesalahan');
    }).whenComplete(() {
      Navigator.pop(context);
      showCustomDialog(
          context, 'Pendaftaran berhasil! Silahkan menunggu konfirmasi admin.');
    });
  }

  void showCustomDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
            actions: [
              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                          (route) => false);
                    },
                    child: Text("Konfirmasi")),
              )
            ],
          );
        });
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(
                    height: 4,
                  ),
                  Text('Mendaftarkan akun'),
                ],
              ),
            ),
          );
        });
  }
}
