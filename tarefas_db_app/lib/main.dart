import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/tarefa.dart';



void main(){

  runApp(
    const MyApp()
  );

}




class MyApp extends StatelessWidget{


  const MyApp({super.key});



  @override
  Widget build(BuildContext context){


    return MaterialApp(

      debugShowCheckedModeBanner:false,


      home: const TelaTarefas(),


    );


  }


}







class TelaTarefas extends StatefulWidget{


  const TelaTarefas({super.key});



  @override
  State<TelaTarefas> createState()=>_TelaTarefasState();



}





class _TelaTarefasState extends State<TelaTarefas>{



  final campo = TextEditingController();



  List<Tarefa> tarefas = [];





  @override
  void initState(){


    super.initState();


    carregar();


  }






  Future<void> carregar() async {


    final lista =
    await DatabaseHelper.instance.buscarTodas();



    setState((){


      tarefas = lista;


    });


  }






  Future<void> adicionar() async {


    if(campo.text.isEmpty){

      return;

    }



    await DatabaseHelper.instance.inserir(

      Tarefa(

        titulo:campo.text,

      ),

    );



    campo.clear();



    carregar();



  }







  Future<void> excluirTudo() async {



    final resposta = await showDialog<bool>(


      context:context,


      builder:(context){


        return AlertDialog(


          title:
          const Text(
            "Apagar tudo?"
          ),



          actions:[


            TextButton(

              onPressed:(){

                Navigator.pop(
                  context,
                  false
                );

              },


              child:
              const Text(
                "Cancelar"
              ),


            ),



            TextButton(

              onPressed:(){

                Navigator.pop(
                  context,
                  true
                );

              },


              child:
              const Text(
                "Apagar"
              ),


            )


          ],


        );


      },


    );



    if(resposta == true){


      await DatabaseHelper.instance.apagarTudo();


      carregar();


    }



  }






  Future<void> mudarStatus(Tarefa tarefa) async {


    await DatabaseHelper.instance.atualizar(

      Tarefa(

        id:tarefa.id,


        titulo:tarefa.titulo,


        concluida:
        !tarefa.concluida,


      ),


    );


    carregar();


  }






  @override
  Widget build(BuildContext context){



    return Scaffold(


      appBar: AppBar(


        title:
        const Text(
          "Tarefas SQLite"
        ),



        actions:[


          IconButton(

            icon:
            const Icon(
              Icons.delete
            ),


            onPressed:
            excluirTudo,


          )


        ],


      ),





      body:Column(


        children:[



          Padding(


            padding:
            const EdgeInsets.all(10),



            child:
            Text(

              "Total de tarefas: ${tarefas.length}",


              style:
              const TextStyle(

                fontSize:20,

              ),


            ),



          ),






          Row(


            children:[



              Expanded(


                child:
                TextField(


                  controller:
                  campo,


                  decoration:
                  const InputDecoration(

                    hintText:
                    "Nova tarefa"

                  ),



                ),


              ),





              IconButton(

                icon:
                const Icon(
                  Icons.add
                ),


                onPressed:
                adicionar,


              )


            ],


          ),






          Expanded(


            child:
            ListView.builder(


              itemCount:
              tarefas.length,



              itemBuilder:(context,index){



                final tarefa =
                tarefas[index];



                return ListTile(



                  title:
                  Text(

                    tarefa.titulo,



                    style:
                    TextStyle(

                      decoration:
                      tarefa.concluida

                      ? TextDecoration.lineThrough

                      : null,


                    ),


                  ),




                  leading:
                  Checkbox(


                    value:
                    tarefa.concluida,



                    onChanged:(v){

                      mudarStatus(tarefa);

                    },


                  ),




                  trailing:
                  IconButton(


                    icon:
                    const Icon(
                      Icons.delete,
                      color:Colors.red,
                    ),



                    onPressed:(){


                      DatabaseHelper.instance.remover(
                        tarefa.id!
                      );


                      carregar();



                    },


                  ),



                );


              },


            ),


          )


        ],


      ),


    );


  }


}
