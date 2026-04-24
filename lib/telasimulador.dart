import 'package:flutter/material.dart';
import 'package:roundrobin/estado.dart';
import 'package:roundrobin/processo.dart';

class TelaSimulador extends StatefulWidget {
  const TelaSimulador({super.key});

  @override
  State<TelaSimulador> createState() => _TelaSimuladorState();
}

class _TelaSimuladorState extends State<TelaSimulador> {
  final List<Processo> _processos = [];
  final TextEditingController _quantumController = TextEditingController(
    text: "4",
  );
  final TextEditingController _tempoTotalController = TextEditingController(
    text: "100",
  );

  List<String?> _linhaTempo = [];
  double _usoCPU = 0;
  bool _simulacaoFeita = false;

  void _adicionarProcesso() {
    setState(() {
      int id = _processos.length + 1;
      _processos.add(
        Processo(nome: "P$id", tempoCPU: 4, tempoDisco: 2, rodadasIniciais: 2),
      );
    });
  }

  void _executarSimulacao() {
    if (_processos.isEmpty) return;

    int quantum = int.tryParse(_quantumController.text) ?? 4;
    int tempoMax = int.tryParse(_tempoTotalController.text) ?? 100;

    for (var p in _processos) {
      p.reset();
    }

    int tempoAtual = 0;
    int totalTrabalhoCPU = 0;
    List<String?> logCPU = [];

    List<Processo> filaProntos = List.from(_processos);
    List<Processo> filaDisco = [];
    Processo? cpu;
    Processo? disco;
    int finalizadosCount = 0;

    while (tempoAtual < tempoMax) {
      if (disco != null) {
        disco.tempoDiscoAtual++;
        if (disco.tempoDiscoAtual >= disco.tempoDisco) {
          disco.tempoDiscoAtual = 0;
          if (disco.rodadasRestantes > 0) {
            filaProntos.add(disco);
            disco.estado = Estado.pronto;
          } else {
            disco.estado = Estado.finalizado;
            disco.instanteFinalizacao = tempoAtual;
            finalizadosCount++;
          }
          disco = null;
        }
      }
      if (disco == null && filaDisco.isNotEmpty) {
        disco = filaDisco.removeAt(0);
        disco.estado = Estado.bloqueado;
      }

      if (cpu != null) {
        if (cpu.tempoResposta == -1) cpu.tempoResposta = tempoAtual;
        cpu.tempoCpuAtual++;
        cpu.tempoNoQuantum++;
        totalTrabalhoCPU++;
        logCPU.add(cpu.nome);

        if (cpu.tempoCpuAtual >= cpu.tempoCPU) {
          cpu.tempoCpuAtual = 0;
          cpu.tempoNoQuantum = 0;
          cpu.rodadasRestantes--;
          filaDisco.add(cpu);
          cpu.estado = Estado.bloqueado;
          cpu = null;
        } else if (cpu.tempoNoQuantum >= quantum) {
          cpu.tempoNoQuantum = 0;
          filaProntos.add(cpu);
          cpu.estado = Estado.pronto;
          cpu = null;
        }
      } else {
        logCPU.add(null);
      }

      if (cpu == null && filaProntos.isNotEmpty) {
        cpu = filaProntos.removeAt(0);
        cpu.estado = Estado.executando;
      }

      for (var p in filaProntos) {
        p.tempoEspera++;
      }

      tempoAtual++;
      if (finalizadosCount == _processos.length &&
          cpu == null &&
          disco == null) {
        break;
      }
    }

    setState(() {
      _linhaTempo = logCPU;
      _usoCPU = (totalTrabalhoCPU / tempoAtual) * 100;
      _simulacaoFeita = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simulador de Escalonamento")),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputs(),
                const Divider(),
                _buildListaProcessos(),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _executarSimulacao,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Rodar Simulação"),
                ),
                if (_simulacaoFeita) _buildResultados(),

                const SizedBox(height: 120),
              ],
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.asset('assets/ufersa.png', width: 200),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarProcesso,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInputs() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _quantumController,
            decoration: const InputDecoration(labelText: "Quantum"),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: _tempoTotalController,
            decoration: const InputDecoration(labelText: "Tempo Total"),
          ),
        ),
      ],
    );
  }

  Widget _buildListaProcessos() {
    return Column(
      children: _processos
          .map(
            (p) => Card(
              child: ListTile(
                title: Text(p.nome),
                subtitle: Text(
                  "CPU: ${p.tempoCPU} | Disco: ${p.tempoDisco} | Rodadas: ${p.rodadasIniciais}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => _processos.remove(p)),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildResultados() {
    double esperaMedia = _processos.isEmpty
        ? 0
        : _processos.map((p) => p.tempoEspera).reduce((a, b) => a + b) /
              _processos.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Uso da CPU: ${_usoCPU.toStringAsFixed(1)}%",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text("Tempo Médio de Espera: ${esperaMedia.toStringAsFixed(2)}"),
        const SizedBox(height: 10),
        const Text("Linha do Tempo (CPU):"),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _linhaTempo.length,
            itemBuilder: (context, i) => Container(
              width: 30,
              margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 9),
              color: _linhaTempo[i] == null
                  ? Colors.grey[300]
                  : Colors.blue[400],
              child: Center(
                child: Text(
                  _linhaTempo[i] ?? "-",
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
