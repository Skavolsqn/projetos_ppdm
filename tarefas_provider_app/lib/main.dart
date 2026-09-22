import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/tarefa.dart';
import 'providers/tarefa_provider.dart';


void main() {

  runApp(

    ChangeNotifierProvider(

      create: (_) => TarefaProvider()..carregarTarefas(),

      child: const TarefasApp(),

    ),

  );

}


class TarefasApp extends StatelessWidget {

  const TarefasApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Tarefas Provider SQLite',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}



class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();

}



class _HomeScreenState extends State<HomeScreen> {


  String filtro = "Todas";


  final filtros = [
    "Todas",
    "Pendentes",
    "Concluídas"
  ];



  void adicionar(BuildContext context) {

    final controller = TextEditingController();


    showDialog(
      context: context,

      builder: (context) {

        return AlertDialog(

          title: const Text("Nova tarefa"),


          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Título",
            ),
          ),


          actions: [

            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),
            ),


            ElevatedButton(

              onPressed: (){

                Provider.of<TarefaProvider>(
                  context,
                  listen:false,
                ).adicionarTarefa(
                  controller.text,
                );


                Navigator.pop(context);
              },


              child: const Text("Adicionar"),
            )

          ],

        );
      },
    );
  }




  void editar(
    BuildContext context,
    Tarefa tarefa,
  ) {


    final controller = TextEditingController(
      text: tarefa.titulo,
    );


    showDialog(

      context: context,


      builder: (context){

        return AlertDialog(

          title: const Text("Editar tarefa"),


          content: TextField(
            controller: controller,
          ),


          actions: [


            TextButton(

              onPressed: (){
                Navigator.pop(context);
              },

              child: const Text("Cancelar"),

            ),



            ElevatedButton(

              onPressed: (){


                Provider.of<TarefaProvider>(
                  context,
                  listen:false,
                ).editarTarefa(
                  tarefa,
                  controller.text,
                );


                Navigator.pop(context);

              },


              child: const Text("Salvar"),

            )

          ],

        );

      },

    );

  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: Consumer<TarefaProvider>(

          builder: (context, provider, child){

            return Text(
              "${provider.concluidas} de ${provider.tarefas.length} concluídas",
            );

          },

        ),


        centerTitle: true,

      ),




      body: Consumer<TarefaProvider>(


        builder: (context, provider, child){


          final lista = provider.filtrar(filtro);



          return Column(


            children: [


              SizedBox(

                height: 60,


                child: ListView.builder(

                  scrollDirection: Axis.horizontal,


                  itemCount: filtros.length,


                  itemBuilder: (context,index){


                    final item = filtros[index];


                    return Padding(

                      padding: const EdgeInsets.all(8),


                      child: ChoiceChip(

                        label: Text(item),


                        selected: filtro == item,


                        onSelected: (_){

                          setState((){

                            filtro = item;

                          });

                        },

                      ),

                    );

                  },

                ),

              ),




              Expanded(


                child: provider.loading


                    ? const Center(
                        child: CircularProgressIndicator(),
                      )



                    : lista.isEmpty


                      ? const Center(

                          child: Text(
                            "Nenhuma tarefa encontrada",
                          ),

                        )



                      : ListView.builder(


                          itemCount: lista.length,


                          itemBuilder: (context,index){


                            final tarefa = lista[index];



                            return Card(


                              child: ListTile(



                                onLongPress: (){

                                  editar(
                                    context,
                                    tarefa,
                                  );

                                },



                                leading: Checkbox(

                                  value: tarefa.concluida,


                                  onChanged: (_){

                                    provider.alternarStatus(
                                      tarefa,
                                    );

                                  },

                                ),



                                title: Text(

                                  tarefa.titulo,


                                  style: TextStyle(

                                    decoration: tarefa.concluida

                                        ? TextDecoration.lineThrough

                                        : TextDecoration.none,

                                  ),

                                ),




                                trailing: IconButton(


                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),


                                  onPressed: (){

                                    provider.removerTarefa(
                                      tarefa.id!,
                                    );

                                  },


                                ),



                              ),


                            );

                          },


                        ),

              )

            ],

          );

        },

      ),





      floatingActionButton: FloatingActionButton(


        onPressed: (){

          adicionar(context);

        },


        child: const Icon(Icons.add),

      ),


    );

  }

}