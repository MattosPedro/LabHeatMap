import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre o App',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF166674),
      ),
      body: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                '\n Desenvolvido para atender às necessidades específicas de escolas, faculdades e outras instituições, o Mapa de Calor da Puc oferece um controle abrangente e em tempo real sobre a ocupação e o ambiente de diversos locais.Com o objetivo de fornecer informações precisas e acessíveis, nosso aplicativo permite que gestores visualizem a quantidade de pessoas que frequentaram um determinado ambiente em diferentes períodos de tempo, seja diariamente, semanalmente ou mensalmente. Além disso, oferecemos insights valiosos, como a disponibilidade de computadores, status das luzes e outras informações pertinentes sobre o ambiente, garantindo uma gestão eficiente e otimizada.',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.0),
            // Remova o Container daqui
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 70, // Altura da moldura inferior
        color: Color(0xFF166674), // Cor da moldura inferior
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> logins =
        (prefs.getStringList('logins') ?? []).map((item) {
      List<String> parts = item.split(';');
      return {
        'login': parts[0],
        'senha': parts[1],
      };
    }).toList();

    logins.add({
      'login': _usernameController.text,
      'senha': _passwordController.text,
    });

    List<String> formattedLogins =
        logins.map((login) => '${login['login']};${login['senha']}').toList();

    await prefs.setStringList('logins', formattedLogins);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro de Usuário',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Alinha o título no centro
        backgroundColor: Color(0xFF166674),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Login'),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirmar Senha'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_passwordController.text ==
                              _confirmPasswordController.text &&
                          _passwordController.text != '') {
                        //validar se tem usuario com mesmo nome
                        _saveUserData();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      } else if (_passwordController.text == '' ||
                          _confirmPasswordController.text == '' ||
                          _usernameController == '') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Erro'),
                            content: Text('Os campos são obrigatórios.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Erro'),
                            content: Text('As senhas não coincidem.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF166674),
                      ), // Cor de fundo do botão
                      minimumSize: MaterialStateProperty.all<Size>(Size(125,
                          30)), // Tamanho mínimo do botão (largura x altura)
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(16)), // Espaçamento interno do botão
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 16)),
                      // Outras propriedades de estilo podem ser adicionadas conforme necessário
                    ),
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 70, // Altura da moldura inferior
            color: Color(0xFF166674), // Cor da moldura inferior
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> _checkLoginData(String login, String senha) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, String>> logins = (prefs.getStringList('logins') ?? [])
        .map((item) {
          List<String> parts = item.split(';');
          if (parts.length == 2) {
            // Verifica se existem pelo menos dois elementos na lista parts
            return {
              'login': parts[0],
              'senha': parts[1],
            };
          }
          return null;
        })
        .whereType<Map<String, String>>() // Filtra os elementos nulos
        .toList();

    for (var storedLogin in logins) {
      if (storedLogin['login'] == login && storedLogin['senha'] == senha) {
        return true; // Se encontrar um login correspondente, retorna verdadeiro
      }
    }

    return false; // Se nenhum login correspondente for encontrado, retorna falso
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab Heat Map',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true, // Alinha o título no centro
        backgroundColor: Color(0xFF166674),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Login'),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      bool isValid = await _checkLoginData(
                          _usernameController.text, _passwordController.text);
                      if (isValid == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      } else if (_passwordController.text == '' ||
                          _usernameController == '') {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Erro'),
                            content: Text('Os campos são obrigatórios.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Erro'),
                            content: Text('Credenciais Inválidas. Cadastre-se'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF166674),
                      ), // Cor de fundo do botão
                      minimumSize: MaterialStateProperty.all<Size>(Size(125,
                          30)), // Tamanho mínimo do botão (largura x altura)
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(16)), // Espaçamento interno do botão
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 16)),
                      // Outras propriedades de estilo podem ser adicionadas conforme necessário
                    ),
                    child: Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color(0xFF166674),
                      ), // Cor de fundo do botão
                      minimumSize: MaterialStateProperty.all<Size>(Size(125,
                          30)), // Tamanho mínimo do botão (largura x altura)
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(16)), // Espaçamento interno do botão
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 16)), // Estilo do texto do botão
                      // Outras propriedades de estilo podem ser adicionadas conforme necessário
                    ),
                    child: Text(
                      'Cadastro',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 300.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color(0xFF166674)), // Cor de fundo do botão
                minimumSize: MaterialStateProperty.all<Size>(
                    Size(10, 15)), // Tamanho mínimo do botão (largura x altura)
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(8)), // Espaçamento interno do botão
                textStyle: MaterialStateProperty.all<TextStyle>(
                    TextStyle(fontSize: 15)), // Estilo do texto do botão
                // Outras propriedades de estilo podem ser adicionadas conforme necessário
              ),
              child: Text(
                'Sobre o App',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Container(
            height: 70, // Altura da moldura inferior
            color: Color(0xFF166674), // Cor da moldura inferior
          ),
        ],
      ),
    );
  }
}

class ViewLogins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuários Cadastrados'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            List<Map<String, String>> logins =
                (prefs.getStringList('logins') ?? []).map((item) {
              List<String> parts = item.split(';');
              return {
                'login': parts[0],
                'senha': parts[1],
              };
            }).toList();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Valores Salvos'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: logins
                      .map((login) => Text(
                          'login: ${login['login']}, senha: ${login['senha']}'))
                      .toList(),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: Text('Recuperar Valores Salvos'),
        ),
      ),
    );
  }
}
