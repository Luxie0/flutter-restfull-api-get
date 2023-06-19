import 'package:api_learn/model/users_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// Başlık ve altbaşlık stilleri
const titleStyle = TextStyle(fontSize: 20);
const subtitleStyle = TextStyle(fontSize: 18);

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final url = Uri.parse('https://reqres.in/api/users');
  int? counter;
  var personal_result;

  Future callPerson() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // API'den gelen veriyi modele dönüştür
        var result = personalListFromJson(response.body);
        if (mounted) {
          setState(() {
            // Sayacı ve kişisel sonuçları güncelle
            counter = result.data.length;
            personal_result = result;
          });
          return result;
        }
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // İlk başta API'yı çağır
    callPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Listesi'),
        backgroundColor: Colors.red[100],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: counter != null
              ? ListView.builder(
                  itemCount: counter,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        // Kişinin adını ve soyadını göster
                        personal_result.data[index].firstName +
                            " " +
                            personal_result.data[index].lastName,
                        style: titleStyle,
                      ),
                      subtitle: Text(
                        // Kişinin e-posta adresini göster
                        personal_result.data[index].email,
                        style: subtitleStyle,
                      ),
                      leading: CircleAvatar(
                        // Kişinin avatarını göster
                        backgroundImage:
                            NetworkImage(personal_result.data[index].avatar),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        backgroundColor: Colors.red[100],
        onPressed: () {
          // Yenileme butonuna basıldığında API'yı tekrar çağır
          callPerson();
        },
      ),
    );
  }
}
