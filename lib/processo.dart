import 'package:roundrobin/estado.dart';

class Processo {
  final String nome;
  final int tempoCPU;
  final int tempoDisco;
  int rodadasIniciais;
  int rodadasRestantes;

  int tempoCpuAtual = 0;
  int tempoDiscoAtual = 0;
  int tempoNoQuantum = 0;
  Estado estado = Estado.pronto;

  int tempoEspera = 0;
  int tempoResposta = -1;
  int instanteFinalizacao = 0;

  Processo({
    required this.nome,
    required this.tempoCPU,
    required this.tempoDisco,
    required this.rodadasIniciais,
  }) : rodadasRestantes = rodadasIniciais;

  // Resetar para nova simulação
  void reset() {
    rodadasRestantes = rodadasIniciais;
    tempoCpuAtual = 0;
    tempoDiscoAtual = 0;
    tempoNoQuantum = 0;
    estado = Estado.pronto;
    tempoEspera = 0;
    tempoResposta = -1;
    instanteFinalizacao = 0;
  }
}
