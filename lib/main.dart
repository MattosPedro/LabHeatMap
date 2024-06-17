import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class AboutTheAppScream extends StatelessWidget {
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
                            builder: (context) => MainScreen(),
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
                    builder: (context) => AboutTheAppScream(),
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

class MainScreen extends StatelessWidget {
  // Lista de cores para os botões
  final List<Color> buttonColors = [
    Colors.red,
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.red,
    Colors.red,
    Colors.yellow,
    Colors.blue,
    Colors.yellow,
    Colors.yellow,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mapa De Calor Labs',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF166674),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 90.0), // Espaçamento superior
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.count(
                  crossAxisCount: 4, // 4 colunas
                  mainAxisSpacing: 15.0, // Espaçamento vertical entre os itens
                  crossAxisSpacing: 10.0, // Espaçamento horizontal entre os itens
                  shrinkWrap: true,
                  children: List.generate(12, (index) {
                    // Gerar 12 botões
                    return ElevatedButton(
                      onPressed: () {
                        _navigateToPage(context, index + 1);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(buttonColors[index]), // Define a cor do botão
                      ),
                      child: Align(
                        alignment: Alignment.center, // Alinha o texto ao centro do botão
                        child: Text(
                          'Lab ${index + 300}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                color: Colors.grey[350], // Cor de fundo cinza
                child: Padding(
                  padding: const EdgeInsets.only(right: 5, left: 100, top: 10, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _legendBox(Colors.red), // Caixinha vermelha (lotado)
                          SizedBox(width: 5), // Espaçamento entre as caixinhas
                          Text('Esse lab está muito ocupado'),
                        ],
                      ),
                      Row(
                        children: [
                          _legendBox(Colors.yellow), // Caixinha laranja (cheio)
                          SizedBox(width: 5), // Espaçamento entre as caixinhas
                          Text('Esse lab está parcialmente ocupado'),
                        ],
                      ),
                      Row(
                        children: [
                          _legendBox(Colors.blue), // Caixinha amarela (vazio)
                          SizedBox(width: 5), // Espaçamento entre as caixinhas
                          Text('Esse lab está vazio'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70, // Altura da moldura inferior
        color: Color(0xFF166674), // Cor da moldura inferior
      ),
    );
  }

  Widget _legendBox(Color color) {
    return Container(
      width: 20,
      height: 20,
      color: color,
    );
  }


  void _navigateToPage(BuildContext context, int pageIndex) {
    switch (pageIndex) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FirstPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondPage()),
        );
        break;
        case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ThirdPage()),
        );
        break;
        case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FourthPage()),
        );
        break;
        case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FifthPage()),
        );
        break;
        case 6:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SixthPage()),
        );
        break;
        case 7:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SeventhPage()),
        );
        break;
        case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EighthPage()),
        );
        break;
        case 9:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NinthPage()),
        );
        break;
        case 10:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TenthPage()),
        );
        break;
        case 11:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EleventhPage()),
        );
        break;
        case 12:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TwelfthPage()),
        );
        break;
      default:
        break;
    }
  }
  
}

class FirstPage extends StatefulWidget  {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
    _fetchDataFromAPI();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    //int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      //numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Future<void> _fetchDataFromAPI() async {
    try {
      final data = await fetchDataFromAPI();
      //throw Exception(data);
      setState(() {
        numero = data[0];
      });
    } catch (e) {
      setState(() {
        // Se houver erro, defina os valores para -1 ou uma mensagem de erro
        numero = -5;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 300',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText2('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      if(numero>0)Text('Luz acesa: Sim', textAlign: TextAlign.center)else Text('Luz acesa: Não', textAlign: TextAlign.center)
                    ],
                  ),
                ),
              ),
            ),
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

class SecondPage extends StatefulWidget {
   @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 301',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class ThirdPage extends StatefulWidget {
   @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
 int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 302',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class FourthPage extends StatefulWidget {
   @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 303',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class FifthPage extends StatefulWidget {
   @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 304',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class SixthPage extends StatefulWidget {
  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 305',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class SeventhPage extends StatefulWidget {
  @override
  _SeventhPageState createState() => _SeventhPageState();
}

