import 'package:flutter/foundation.dart';

import '../database/database_helper.dart';
import '../models/tarefa.dart';

class TarefaProvider extends ChangeNotifier {

  List<Tarefa> _tarefas = [];

  bool _loading = false;


  List<Tarefa> get tarefas => _tarefas;

  bool get loading => _loading;


  int get concluidas {
    return _tarefas.where((t) => t.concluida).length;
  }


  Future<void> carregarTarefas() async {

    _loading = true;

    notifyListeners();


    _tarefas = await DatabaseHelper.instance.queryAll();


    _loading = false;

    notifyListeners();
  }



  Future<void> adicionarTarefa(String titulo) async {

    final tarefa = Tarefa(
      titulo: titulo,
    );


    final id = await DatabaseHelper.instance.insert(tarefa);


    _tarefas.insert(
      0,
      tarefa.copyWith(id: id),
    );


    notifyListeners();
  }



  Future<void> alternarStatus(Tarefa tarefa) async {

    final nova = tarefa.copyWith(
      concluida: !tarefa.concluida,
    );


    await DatabaseHelper.instance.update(nova);


    final index = _tarefas.indexWhere(
      (t) => t.id == tarefa.id,
    );


    _tarefas[index] = nova;


    notifyListeners();
  }




  Future<void> editarTarefa(
      Tarefa tarefa,
      String novoTitulo
      ) async {


    final nova = tarefa.copyWith(
      titulo: novoTitulo,
    );


    await DatabaseHelper.instance.update(nova);


    final index = _tarefas.indexWhere(
      (t) => t.id == tarefa.id,
    );


    _tarefas[index] = nova;


    notifyListeners();
  }




  Future<void> removerTarefa(int id) async {

    await DatabaseHelper.instance.delete(id);


    _tarefas.removeWhere(
      (t) => t.id == id,
    );


    notifyListeners();
  }



  List<Tarefa> filtrar(String filtro){

    if(filtro == "Pendentes"){
      return _tarefas
          .where((t)=>!t.concluida)
          .toList();
    }


    if(filtro == "Concluídas"){
      return _tarefas
          .where((t)=>t.concluida)
          .toList();
    }


    return _tarefas;
  }

}