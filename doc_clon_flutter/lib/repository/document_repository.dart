import 'dart:convert';
import 'dart:html';

import 'package:doc_clon_flutter/constants.dart';
import 'package:doc_clon_flutter/model/document_model.dart';
import 'package:doc_clon_flutter/model/error_model.dart';
import 'package:http/http.dart';
import 'package:riverpod/riverpod.dart';


final documentRepositoryProvider=Provider((ref)=>DocumentRepository(client: Client()));

class DocumentRepository{
  final Client _client;
  DocumentRepository({required Client client}):_client=client;

Future<ErrorModel> createDocument(String token)async{
  ErrorModel error=ErrorModel(error: "somethin is wrong", data: null);
  try{

    var res=await _client.post(Uri.parse('$host/doc/create'), 
        headers:{'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':token,
        },
        body: jsonEncode({'createdAt':DateTime.now().microsecondsSinceEpoch,}),
        );
        switch(res.statusCode){
          case 200:
         
           error=ErrorModel(error: null, data: DocumentModal.fromJson(res.body),);
         
           break;
           default:
           error=ErrorModel(error: res.body, data: null);
           

        }
  }catch(e){
     error=ErrorModel(error: e.toString(), data: null);

  }
  return error;
}



Future<ErrorModel> getDocument(String token)async{
  ErrorModel error=ErrorModel(error: "somethin is wrong", data: null);
  try{

    var res=await _client.get(Uri.parse('$host/docs/me'), 
        headers:{'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':token,
        },
        
        );
        switch(res.statusCode){
          case 200:
         List<DocumentModal> documents=[];
         for(int i=0;i<jsonDecode(res.body).length;i++){
           documents.add(DocumentModal.fromJson(jsonEncode(jsonDecode(res.body)[i])));
         }
           error=ErrorModel(error: null, data: documents);
         
           break;
           default:
           error=ErrorModel(error: res.body, data: null);
           

        }
  }catch(e){
     error=ErrorModel(error: e.toString(), data: null);

  }
  return error;
}


void updateDocument({required String token,required String id,required String title})async{
  
  
    var res=await _client.post(Uri.parse('$host/doc/create'), 
        headers:{'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':token,
        },
        body: jsonEncode({
          'title':title,
          'id':id,
          
          }),
        );
  
}


Future<ErrorModel> gettitle(String token,String id)async{
  ErrorModel error=ErrorModel(error: "somethin is wrong", data: null);
  try{

    var res=await _client.get(Uri.parse('$host/docs/$id'), 
        headers:{'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token':token,
        },
        
        );
        switch(res.statusCode){
          case 200:

          error=ErrorModel(error: null, data: DocumentModal.fromJson(res.body));
           break;
           default:
          throw'error';
           

        }
  }catch(e){
     error=ErrorModel(error: e.toString(), data: null);

  }
  return error;
}






}