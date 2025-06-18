// views/cliente/crear_eleccion_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyectofinalsoftware/data/base.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CrearEleccionScreen extends StatefulWidget {
  @override
  _CrearEleccionScreenState createState() => _CrearEleccionScreenState();
}

class _CrearEleccionScreenState extends State<CrearEleccionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _votantes = <Votante>[];
  final _candidatos = <Candidato>[];
  final _supabase = Supabase.instance.client;

  // Datos de la elección
  String _idEleccion = '';
  int _edadMinima = 18;
  int _edadMaxima = 100;
  bool _esperaResultados = false;
  String _estado = 'Pendiente';
  DateTime _fechaInicio = DateTime.now();
  DateTime _fechaFin = DateTime.now().add(Duration(days: 7));
  TimeOfDay _horaInicio = TimeOfDay.now();
  TimeOfDay _horaFin = TimeOfDay(hour: 23, minute: 59);

  // Controladores para votantes
  final _votanteIdController = TextEditingController();
  final _votanteNombreController = TextEditingController();
  final _votanteApellidoController = TextEditingController();
  final _votanteNacionalidadController = TextEditingController();
  final _votanteResidenciaController = TextEditingController();
  final _votanteTelefonoController = TextEditingController();

  // Controladores para candidatos
  final _candidatoIdController = TextEditingController();
  final _candidatoNombreController = TextEditingController();
  final _candidatoApellidoController = TextEditingController();
  final _candidatoNacionalidadController = TextEditingController();
  final _candidatoResidenciaController = TextEditingController();
  final _candidatoTelefonoController = TextEditingController();

  @override
  void dispose() {
    _votanteIdController.dispose();
    _votanteNombreController.dispose();
    _votanteApellidoController.dispose();
    _votanteNacionalidadController.dispose();
    _votanteResidenciaController.dispose();
    _votanteTelefonoController.dispose();
    _candidatoIdController.dispose();
    _candidatoNombreController.dispose();
    _candidatoApellidoController.dispose();
    _candidatoNacionalidadController.dispose();
    _candidatoResidenciaController.dispose();
    _candidatoTelefonoController.dispose();
    super.dispose();
  }

  void _agregarVotante() {
    final votante = Votante(
      id: _votanteIdController.text,
      nombre: _votanteNombreController.text,
      apellido: _votanteApellidoController.text,
      nacionalidad: _votanteNacionalidadController.text,
      residencia: _votanteResidenciaController.text,
      telefono: _votanteTelefonoController.text,
    );

    setState(() {
      _votantes.add(votante);
      // Limpiar campos
      _votanteIdController.clear();
      _votanteNombreController.clear();
      _votanteApellidoController.clear();
      _votanteNacionalidadController.clear();
      _votanteResidenciaController.clear();
      _votanteTelefonoController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Votante agregado correctamente')),
    );
  }

  void _agregarCandidato() {
    final candidato = Candidato(
      id: _candidatoIdController.text,
      nombre: _candidatoNombreController.text,
      apellido: _candidatoApellidoController.text,
      nacionalidad: _candidatoNacionalidadController.text,
      residencia: _candidatoResidenciaController.text,
      telefono: _candidatoTelefonoController.text,
    );

    setState(() {
      _candidatos.add(candidato);
      // Limpiar campos
      _candidatoIdController.clear();
      _candidatoNombreController.clear();
      _candidatoApellidoController.clear();
      _candidatoNacionalidadController.clear();
      _candidatoResidenciaController.clear();
      _candidatoTelefonoController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Candidato agregado correctamente')),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isInicio) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isInicio ? _fechaInicio : _fechaFin,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isInicio) {
          _fechaInicio = picked;
        } else {
          _fechaFin = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isInicio) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isInicio ? _horaInicio : _horaFin,
    );
    if (picked != null) {
      setState(() {
        if (isInicio) {
          _horaInicio = picked;
        } else {
          _horaFin = picked;
        }
      });
    }
  }

  Future<void> _crearEleccion() async {
    if (_formKey.currentState!.validate()) {
      try {
        // 1. Crear la elección en Supabase
        final eleccionData = {
          'id': _idEleccion,
          'edad_minima': _edadMinima,
          'edad_maxima': _edadMaxima,
          'espera_resultados': _esperaResultados,
          'estado': _estado,
          'fecha_inicio': _fechaInicio.toIso8601String(),
          'fecha_fin': _fechaFin.toIso8601String(),
          'hora_inicio': '${_horaInicio.hour}:${_horaInicio.minute}',
          'hora_fin': '${_horaFin.hour}:${_horaFin.minute}',
          'creado_en': DateTime.now().toIso8601String(),
        };

        // Versión actualizada - sin .execute()
        await _supabase.from('elecciones').insert(eleccionData);

        // 2. Insertar votantes en lote
        if (_votantes.isNotEmpty) {
          final votantesData = _votantes
              .map((v) => {
                    'id': v.id,
                    'nombre': v.nombre,
                    'apellido': v.apellido,
                    'nacionalidad': v.nacionalidad,
                    'residencia': v.residencia,
                    'telefono': v.telefono,
                    'id_eleccion': _idEleccion,
                  })
              .toList();

          await _supabase.from('votantes').insert(votantesData);
        }

        // 3. Insertar candidatos en lote
        if (_candidatos.isNotEmpty) {
          final candidatosData = _candidatos
              .map((c) => {
                    'id': c.id,
                    'nombre': c.nombre,
                    'apellido': c.apellido,
                    'nacionalidad': c.nacionalidad,
                    'residencia': c.residencia,
                    'telefono': c.telefono,
                    'id_eleccion': _idEleccion,
                  })
              .toList();

          await _supabase.from('candidatos').insert(candidatosData);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Elección creada exitosamente en Supabase')),
        );

        // Limpiar el formulario
        _formKey.currentState?.reset();
        setState(() {
          _votantes.clear();
          _candidatos.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear elección: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nueva Elección'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de información de la elección
              Text('Información de la Elección',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'ID de la Elección'),
                validator: (value) =>
                    value!.isEmpty ? 'Este campo es requerido' : null,
                onChanged: (value) => _idEleccion = value,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Edad Mínima'),
                      keyboardType: TextInputType.number,
                      initialValue: _edadMinima.toString(),
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es requerido' : null,
                      onChanged: (value) =>
                          _edadMinima = int.tryParse(value) ?? 18,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Edad Máxima'),
                      keyboardType: TextInputType.number,
                      initialValue: _edadMaxima.toString(),
                      validator: (value) =>
                          value!.isEmpty ? 'Este campo es requerido' : null,
                      onChanged: (value) =>
                          _edadMaxima = int.tryParse(value) ?? 100,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text('Esperar resultados automáticamente'),
                value: _esperaResultados,
                onChanged: (value) => setState(() => _esperaResultados = value),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _estado,
                decoration: InputDecoration(labelText: 'Estado'),
                items: ['Pendiente', 'En curso', 'Finalizada', 'Cancelada']
                    .map((estado) => DropdownMenuItem(
                          value: estado,
                          child: Text(estado),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _estado = value!),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration:
                            InputDecoration(labelText: 'Fecha de Inicio'),
                        child:
                            Text(DateFormat('dd/MM/yyyy').format(_fechaInicio)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, true),
                      child: InputDecorator(
                        decoration:
                            InputDecoration(labelText: 'Hora de Inicio'),
                        child: Text(_horaInicio.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(labelText: 'Fecha de Fin'),
                        child: Text(DateFormat('dd/MM/yyyy').format(_fechaFin)),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context, false),
                      child: InputDecorator(
                        decoration: InputDecoration(labelText: 'Hora de Fin'),
                        child: Text(_horaFin.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 40),

              // Sección para agregar votantes
              Text('Agregar Votantes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextFormField(
                controller: _votanteIdController,
                decoration: InputDecoration(labelText: 'ID del Votante'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _votanteNombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _votanteApellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _votanteNacionalidadController,
                decoration: InputDecoration(labelText: 'Nacionalidad'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _votanteResidenciaController,
                decoration: InputDecoration(labelText: 'Residencia'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _votanteTelefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _agregarVotante,
                child: Text('Agregar Votante'),
              ),
              SizedBox(height: 16),
              if (_votantes.isNotEmpty) ...[
                Text('Votantes Registrados (${_votantes.length})',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ..._votantes.map((votante) => ListTile(
                      title: Text('${votante.nombre} ${votante.apellido}'),
                      subtitle: Text(votante.id),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            setState(() => _votantes.remove(votante)),
                      ),
                    )),
              ],
              Divider(height: 40),

              // Sección para agregar candidatos
              Text('Agregar Candidatos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextFormField(
                controller: _candidatoIdController,
                decoration: InputDecoration(labelText: 'ID del Candidato'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _candidatoNombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _candidatoApellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _candidatoNacionalidadController,
                decoration: InputDecoration(labelText: 'Nacionalidad'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _candidatoResidenciaController,
                decoration: InputDecoration(labelText: 'Residencia'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _candidatoTelefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _agregarCandidato,
                child: Text('Agregar Candidato'),
              ),
              SizedBox(height: 16),
              if (_candidatos.isNotEmpty) ...[
                Text('Candidatos Registrados (${_candidatos.length})',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                ..._candidatos.map((candidato) => ListTile(
                      title: Text('${candidato.nombre} ${candidato.apellido}'),
                      subtitle: Text(candidato.id),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            setState(() => _candidatos.remove(candidato)),
                      ),
                    )),
              ],
              Divider(height: 40),

              // Botón para crear la elección
              Center(
                child: ElevatedButton(
                  onPressed: _crearEleccion,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child:
                        Text('Crear Elección', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
