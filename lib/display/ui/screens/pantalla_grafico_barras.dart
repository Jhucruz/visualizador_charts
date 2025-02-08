import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visualizador_charts/data/models/bar_model.dart';
import 'package:visualizador_charts/data/repositories/bar_repository.dart';
import 'package:visualizador_charts/display/ui/components/input_grafico.dart';

class PantallaGraficoBarras extends StatefulWidget {
  const PantallaGraficoBarras({super.key});

  @override
  State<PantallaGraficoBarras> createState() => _PantallaGraficoBarrasState();
}

class _PantallaGraficoBarrasState extends State<PantallaGraficoBarras> {
  final _ejeXTextEditingController = TextEditingController();
  final _ejeYTextEditingController = TextEditingController();
  final _idFormulario = GlobalKey<FormState>();

  final _ejeXEtiquetas = ['text 1', 'text 2'];

  BarModel? _barModel;

  @override
  void initState() {
    super.initState();
    setState(() {
      _barModel = barRepository.obtenerDatosBarras();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_barModel == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de barras'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        print(value);
                        return Text(_ejeXEtiquetas[value.toInt()]);
                      },
                    ),
                  ),
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(toY: 10, color: Colors.red),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(toY: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Form(
            key: _idFormulario,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 8,
                children: [
                  InputGrafico(
                    controller: _ejeXTextEditingController,
                    label: 'Dato eje X',
                    autocorrect: false,
                    textInputType: TextInputType.text,
                    validator: (valor) {
                      if (valor == null) {
                        return 'Este campo es requerido';
                      }

                      if (valor.isEmpty) {
                        return 'Este campo es requerido';
                      }

                      return null;
                    },
                  ),
                  InputGrafico(
                    controller: _ejeYTextEditingController,
                    label: 'Dato eje Y',
                    autocorrect: false,
                    textInputType: TextInputType.number,
                    validator: (valor) {
                      if (valor == null) {
                        return 'Este campo es requerido';
                      }

                      if (valor.isEmpty) {
                        return 'Este campo es requerido';
                      }

                      if (double.tryParse(valor) == null) {
                        return 'Este campo debe ser un número';
                      }

                      return null;
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final esValiado = _idFormulario.currentState?.validate();
                      final barModel = _barModel;

                      if (esValiado == true && barModel != null) {
                        barModel.ejeX.add(_ejeXTextEditingController.text);
                        barModel.ejeY
                            .add(double.parse(_ejeYTextEditingController.text));

                        barRepository.guardarBarrasDatos(barModel);
                      }
                    },
                    label: const Text('Agregar'),
                    icon: Icon(Icons.add),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _mostrarAlertaDeConfirmacion(context);
                    },
                    label: const Text('Borrar último'),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _mostrarAlertaDeConfirmacion(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: const Text('¿Seguro que quiere borrar?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Volver'),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Borrar'),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
