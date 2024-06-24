import 'package:flutter/material.dart';
import 'package:tc_2024_fluencee_mobile/models/Turma.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela-inicial-turma.dart';
import 'package:tc_2024_fluencee_mobile/pages/tela-listar-turmas.dart';
import 'package:tc_2024_fluencee_mobile/routes/app-routes.dart';

class TurmaTile extends StatelessWidget {
  final Turma turma;

  const TurmaTile({super.key, required this.turma});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TelaIncialTurmas(turma: turma))).then(
              (value) =>
                  {Navigator.popAndPushNamed(context, AppRoutes.TELA_TURMAS)})
        },
        contentPadding: EdgeInsets.all(10.0),
        title: Text(
          turma.nome ?? 'Nome não disponível',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: Text(
          'professor: ' + (turma.professorNome ?? 'Professor não disponível'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: !(turma.eProfessor ?? true)
            ? Text(
                'aluno',
                style: Theme.of(context).textTheme.bodyLarge,
              )
            : null,
      ),
    );
  }
}
