import 'package:doc_clon_flutter/model/error_model.dart';
import 'package:doc_clon_flutter/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'home_screen.dart';

class LoginScreen extends ConsumerWidget {

  //  void signInGoogle(WidgetRef ref,BuildContext context)async{

  //    final sMessenger=ScaffoldMessenger.of(context);
  //    final navigator=Routemaster.of(context);
     
  //  var errorModle =await ref.read(authRepositoryProvider).siginWithGoogle();
  
   
  //  if(errorModle.error==null){
  //    ref.read(userProvider.notifier).update((state) => errorModle.data);
  //    navigator.replace('/');
    
  //  }else{
  //     sMessenger.showSnackBar(SnackBar(content: Text(errorModle.error!),),);
  //  }
  // }
  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace('/');
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(onPressed:() =>
          signInWithGoogle(ref,context),
          
        
        icon: Icon(Icons.person),
        label: Text('Singin in with google'),
       
        ),),
      
    );
  }
}