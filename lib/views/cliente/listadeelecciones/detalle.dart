import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class DetallesEleccionScreen extends StatefulWidget {
  final int eleccionId;

  const DetallesEleccionScreen({Key? key, required this.eleccionId})
      : super(key: key);

  @override
  _DetallesEleccionScreenState createState() => _DetallesEleccionScreenState();
}

class _DetallesEleccionScreenState extends State<DetallesEleccionScreen> {
  final _supabase = Supabase.instance.client;
  late Future<Map<String, dynamic>> _eleccionFuture;
  late Future<List<Map<String, dynamic>>> _votantesFuture;
  late Future<List<Map<String, dynamic>>> _candidatosFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _eleccionFuture = _getEleccionDetalles();
    _votantesFuture = _getVotantes();
    _candidatosFuture = _getCandidatos();
  }

  Future<Map<String, dynamic>> _getEleccionDetalles() async {
    final response = await _supabase
        .from('elecciones')
        .select('*')
        .eq('id', widget.eleccionId)
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> _getVotantes() async {
    final response = await _supabase
        .from('votantes')
        .select('*')
        .eq('id_eleccion', widget.eleccionId)
        .order('apellido');
    return response;
  }

  Future<List<Map<String, dynamic>>> _getCandidatos() async {
    final response = await _supabase
        .from('candidatos')
        .select('*')
        .eq('id_eleccion', widget.eleccionId)
        .order('apellido');
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Detalles, Votantes, Candidatos
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalles Elección'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.info)),
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.how_to_vote)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pestaña 1: Detalles de la elección
            _buildDetallesTab(),
            // Pestaña 2: Lista de votantes
            _buildVotantesTab(),
            // Pestaña 3: Lista de candidatos
            _buildCandidatosTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetallesTab() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _eleccionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar detalles'));
        }

        final eleccion = snapshot.data!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Información General',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _buildInfoRow('ID Elección', eleccion['id'].toString()),
              _buildInfoRow('Estado', eleccion['estado']),
              _buildInfoRow('Edad Mínima', eleccion['edad_minima'].toString()),
              _buildInfoRow('Edad Máxima', eleccion['edad_maxima'].toString()),
              _buildInfoRow(
                  'Fecha Inicio',
                  DateFormat('dd/MM/yyyy HH:mm')
                      .format(DateTime.parse(eleccion['fecha_inicio']))),
              _buildInfoRow(
                  'Fecha Fin',
                  DateFormat('dd/MM/yyyy HH:mm')
                      .format(DateTime.parse(eleccion['fecha_fin']))),
              SizedBox(height: 24),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _votantesFuture,
                builder: (context, votantesSnapshot) {
                  final totalVotantes = votantesSnapshot.data?.length ?? 0;
                  return _buildInfoRow(
                      'Total Votantes', totalVotantes.toString());
                },
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _candidatosFuture,
                builder: (context, candidatosSnapshot) {
                  final totalCandidatos = candidatosSnapshot.data?.length ?? 0;
                  return _buildInfoRow(
                      'Total Candidatos', totalCandidatos.toString());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVotantesTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _votantesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar votantes'));
        }

        final votantes = snapshot.data!;

        if (votantes.isEmpty) {
          return Center(child: Text('No hay votantes registrados'));
        }

        return ListView.builder(
          itemCount: votantes.length,
          itemBuilder: (context, index) {
            final votante = votantes[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text('${votante['nombre']} ${votante['apellido']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${votante['id']}'),
                    Text('Teléfono: ${votante['telefono']}'),
                    Text('Residencia: ${votante['residencia']}'),
                  ],
                ),
                leading: Icon(Icons.person),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCandidatosTab() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _candidatosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error al cargar candidatos'));
        }

        final candidatos = snapshot.data!;

        if (candidatos.isEmpty) {
          return Center(child: Text('No hay candidatos registrados'));
        }

        return ListView.builder(
          itemCount: candidatos.length,
          itemBuilder: (context, index) {
            final candidato = candidatos[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text('${candidato['nombre']} ${candidato['apellido']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${candidato['id']}'),
                    Text('Teléfono: ${candidato['telefono']}'),
                    Text('Nacionalidad: ${candidato['nacionalidad']}'),
                  ],
                ),
                leading: Icon(Icons.star, color: Colors.amber),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