class _SeventhPageState extends State<SeventhPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 306',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class EighthPage extends StatefulWidget {
  @override
  _EighthPageState createState() => _EighthPageState();
}

class _EighthPageState extends State<EighthPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 307',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class NinthPage extends StatefulWidget {
  @override
  _NinthPageState createState() => _NinthPageState();
}

class _NinthPageState extends State<NinthPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 308',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class TenthPage extends StatefulWidget {
  @override
  _TenthPageState createState() => _TenthPageState();
}

class _TenthPageState extends State<TenthPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 309',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class EleventhPage extends StatefulWidget {
  @override
  _EleventhPageState createState() => _EleventhPageState();
}

class _EleventhPageState extends State<EleventhPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 310',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

class TwelfthPage extends StatefulWidget {
  @override
  _TwelfthPageState createState() => _TwelfthPageState();
}

class _TwelfthPageState extends State<TwelfthPage> {
  int numero = -1; 
  int numero2 = -1;
  int numero3 = -1;

  @override
  void initState() {
    super.initState();
    // Ao iniciar a tela, chame a função assíncrona para buscar o número aleatório
    _fetchRandomNumber();
  }

  // Função assíncrona para buscar o número aleatório
  Future<void> _fetchRandomNumber() async {
    // Chame a função que retorna um Future<int>
    int random = await fetchRandomNumber();
    int random2 = await fetchRandomNumber();
    int random3 = await fetchRandomNumber();
    
    // Atualize o estado do widget com o número obtido
    setState(() {
      numero = random;
      numero2 = random2;
      numero3 = random3;
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lab 311',
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
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaçamento ao redor do contêiner
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Largura definida como 80% da largura da tela
                height: MediaQuery.of(context).size.width * 0.6, // Altura definida como 80% da largura da tela para parecer mais quadrado
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Cor de fundo cinza
                  borderRadius: BorderRadius.circular(20.0), // Borda circular
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16, right: 10, left: 110, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Alinhar o conteúdo verticalmente ao centro
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       _buildText('Pessoas no local: ', numero),
                      _buildText('Pessoas no mês: ', numero2),
                      _buildText('Pessoas na semana: ', numero3),
                      Text('Luz acesa: Sim', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
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

Future<int> fetchRandomNumber() async {
  final apiKey = '6450f899-001a-4f76-b1b2-6131b199c699';
  final min = 0;
  final max = 25; // Defina o intervalo desejado para o número aleatório

  final uri = Uri.parse('https://api.random.org/json-rpc/2/invoke');
  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    'jsonrpc': '2.0',
    'method': 'generateIntegers',
    'params': {
      'apiKey': apiKey,
      'n': 1, // Quantidade de números aleatórios desejados
      'min': min,
      'max': max,
      'replacement': true, // Permitir números repetidos
    },
    'id': 1,
  });

  final response = await http.post(uri, headers: headers, body: body);

  if (response.statusCode == 200) {
    // Requisição bem-sucedida
    final jsonData = jsonDecode(response.body);
    final randomNumbers = jsonData['result']['random']['data'];
    return randomNumbers[0]; // Retorna o primeiro número aleatório gerado
  } else {
    // Se a requisição falhar, mostrar o código de erro
    print('Falha ao carregar número aleatório. Código de erro: ${response.statusCode}');
    return 0;
  }
}

Widget _buildText(String label, int value) {
    String displayText = value != -1 ? value.toString() : 'Carregando...';
    return Text(
      '$label$displayText',
      textAlign: TextAlign.center,
      //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildText2(String label, int value) {
    String displayText = value.toString();
    return Text(
      '$label$displayText',
      textAlign: TextAlign.center,
      //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

/*

Future<Map<String, dynamic>> fetchDataFromAPI() async {
  final response = await http.get(Uri.parse('http://localhost:3000/data'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
*/

Future<Map<String, dynamic>> fetchDataFromAPI() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:3000/data'));
  

  if (response.statusCode == 200) {
    //throw Exception(response.body);
    return jsonDecode(response.body);
    
  } else {
    throw Exception('Failed to load data');
  }
}

