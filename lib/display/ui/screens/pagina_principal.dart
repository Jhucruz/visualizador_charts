import 'package:flutter/material.dart';
import 'package:visualizador_charts/display/routes/routes.dart';
import 'package:visualizador_charts/display/ui/components/tile_de_graficos.dart';

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizador de Graficos'),
      ),
      body: ListView(
        children: [
          TileDeGraficos(
            titulo: 'Grafico de Barras  ',
            alPresionar: () {
              Navigator.pushNamed(context, Routes.graficoBarras);
            },
          ),
          TileDeGraficos(
            titulo: 'Grafico de Lieas ',
            alPresionar: () {
              Navigator.pushNamed(context, Routes.graficoLineas);
            },
          ),
          TileDeGraficos(
            titulo: 'Graficos de Torta',
            alPresionar: () {
              Navigator.pushNamed(context, Routes.graficoPies);
            },
          ),
        ],
      ),
    );
  }
}
