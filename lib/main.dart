import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var nome = "Nome do usuário";
  var email = "Email do usuário";
  ImageProvider avatar = NetworkImage("https://via.placeholder.com/100");
  var count = 1;
  TextEditingController job = TextEditingController();
  Dio dio;
  var result = "";

  @override
  void initState() {
    super.initState();

    BaseOptions options =
        new BaseOptions(baseUrl: "https://reqres.in/api", connectTimeout: 5000);

    dio = new Dio(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exemplo dio"),
      ),
      body: Center(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundImage: avatar,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  nome,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  email,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: 150,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Digite a profissão',
                    ),
                    controller: job,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.orange,
                      child: Text("Obter perfil!",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        getProfile();
                      },
                    ),
                    MaterialButton(
                      color: Colors.orange,
                      child: Text("Enviar!",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        submitUser();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Resposta: $result",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
            )),
      ),
    );
  }

  void getProfile() async {
    Response response = await dio.get("/users/$count");
    var profile = response.data["data"];
    setState(() {
      nome = profile["first_name"] + " " + profile["last_name"];
      email = profile["email"];
      avatar = NetworkImage(profile["avatar"]);
      result = "";
    });
  }

  void submitUser() async {
    Response response =
        await dio.post("/users", data: {"name": nome, "job": job.text});
    print(response.data.toString());
    setState(() {
      nome = "Nome do usuário";
      email = "Email do usuário";
      avatar = NetworkImage("https://via.placeholder.com/100");
      job.text = "";
      result = response.data.toString();
      count++;
    });
  }
}
