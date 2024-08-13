import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form/utils.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final storage = FirebaseStorage.instance;
  final db = FirebaseDatabase.instance;

  final utils = Utils();
  final formKey = GlobalKey<FormState>();
  final nama = TextEditingController();
  final tempat = TextEditingController();
  final tanggal = TextEditingController();
  final alamat = TextEditingController();

  List<String> kelas = ['Reguler', 'Prestasi', 'Khusus'];
  String selectedKelas = 'Reguler';

  DateTime? _selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 70);
    final DateTime lastDate = DateTime(now.year + 15);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        tanggal.text = formattedDate(pickedDate);
      });
    }
  }

  String? image1;
  String? image2;

  String formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> getImage(String nama, int foto) async {
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan nama terlebih dahulu')));
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    //final f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      uploadImage(File(result.files.single.path!), nama, foto);
    } else {
      return;
    }
  }

  void uploadImage(File file, String nama, int foto) async {
    String f = 'foto1';
    if (foto == 1) {
      f = 'foto1';
    } else if (foto == 2) {
      f = 'foto2';
    }
    utils.showLoadingDialog(context);
    final path = storage.ref('murid/$f@$nama');
    path.putFile(file).catchError((e) {
      return utils.showCustomDialog(context, 'Terjadi kesalahan');
    }).whenComplete(() async {
      if (mounted) {
        String url = await path.getDownloadURL();
        await db.ref(nama).update({f: url});
        if (mounted) {
          setState(() {
            if (foto == 1) {
              image1 = url;
            }
            if (foto == 2) {
              image2 = url;
            }
          });
          Navigator.pop(context);
        }
      }
    });
  }

  void daftar() async {
    if (formKey.currentState?.validate() ?? false) {
      await Utils().register(context, nama.text, {
        'key': nama.text,
        'nama': nama.text,
        'tanggal': tanggal.text,
        'tempat': tempat.text,
        'alamat': alamat.text,
        'kelas': selectedKelas,
        'foto3': 'unset',
        'register': true
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: IntrinsicHeight(
            child: SizedBox(
              width: 750,
              child: Material(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                            child: Text(
                          'Formulir Pendaftaran',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [const Text('Nama lengkap'), Utils.bintang],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        TextFormField(
                          controller: nama,
                          decoration: const InputDecoration(
                              hintText: 'Masukkan nama lengkap'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [const Text('Tempat lahir'), Utils.bintang],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        TextFormField(
                          controller: tempat,
                          decoration: const InputDecoration(
                              hintText: 'Masukkan tempat lahir'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Text('Tanggal lahir'),
                            Utils.bintang
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        TextFormField(
                          onTap: () {
                            selectDate(context);
                          },
                          readOnly: true,
                          controller: tanggal,
                          decoration:
                              const InputDecoration(hintText: 'Pilih tanggal'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Pilih tanggal';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [const Text('Alamat'), Utils.bintang],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        TextFormField(
                          controller: alamat,
                          maxLines: 3,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'Masukkan alamat'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [const Text('Pilih kelas'), Utils.bintang],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        DropdownButtonFormField(
                          dropdownColor: Colors.white,
                          value: selectedKelas,
                          items: kelas.map((String value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (value) {
                            selectedKelas = value!;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              image1 == null
                                  ? InkWell(
                                      onTap: () {
                                        getImage(nama.text, 1);
                                      },
                                      child: Container(
                                        width: 250,
                                        height: 350,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Utils.myColor)),
                                        child:
                                            Center(child: Text('Foto profil')),
                                      ),
                                    )
                                  : Image.network(image1!),
                              const SizedBox(
                                height: 8,
                              ),
                              image2 == null
                                  ? InkWell(
                                      onTap: () {
                                        getImage(nama.text, 2);
                                      },
                                      child: Container(
                                        width: 250,
                                        height: 350,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Utils.myColor)),
                                        child: Center(
                                          child: Text('Dokumen tambahan'),
                                        ),
                                      ),
                                    )
                                  : Image.network(image2!),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue,
                          child: InkWell(
                            onTap: () {
                              daftar();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'Daftar',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
