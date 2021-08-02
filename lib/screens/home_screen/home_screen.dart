//import 'package:appmedicolaluz/helper/medics.dart';
import 'package:appmedicolaluz/screens/chat_screen/main.dart';
import 'package:appmedicolaluz/screens/history_teleconsultation/history_teleconsultation.dart';
import 'package:appmedicolaluz/screens/pending_teleconsultation/pending_teleconsultation_screen.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

//import 'components/category_list_view.dart';
import 'components/horizontal_place_item.dart';
import 'components/news_list.dart';
import 'components/title_view.dart';
import '../../constants.dart';
//import 'package:appmedicolaluz/screens/medic_menu/medic_menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
   List<Widget> pageList = [];
    pageList.add(homeScreenSection(context));
    pageList.add(PendingTeleconsultationScreen());
    pageList.add(HistoryTeleconsultation());
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pageList,
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Inicio'),
            activeColor: kPrimaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Teleconsultas'),
            activeColor: kPrimaryColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.history),
            title: Text('Historiales'),
            activeColor: kPrimaryColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

homeScreenSection(BuildContext context) {
  return Scaffold(
    floatingActionButton: FloatingActionButton(
      heroTag: null,
      onPressed: () {
        Navigator.pushNamed(context, MainChat.routeName);
      },
      backgroundColor: kPrimaryColor,
      child: Icon(Icons.chat),
    ),
    body: ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: TitleView(
            titleTxt: 'Noticias',
            subTxt: 'Ver más',
            press: () {
             /* Navigator.pushNamed(
                  context, TeleconsultationInfoScreen.routeName);*/
            },
          ),
        ),
        newsList(),
      ],
    ),
  );
}

