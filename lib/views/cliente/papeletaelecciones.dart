// Pestaña de Papeletas
import 'package:flutter/material.dart';

class PapeletasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.how_to_vote, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Gestión de Papeletas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Aquí podrás gestionar las papeletas de votación',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Acción para gestionar papeletas
            },
            child: Text('Gestionar Papeletas'),
          ),
        ],
      ),
    );
  }
}
