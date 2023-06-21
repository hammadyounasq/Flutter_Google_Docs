
import 'dart:async';

import 'package:doc_clon_flutter/common/loader.dart';
import 'package:doc_clon_flutter/model/document_model.dart';
import 'package:doc_clon_flutter/model/error_model.dart';
import 'package:doc_clon_flutter/repository/auth_repository.dart';
import 'package:doc_clon_flutter/repository/document_repository.dart';
import 'package:doc_clon_flutter/repository/socket_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class DocumentScreen extends ConsumerStatefulWidget {

  final String id;

  const DocumentScreen({Key? key,required this.id}):super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {


TextEditingController titleController=TextEditingController(text: 'Untitled Document');
 quill.QuillController? _controller;

ErrorModel? errorModel;
SocketRepository socketRepository=SocketRepository();

@override
  void initState() {
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    socketRepository.changeListener((data){
      _controller ?.compose(
        quill.Delta.fromJson(data['delta']),
      _controller?.selection ?? const TextSelection.collapsed(offset: 0),
      quill.ChangeSource.REMOTE);

    });
    Timer.periodic(const Duration(seconds: 2), (timer){
      socketRepository.autoSave(<String,dynamic>{
      'delta':_controller!.document.toDelta(),
      'room':widget.id,
    });
    }); 
    
    
  }

  void fetchDocumentData()async{
    errorModel=await ref.read(documentRepositoryProvider).gettitle(ref.read(userProvider)!.token, widget.id);
    if(errorModel!.data!=null){
      titleController.text=(errorModel!.data as DocumentModal).title;
      _controller=quill.QuillController(
        document: errorModel!.data.content.isEmpty ? quill.Document():quill.Document.fromDelta(quill.Delta.fromJson(errorModel!.data.content)),
        selection: const TextSelection.collapsed(offset: 0),
      );
      setState(() {
        
      });
      _controller!.document.changes.listen((event) { 
        if(event.item3==quill.ChangeSource.LOCAL){
          Map<String,dynamic>map={
            'delta':event.item2,
            'room':widget.id,

          };
          socketRepository.typing(map);
        }
      });
    }
  }


  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
    
  }

void updateTitle(WidgetRef ref,String title){
  ref.read(documentRepositoryProvider).updateDocument(token: ref.read(userProvider)!.token, id: widget.id, title: title);
}

  @override
  Widget build(BuildContext context) {
    if(_controller==null){
      return Scaffold(
        body: Loder(),
      );
    }
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Padding(
          padding: EdgeInsets.all(10),
          child: ElevatedButton.icon(
            onPressed: (){}, icon: Icon(Icons.lock,size: 16,),
             label: Text('share')),
        ),
        
      ],
      title: Row(children: [
       GestureDetector(
         onTap: () {
           Routemaster.of(context).replace('/');
         },
         child: const Icon(Icons.image)),
       const SizedBox(width: 10,),
        SizedBox(width: 100,
        child: TextField(
          onSubmitted: ((value) => updateTitle(ref, value)),
          controller: titleController,
          decoration:const InputDecoration(
            border: InputBorder.none,contentPadding: EdgeInsets.all(10),
            focusedBorder: OutlineInputBorder(
             borderSide: BorderSide(
               color: Colors.black,
             )
            ),
            
          ),
        ),
        ),
      ],),
      bottom: PreferredSize(child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 0.1)),
      ),preferredSize: Size.fromHeight(1),),

 
          
      ),
      body:Column(
  children: [
    SizedBox(height: 10,),
    quill.QuillToolbar.basic(controller: _controller!),
    Expanded(
      child:  SizedBox(
        width: 750,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: quill.QuillEditor.basic(
                controller: _controller!,
                readOnly: false, // true for view only mode
              ),
          ),
        ),
      ),
      ),
   
  ],
),
    );
  }
}