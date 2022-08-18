import 'package:anotations/page/config.dart';
import 'package:anotations/page/inicial.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //ARMAZENA AS VERIAVEIS DAS ABAS
  int selectdIndex = 0;
  int _currentIndex = 0;
  PageController? _pageController;

  //SETA ESTADO PARA SCAFFOL GLOBAL
  final scaffoldkay = GlobalKey<ScaffoldState>();

  //CONTROLAR CLICK NAS ABAS DE NAVEGAÇÃO
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    //SETA A ABA INDICADA PELO O INDEX, COM SLIDE E TEMPO DE 200 MILESEGUNDOS
    _pageController!.animateToPage(index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    //SCAFFOLD GLOBAL
    return Scaffold(
      key: scaffoldkay,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.cyan,
        onTap: (index) => onTabTapped(index),
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: ('Feiras'),
            activeIcon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: ('Ajustes'),
            activeIcon: Icon(Icons.settings),
          ),
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        allowImplicitScrolling: false,
        controller: _pageController,
        children: [
          Inicial(),
          const Config(),
        ],
      ),
    );
  }
}
