import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form/model.dart';
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
  final biaya = TextEditingController();

  List<String> kelas = ['Reguler', 'Khusus', 'Prestasi'];
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

  Uint8List? image1;
  Uint8List? image2;

  String formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Uint8List? fotos;

  Future<void> getImage(String nama, int foto) async {
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan nama terlebih dahulu')));
      return;
    }
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    //final f = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      fotos = result.files.single.bytes;
      uploadImage(nama, foto);
    } else {
      return;
    }
  }

  void uploadImage(String nama, int foto) async {
    String f = 'foto1';
    if (foto == 1) {
      f = 'foto1';
    } else if (foto == 2) {
      f = 'foto2';
    }
    utils.showLoadingDialog(context);
    final path = storage.ref('$f@$nama');
    path
        .putData(fotos!, SettableMetadata(contentType: "image/png"))
        .catchError((e) {
      return utils.showCustomDialog(context, 'Terjadi kesalahan');
    }).whenComplete(() async {
      if (mounted) {
        String url = await path.getDownloadURL();
        await db.ref('Murid').child(nama).update({f: url});
        if (mounted) {
          setState(() {
            if (foto == 1) {
              image1 = fotos;
            }
            if (foto == 2) {
              image2 = fotos;
            }
          });
          Navigator.pop(context);
        }
      }
    });
  }

  void daftar() async {
    if (formKey.currentState?.validate() ?? false) {
      final registrationData = RegistrationData(
          key: nama.text,
          nama: nama.text,
          tanggal: tanggal.text,
          tempat: tempat.text,
          alamat: alamat.text,
          kelas: selectedKelas,
          foto3: 'unset',
          register: true,
          biaya: int.parse(biaya.text),
          tanggalBergabung: DateTime.now());

      await Utils().register(context, nama.text, registrationData.toJson());
    }
  }

  @override
  void initState() {
    super.initState();
    biaya.text = '250000';
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
                            switch (selectedKelas) {
                              case 'Reguler':
                                {
                                  biaya.text = '250000';
                                  break;
                                }
                              case 'Khusus':
                                {
                                  biaya.text = '350000';
                                  break;
                                }
                              case 'Prestasi':
                                {
                                  biaya.text = '450000';
                                  break;
                                }
                            }
                          },
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
                        const Text('Biaya'),
                        const SizedBox(
                          height: 2,
                        ),
                        TextFormField(
                          controller: biaya,
                          readOnly: true,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              prefixText: 'Rp'),
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
                                            const Center(child: Text('Foto profil')),
                                      ),
                                    )
                                  : Image.memory(
                                      image1!,
                                      width: 250,
                                      height: 350,
                                      fit: BoxFit.cover,
                                    ),
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
                                        child: const Center(
                                          child: Text('Dokumen tambahan'),
                                        ),
                                      ),
                                    )
                                  : Image.memory(
                                      image2!,
                                      width: 250,
                                      height: 350,
                                      fit: BoxFit.cover,
                                    ),
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
