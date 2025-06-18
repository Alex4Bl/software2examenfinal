import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    //  ElectionManagementScreen(),
    //CandidateManagementScreen(),
    // VoterManagementScreen(),
    // ReportsScreen(),
    // SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _createNewElection(context),
            )
          : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Administrador'),
            accountEmail: Text('admin@votaciones.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.admin_panel_settings, size: 40),
            ),
            decoration: BoxDecoration(
              color: Colors.blue[800],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(Icons.how_to_vote, 'Gestión de Elecciones', 0),
                _buildDrawerItem(Icons.people, 'Gestión de Candidatos', 1),
                _buildDrawerItem(
                    Icons.supervised_user_circle, 'Gestión de Votantes', 2),
                _buildDrawerItem(Icons.bar_chart, 'Reportes y Estadísticas', 3),
                _buildDrawerItem(
                    Icons.settings, 'Configuración del Sistema', 4),
                Divider(),
                _buildDrawerItem(Icons.help, 'Ayuda y Soporte', 5),
                _buildDrawerItem(Icons.info, 'Acerca de', 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: _selectedIndex == index && index < 5,
      onTap: () {
        if (index < 5) {
          _onItemTapped(index);
        } else {
          // Manejar otras opciones
        }
        Navigator.pop(context);
      },
    );
  }

  void _createNewElection(BuildContext context) {}

  void _logout() async {
    // Lógica para cerrar sesión
    Navigator.pushReplacementNamed(context, '/login');
  }
}
