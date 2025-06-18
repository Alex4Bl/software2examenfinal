import 'package:flutter/material.dart';
import 'package:proyectofinalsoftware/grafico.dart';
import 'package:proyectofinalsoftware/certificado.dart'; // Asegúrate de importar la pantalla del certificado

class indexusuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Votación Electrónica',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.white),
            tooltip: 'Mostrar Estadísticas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PieChartSample2()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.assignment,
                color: Colors.white), // Icono para el certificado
            tooltip: 'Ver Certificado',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CertificadoScreen(
                          apellido: 'asad',
                          ci: '454500',
                          fecha: '33/3/2323',
                          nombre: 'ASDAD',
                          recinto: 'asdasd',
                        )), // Pantalla del certificado
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/vote.png'), // Asegúrate de agregar esta imagen en assets
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '¡Bienvenido a la votación electrónica!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        // Acción para votar
                      },
                      child: Text('Ir a Votar',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
