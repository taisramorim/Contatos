import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class Contact {
  late final String name;
  final File? image;

  Contact({required this.name, this.image});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Contatos',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ContactListScreen(),
    );
  }
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Contatos'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  contact.image != null ? FileImage(contact.image!) : null,
              backgroundColor: Colors.grey,
            ),
            title: Text(contact.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final newName = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        String newName = contact.name;
                        return AlertDialog(
                          title: Text('Editar Contato'),
                          content: TextField(
                            onChanged: (value) {
                              newName = value;
                            },
                            controller:
                                TextEditingController(text: contact.name),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(newName);
                              },
                              child: Text('Salvar'),
                            ),
                          ],
                        );
                      },
                    );
                    if (newName != null) {
                      setState(() {
                        contact.name = newName;
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Excluir Contato'),
                          content: Text(
                              'Tem certeza de que deseja excluir este contato?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  contacts.remove(contact);
                                });
                                Navigator.of(context).pop();
                              },
                              child: Text('Confirmar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedFile =
              await ImagePicker().getImage(source: ImageSource.camera);
          if (pickedFile != null) {
            final newContact =
                Contact(name: 'Nome', image: File(pickedFile.path));
            setState(() {
              contacts.add(newContact);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
