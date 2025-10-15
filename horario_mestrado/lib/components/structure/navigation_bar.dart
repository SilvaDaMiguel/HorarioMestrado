import 'package:flutter/material.dart';
//VARIABLES
import '../../variables/colors.dart';

class MyNavigationBar extends StatefulWidget {
  final bool mostrarSelecionado;
  final int IconSelecionado;

  const MyNavigationBar(
      {Key? key, this.mostrarSelecionado = true, this.IconSelecionado = 0})
      : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.IconSelecionado;
  }

  void _onItemTapped(int index) {
    if (index != selectedIndex || !widget.mostrarSelecionado) {
      setState(() {
        selectedIndex = index;
      });
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/calendar');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/subjects');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/periods');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/classes');
          break;
        default:
          Navigator.pushReplacementNamed(context, '/error');
          break;
      }
    }
  }

  Widget _buildIcon(IconData icon, bool isSelected) {
    return Container(
      decoration: (isSelected && widget.mostrarSelecionado)
          ? BoxDecoration(
              color: corTerciaria,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10),
            )
          : null,
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon,
        color:
            (isSelected && widget.mostrarSelecionado) ? corTexto : corTerciaria,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: corSecundaria, //Cor da borda
            width: 2.5, // Largura da borda
          ),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: corPrimaria, //Cor do Fundo
        key: const Key('bottom_navigation_bar'),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.calendar_month, selectedIndex == 0),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.laptop, selectedIndex == 1),
            label: 'Cadeiras',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.timer, selectedIndex == 2),
            label: 'Períodos',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.school, selectedIndex == 3),
            label: 'Aulas',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: widget.mostrarSelecionado ? corTexto : corTerciaria, //Texto Selecionado
        unselectedItemColor: corTerciaria, //Restante Textos
        onTap: _onItemTapped,
      ),
    );
  }
}
