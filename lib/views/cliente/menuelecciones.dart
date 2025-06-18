import 'package:flutter/material.dart';
import 'package:proyectofinalsoftware/views/authenticacion.dart';
import 'package:proyectofinalsoftware/views/cliente/crearelecciones.dart';
import 'package:proyectofinalsoftware/views/cliente/listadeelecciones/listaelecciones.dart';
import 'package:proyectofinalsoftware/views/cliente/papeletaelecciones.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminEleccionesScreen extends StatefulWidget {
  final String? userName;
  final String? userEmail;

  const AdminEleccionesScreen({
    Key? key,
    this.userName,
    this.userEmail,
  }) : super(key: key);

  @override
  _AdminEleccionesScreenState createState() => _AdminEleccionesScreenState();
}

class _AdminEleccionesScreenState extends State<AdminEleccionesScreen> {
  int _selectedIndex = 0;
  final GlobalKey _avatarKey = GlobalKey();
  final _supabase = Supabase.instance.client;
  Map<String, dynamic> _userData = {
    'nombre': 'Usuario',
    'email': 'email@ejemplo.com'
  };

  @override
  void initState() {
    super.initState();

    if (widget.userName != null && widget.userEmail != null) {
      _userData = {
        'nombre': widget.userName!,
        'email': widget.userEmail!,
      };
    } else {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final response = await _supabase
            .from('usuarios')
            .select('nombre, email')
            .eq('id', user.id)
            .single();

        setState(() {
          _userData = response;
        });
      }
    } catch (e) {
      print('Error cargando datos de usuario: $e');
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    ListaEleccionesTab(),
    CrearEleccionScreen(),
    PapeletasTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showUserMenu(BuildContext context) {
    final RenderBox renderBox =
        _avatarKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + renderBox.size.height + 8,
        position.dx + renderBox.size.width,
        position.dy + renderBox.size.height + 200,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 12,
      items: [
        PopupMenuItem<String>(
          height: 60,
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _userData['nombre'] ?? 'Usuario',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                _userData['email'] ?? 'email@ejemplo.com',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        PopupMenuDivider(height: 8),
        PopupMenuItem<String>(
          value: 'profile',
          child: _buildMenuItem(Icons.person, 'Mi perfil'),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: _buildMenuItem(Icons.settings, 'Configuración'),
        ),
        PopupMenuItem<String>(
          value: 'help',
          child: _buildMenuItem(Icons.help_outline, 'Ayuda'),
        ),
        PopupMenuDivider(height: 8),
        PopupMenuItem<String>(
          value: 'logout',
          child: _buildMenuItem(Icons.exit_to_app, 'Cerrar sesión',
              iconColor: Colors.red, textColor: Colors.red),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'logout':
            _logout(context);
            break;
        }
      }
    });
  }

  Widget _buildMenuItem(IconData icon, String text,
      {Color? iconColor, Color? textColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor ?? Colors.black87),
        SizedBox(width: 10),
        Text(text,
            style: TextStyle(fontSize: 14, color: textColor ?? Colors.black87)),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _supabase.auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel Administrativo',
            style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 4,
        actions: [
          /*   IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),*/
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              key: _avatarKey,
              onTap: () => _showUserMenu(context),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Text(
                  _userData['nombre']?.isNotEmpty == true
                      ? _userData['nombre'][0].toUpperCase()
                      : 'U',
                  style: TextStyle(color: Colors.blue[800]),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Crear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: 'Papeleta',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
      ),
    );
  }
}
