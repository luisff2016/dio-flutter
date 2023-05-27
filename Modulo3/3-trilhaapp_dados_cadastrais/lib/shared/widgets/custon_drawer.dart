import 'package:flutter/material.dart';

import '../../pages/dados_cadastrais.dart';

class CustonDrawer extends StatelessWidget {
  const CustonDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          InkWell(
            child: Row(
              children: [
                const Icon(Icons.person),
                Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    width: double.infinity,
                    child: const Text("Dados cadastráis")),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DadosCadastraisPage()));
            },
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                width: double.infinity,
                child: const Text("Termos de uso e privacidade")),
            onTap: () {},
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                width: double.infinity,
                child: const Text("Configurações")),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
