import 'package:flutter/material.dart';
import 'package:trilhaapp/repositories/linguagens_repository.dart';
import 'package:trilhaapp/repositories/nivel_repository.dart';
import 'package:trilhaapp/shared/widgets/text_label.dart';

class DadosCadastraisPage extends StatefulWidget {
  const DadosCadastraisPage({Key? key}) : super(key: key);

  @override
  State<DadosCadastraisPage> createState() => _DadosCadastraisPageState();
}

class _DadosCadastraisPageState extends State<DadosCadastraisPage> {
  var nomeController = TextEditingController(text: "");
  var dataNacimentoController = TextEditingController(text: "");
  DateTime? dataNascimento;
  var nivelRepository = NivelRepository();
  var niveis = [];
  var nivelSelecionado = "";
  var linguagensRepository = LinguagensRepository();
  var linguagens = [];
  var linguagensSelecionadas = [];
  double salarioEscolhido = 0;
  int tempoExperiencia = 0;
  bool salvando = false;

  @override
  void initState() {
    niveis = nivelRepository.retornaNiveis();
    linguagens = linguagensRepository.retornaLinguagens();
    super.initState();
  }

  List<DropdownMenuItem<int>> returnItens(int quantidadeMaxima) {
    var itens = <DropdownMenuItem<int>>[];
    for (var i = 0; i <= quantidadeMaxima; i++) {
      itens.add(DropdownMenuItem(
        value: i,
        child: Text(i.toString()),
      ));
    }
    return itens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus dados")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: salvando
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  const TextLabel(texto: "Nome"),
                  TextField(
                    controller: nomeController,
                  ),
                  const TextLabel(texto: "Data de nascimento"),
                  TextField(
                      controller: dataNacimentoController,
                      readOnly: true,
                      onTap: () async {
                        var data = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900, 5, 20),
                            lastDate: DateTime(2023, 10, 23));
                        if (data != null) {
                          dataNacimentoController.text = data.toString();
                          dataNascimento = data;
                        }
                      }),
                  const TextLabel(texto: "Nivel de experiência"),
                  Column(
                      children: niveis
                          .map((nivel) => RadioListTile(
                              dense: true,
                              title: Text(nivel.toString()),
                              selected: nivelSelecionado == nivel,
                              value: nivel.toString(),
                              groupValue: nivelSelecionado,
                              onChanged: (value) {
                                debugPrint(value.toString());
                                setState(() {
                                  nivelSelecionado = value.toString();
                                });
                              }))
                          .toList()),
                  const TextLabel(texto: "Linguagens preferidas"),
                  Column(
                    children: linguagens
                        .map((linguagem) => CheckboxListTile(
                            dense: true,
                            title: Text(linguagem),
                            value: linguagensSelecionadas.contains(linguagem),
                            onChanged: (bool? value) {
                              if (value!) {
                                setState(() {
                                  linguagensSelecionadas.add(linguagem);
                                });
                              } else {
                                setState(() {
                                  linguagensSelecionadas.remove(linguagem);
                                });
                              }
                            }))
                        .toList(),
                  ),
                  const TextLabel(texto: "Tempo de experiência"),
                  DropdownButton(
                      value: tempoExperiencia,
                      isExpanded: false,
                      items: returnItens(50),
                      onChanged: (value) {
                        setState(() {
                          tempoExperiencia = int.parse(value.toString());
                        });
                      }),
                  TextLabel(
                      texto:
                          "Pretenção Salarial. R\$ ${salarioEscolhido.round().toString()}"),
                  Slider(
                      min: 0,
                      max: 50000,
                      value: salarioEscolhido,
                      onChanged: (double value) {
                        setState(() {
                          salarioEscolhido = value;
                        });
                      }),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        salvando = false;
                      });
                      if (nomeController.text.trim().length < 3) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("O nome deve ser preenchido")));
                        return;
                      }
                      if (dataNascimento == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Data de nascimento inválida")));
                        return;
                      }
                      if (nivelSelecionado.trim() == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("O nível deve ser selecionado")));
                        return;
                      }
                      if (linguagensSelecionadas.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Deve ser selecionado ao menos uma linguagem")));
                        return;
                      }
                      if (tempoExperiencia == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Deve ter ao menos um ano de experiência em uma das linguagens")));
                        return;
                      }
                      if (salarioEscolhido == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "A pretenção salarial deve ser maior que 0")));
                        return;
                      }
                      setState(() {
                        salvando = true;
                      });
                      Future.delayed(const Duration(seconds: 3), () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Dados salvo com sucesso")));
                        setState(() {
                          salvando = false;
                        });
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("Salvar"),
                  ),
                ],
              ),
      ),
    );
  }
}
