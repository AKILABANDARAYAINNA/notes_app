import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:notes_app/screens/NotesPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // ✅ Web-specific Firebase config
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDSDVRoKiX9wB6UhmN2e1QIuPxYwHKDGHA",
        authDomain: "notesapp-d2e85.firebaseapp.com",
        databaseURL: "https://notesapp-d2e85-default-rtdb.firebaseio.com",
        projectId: "notesapp-d2e85",
        storageBucket: "notesapp-d2e85.appspot.com",
        messagingSenderId: "252471681135",
        appId: "1:252471681135:web:ea4230fd25ca46ddc72d9a",
      ),
    );
  } else {
    // ✅ For Android/iOS platforms
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const NotesPage(), // ✅ Loads your real NotesPage with Firebase
    );
  }
}

// Optional: Still here if you want to use MyHomePage later
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
