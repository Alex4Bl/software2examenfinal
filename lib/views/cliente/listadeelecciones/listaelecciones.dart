import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyectofinalsoftware/views/cliente/listadeelecciones/detalle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ListaEleccionesTab extends StatefulWidget {
  @override
  _ListaEleccionesTabState createState() => _ListaEleccionesTabState();
}

class _ListaEleccionesTabState extends State<ListaEleccionesTab> {
  final _supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _eleccionesFuture;

  @override
  void initState() {
    super.initState();
    _eleccionesFuture = _fetchElecciones();
  }

  Future<List<Map<String, dynamic>>> _fetchElecciones() async {
    final response = await _supabase
        .from('elecciones')
        .select('*')
        .order('fecha_inicio', ascending: false);

    if (response.isEmpty) return [];

    // Usar Future.wait para manejar operaciones asíncronas en el mapeo
    return await Future.wait(response.map((eleccion) async {
      // Nota el async aquí
      return {
        'id': eleccion['id'],
        'titulo': 'Elección ${eleccion['id']}',
        'fecha': DateFormat('dd/MM/yyyy').format(
          DateTime.parse(eleccion['fecha_inicio']),
        ),
        'estado': eleccion['estado'],
        'participantes': await _getParticipantesCount(eleccion['id']),
      };
    }).toList());
  }

  Future<int> _getParticipantesCount(int eleccionId) async {
    final response =
        await _supabase.from('votantes').select().eq('id_eleccion', eleccionId);

    return response.length;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _eleccionesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar elecciones'));
        }

        final elecciones = snapshot.data ?? [];

        if (elecciones.isEmpty) {
          return Center(child: Text('No hay elecciones creadas'));
        }

        return ListView.builder(
          itemCount: elecciones.length,
          itemBuilder: (context, index) {
            final eleccion = elecciones[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: Icon(Icons.how_to_vote, color: Colors.blue),
                title: Text(eleccion['titulo']),
                subtitle: Text(
                  'Fecha: ${eleccion['fecha']} - ${eleccion['participantes']} participantes',
                ),
                trailing: Chip(
                  label: Text(eleccion['estado']),
                  backgroundColor: _getEstadoColor(eleccion['estado']),
                ),
                onTap: () => _verDetallesEleccion(context, eleccion['id']),
              ),
            );
          },
        );
      },
    );
  }

  Color? _getEstadoColor(String estado) {
    switch (estado) {
      case 'Activa':
        return Colors.green[100];
      case 'Pendiente':
        return Colors.orange[100];
      case 'Finalizada':
        return Colors.grey[200];
      default:
        return Colors.grey[200];
    }
  }

  void _verDetallesEleccion(BuildContext context, int eleccionId) {
    // Navegar a pantalla de detalles
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesEleccionScreen(eleccionId: eleccionId),
      ),
    );
  }
}
