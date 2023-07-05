import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:edubot/message.dart';
import 'package:edubot/splash.dart';
import 'package:flutter/material.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EduBot',
      theme: ThemeData(
        primaryColor: Colors.deepPurple, // Set primary color
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          elevation: 0, // Remove app bar shadow
        ),
      ),
      home: const SpalshScreen(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DialogFlowtter? dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('EduBot'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // Color.fromARGB(120, 146, 187, 227),
                // Color.fromARGB(255, 28, 115, 142),
                Color(0xff0E1555),
                Color(0xff0E1555),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage('assets/logo.png'),
        //       fit: BoxFit.fitWidth,
        //       opacity: 0.8),
        // ),
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    
                     Color(0xff0E1555),
                Color(0xff0E1555),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontFamily: 'Cera Pro',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send_rounded),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      // print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse? response = await dialogFlowtter?.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );
      if (response?.message == null) return;
      setState(() {
        addMessage(response!.message!);
       

      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}