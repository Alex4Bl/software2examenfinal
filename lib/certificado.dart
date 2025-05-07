import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class CertificadoScreen extends StatelessWidget {
  // Variables para el certificado
  final String nombre;
  final String apellido;
  final String recinto;
  final String fecha;
  final String ci;

  // Constructor para recibir los datos
  CertificadoScreen({
    required this.nombre,
    required this.apellido,
    required this.recinto,
    required this.fecha,
    required this.ci,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificado de Votación'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen del certificado (opcional)
              /* Image.asset(
                'assets/certificate.png', // Asegúrate de tener esta imagen en assets
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Certificado de Votación',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),*/
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
                        '¡Felicidades $nombre $apellido!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Has participado en la votación electrónica.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Recinto: $recinto\nFecha: $fecha\nC.I: $ci',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          // Generar el PDF
                          generatePDF();
                        },
                        child: Text('Generar Certificado PDF',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para generar el PDF
  Future<void> generatePDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('Certificado de Votación',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('¡Felicidades $nombre $apellido!',
                    style: pw.TextStyle(fontSize: 18)),
                pw.SizedBox(height: 10),
                pw.Text('Has participado en la votación electrónica.',
                    style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 10),
                pw.Text('Recinto: $recinto', style: pw.TextStyle(fontSize: 16)),
                pw.Text('Fecha: $fecha', style: pw.TextStyle(fontSize: 16)),
                pw.Text('C.I: $ci', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );

    // Mostrar el PDF en pantalla
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
