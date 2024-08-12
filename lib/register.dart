import 'package:flutter/material.dart';
import 'package:form/utils.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final utils = Utils();
  final formKey = GlobalKey<FormState>();

  final tanggal = TextEditingController();

  List<String> kelas = ['Reguler', 'Prestasi', 'Khusus'];
  String selectedKelas = 'Reguler';

  DateTime? _selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 10);
    final DateTime lastDate = DateTime(now.year + 10);

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

  String formattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void daftar() {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                        children: [const Text('Tanggal lahir'), Utils.bintang],
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
                      )
                    ],
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
