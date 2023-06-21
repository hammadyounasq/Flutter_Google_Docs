import 'package:doc_clon_flutter/model/error_model.dart';
import 'package:doc_clon_flutter/repository/auth_repository.dart';
import 'package:doc_clon_flutter/router.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  ErrorModel?errorModel;

@override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData()async{
    errorModel=await ref.read(authRepositoryProvider).getUserData();
    if(errorModel!=null && errorModel!.data !=null){
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
     
        primarySwatch: Colors.blue,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context){
        final user=ref.watch(userProvider);
        if(user!=null && user.token.isNotEmpty){
          return loggedInRoute;
        }
        return loggedOutRoute;

      }),
      routeInformationParser:  RoutemasterParser(),
      // home: user == null ?  LoginScreen() : HomeScreen(),
    );
  }
}
