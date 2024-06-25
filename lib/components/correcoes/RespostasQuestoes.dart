import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/api/resposta-service.dart';
import 'package:tc_2024_fluencee_mobile/components/correcoes/tela-correcao.dart';
import 'package:tc_2024_fluencee_mobile/main.dart';
import 'package:tc_2024_fluencee_mobile/models/EstudanteGrupo.dart';
import 'package:tc_2024_fluencee_mobile/models/RespostaBD.dart';

class RespostaQuestao extends StatefulWidget {
  final EstudanteGrupo estudanteGrupo;
  const RespostaQuestao({super.key, required this.estudanteGrupo});

  @override
  State<RespostaQuestao> createState() => _RespostaQuestaoState();
}

class _RespostaQuestaoState extends State<RespostaQuestao> {
  RespostaService respostaService = RespostaService();
  late List<RespostaBD> respostas;

  @override
  void initState() {
    super.initState();
    respostas = _carregarRespostas();
  }

  List<RespostaBD> _carregarRespostas() {
    List<RespostaBD> respostas = [];
    widget.estudanteGrupo.respostas.forEach((RespostaBD) {
      if (RespostaBD.nota == null) respostas.add(RespostaBD);
    });

    return respostas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).scaffoldBackgroundColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          toolbarHeight:
              MediaQuery.of(context).size.height * MyApp.appBarHeight,
          backgroundColor: Theme.of(context).canvasColor,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 30.0),
              Center(
                child: Text(
                  'Respostas de ' + widget.estudanteGrupo.estudante.nome!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: 30.0),
              Expanded(
                child: ListView.builder(
                  itemCount: respostas.length,
                  itemBuilder: (context, index) {
                    RespostaBD resposta = respostas[index];
                    return ListTile(
                      title: Text(resposta.nomeQuestao!),
                      trailing: Icon(Icons.assignment_turned_in),
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CorrecaoDissertativa(
                                        respostaBD: resposta)))
                            .then((value) => Navigator.pop(context));
                      },
                    );
                  },
                ),
              )
            ])));
  }
}
