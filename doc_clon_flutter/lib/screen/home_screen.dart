import 'package:doc_clon_flutter/repository/auth_repository.dart';
import 'package:doc_clon_flutter/repository/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../common/loader.dart';
import '../model/document_model.dart';
import '../model/error_model.dart';

class HomeScreen extends ConsumerWidget {
  
void singnOut(WidgetRef ref){
  ref.read(authRepositoryProvider).signOut();
  ref.read(userProvider.notifier).update((state) => null);
}

void createDocument( BuildContext context,WidgetRef ref)async{
  String token=ref.read(userProvider)!.token;
  final navigator=Routemaster.of(context);
  final snackbar=ScaffoldMessenger.of(context);
  final errorModal=await ref.read(documentRepositoryProvider).createDocument(token);
  if(errorModal.data!=null){
    navigator.push('/document/${errorModal.data.id}');
  }else{
    snackbar.showSnackBar(
      SnackBar(content: Text(errorModal.error!),)
    );
  }

}
void navigateToDocument(BuildContext context,String documentId){
    Routemaster.of(context).push('/document/$documentId');
  }


  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: ()=>createDocument(context, ref),
           icon: Icon(Icons.add,color: Colors.black,),
           ),
           IconButton(onPressed: (){
             singnOut(ref);
           },
           icon: Icon(Icons.logout,color: Colors.black,),
           ),

      ]),
      body:  FutureBuilder<ErrorModel>(future: ref.watch(documentRepositoryProvider).getDocument(ref.watch(userProvider)!.token),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Loder();
        }
        return Container(
          margin: EdgeInsets.only(top: 10),
          width: 600,
          
          child: ListView.builder(itemCount: snapshot.data!.data.length,
          itemBuilder: (context,index){
            DocumentModal document=snapshot.data!.data[index];
            return InkWell(
              onTap: ()=>navigateToDocument(context, document.id),
              child: SizedBox(
                height: 50,
              
                child: Card(
                  child: Center(
                    child: Text(document.title,style: const TextStyle(fontSize: 17),),
                  ),
                ),
              ),
            );
          }),
        );
      },),
    );
  }
}