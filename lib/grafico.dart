import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinalsoftware/resources/color.dart';
import 'package:proyectofinalsoftware/widget/indicador.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  // Lista de participantes, donde cada índice representa una sección
  List<int> participants = [
    40,
    30,
    40,
    30,
    40,
    30,
    40,
    30,
    40,
    30,
  ]; // Puedes cambiar los valores para reflejar los datos reales.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Votación Electrónica',
              style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.deepPurple,
        ),
        body: AspectRatio(
          aspectRatio: 1.3,
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              // Indicadores dinámicos con colores distintos
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(participants.length, (index) {
                  return Column(
                    children: [
                      Indicator(
                        color: getColorForIndex(
                            index), // Cambiar el color dinámicamente
                        text: 'Sección ${index + 1}',
                        isSquare: true,
                      ),
                      SizedBox(height: 4),
                    ],
                  );
                }),
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ));
  }

  // Función que genera dinámicamente las secciones del gráfico
  List<PieChartSectionData> showingSections() {
    double totalParticipants = participants.reduce((a, b) => a + b).toDouble();

    return List.generate(participants.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      double sectionValue = (participants[i] / totalParticipants) *
          100; // Cálculo dinámico del porcentaje

      return PieChartSectionData(
        color: getColorForIndex(i), // Cambia el color para cada sección
        value: sectionValue,
        title: '${sectionValue.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.mainTextColor1,
          shadows: shadows,
        ),
      );
    });
  }

  // Método que devuelve un color para cada sección (puedes cambiarlo según tus necesidades)
  Color getColorForIndex(int index) {
    final Random random =
        Random(index); // Asegura variabilidad pero consistencia en los colores
    return Color.fromRGBO(
      random.nextInt(256), // Rojo
      random.nextInt(256), // Verde
      random.nextInt(256), // Azul
      1, // Opacidad al 100%
    );
  }
}
