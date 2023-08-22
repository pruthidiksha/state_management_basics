import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        "/new-contact": (context) => const NewContactView(),
      },
    );
  }
}

class Contact {
  final String name;

  const Contact({required this.name});
}

/// Singleton of ContactBook (One instance of class in entire application)
/// ContactBook._sharedInstance(); private constructor called sharedInstance()
/**
 * Use the factory keyword when implementing a constructor that doesn’t always create a new instance of its class.
 * For example, a factory constructor might return an instance from a cache, or it might return an instance of a subtype.
 * Another use case for factory constructors is initializing a final variable using logic that can’t be handled in the initializer list.
 */
class ContactBook {
  ContactBook._sharedInstance();

  static final ContactBook _shared = ContactBook._sharedInstance();

  factory ContactBook() => _shared;

  final List<Contact> _contacts = [const Contact(name: "foo")];

  int get length => _contacts.length;

  void add({required Contact contact}) {
    _contacts.add(contact);
  }

  void remove({required Contact contact}) {
    _contacts.remove(contact);
  }

  Contact? contact({required int atIndex}) =>
      _contacts.length > atIndex ? _contacts[atIndex] : null;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
      ),
      body: ListView.builder(
          itemCount: contactBook.length,
          itemBuilder: (context, index) {
            final contact = contactBook.contact(atIndex: index)!;
            return ListTile(
              title: Text(contact.name),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed("/new-contact");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({super.key});

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new Contact"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
                hintText: "Enter a new Contact name here..."),
          ),
          TextButton(onPressed: () {
            final _contact = Contact(name: _controller.text.toString());
            ContactBook().add(contact: _contact);
            Navigator.of(context).pop();
          }, child: const Text("Add Contact"))
        ],
      ),
    );
  }
}
