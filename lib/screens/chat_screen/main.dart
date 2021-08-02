import 'package:appmedicolaluz/routes/routes.dart';
import 'package:appmedicolaluz/services/auth_service.dart';
import 'package:appmedicolaluz/services/chat_service.dart';
import 'package:appmedicolaluz/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class MainChat extends StatelessWidget {
    static String routeName = "/main_chat";
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat La Luz',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
