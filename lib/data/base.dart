// models/votante_model.dart
import 'package:flutter/material.dart';

class Votante {
  final String id;
  final String nombre;
  final String apellido;
  final String nacionalidad;
  final String residencia;
  final String telefono;

  Votante({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.nacionalidad,
    required this.residencia,
    required this.telefono,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'nacionalidad': nacionalidad,
      'residencia': residencia,
      'telefono': telefono,
    };
  }
}

// models/eleccion_model.dart
class Eleccion {
  final String id;
  final int edadMinima;
  final int edadMaxima;
  final bool esperaResultados;
  final String estado;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final TimeOfDay horaInicio;
  final TimeOfDay horaFin;

  Eleccion({
    required this.id,
    required this.edadMinima,
    required this.edadMaxima,
    required this.esperaResultados,
    required this.estado,
    required this.fechaInicio,
    required this.fechaFin,
    required this.horaInicio,
    required this.horaFin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'edadMinima': edadMinima,
      'edadMaxima': edadMaxima,
      'esperaResultados': esperaResultados,
      'estado': estado,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'horaInicio': '${horaInicio.hour}:${horaInicio.minute}',
      'horaFin': '${horaFin.hour}:${horaFin.minute}',
    };
  }
}

// models/candidato_model.dart
class Candidato {
  final String id;
  final String nombre;
  final String apellido;
  final String nacionalidad;
  final String residencia;
  final String telefono;

  Candidato({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.nacionalidad,
    required this.residencia,
    required this.telefono,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'nacionalidad': nacionalidad,
      'residencia': residencia,
      'telefono': telefono,
    };
  }
}
