//calendar.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
//MODELS
import '../models/horario.dart';
//DATABASE
import '../database/database_service.dart';
//COMPONENTS
import '../components/class_box.dart';
import '../components/navigation_bar.dart';
//FUNCTIONS
import '../functions.dart';
//VARIABLES
import '../variables/colors.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  // Map<DateTime, List<Horario>> para o TableCalendar
  Map<DateTime, List<Horario>> aulas = {};
  CalendarFormat _calendarFormat =
      CalendarFormat.month; //Formato inicial do calendário
  DateTime _diaSelecionado = DateTime.now(); // Dia atualmente selecionado
  List<Horario> _horariosDoDia = []; // Lista de aulas do dia selecionado

  @override
  void initState() {
    super.initState();
    // Carrega horários do banco
    DataBaseService().obterHorarios().then((horarios) {
      carregarAulas(horarios);
      // Inicialmente mostra os horários do dia atual
      selecionarDia(_diaSelecionado);
    });
  }

  // Converte lista de Horarios para o Map<DateTime, List<Horario>>
  void carregarAulas(List<Horario> horarios) {
    aulas = {}; // limpa antes

    for (var horario in horarios) {
      DateTime dia = removerHora(DateFormat('dd-MM-yyyy').parse(horario.data));

      if (!aulas.containsKey(dia)) {
        aulas[dia] = [];
      }
      aulas[dia]!.add(horario);
    }

    print("Aulas carregadas:");
    aulas.forEach((d, lista) {
      print("Dia $d -> ${lista.length} aulas");
    });

    setState(() {});
  }

  // Seleciona um dia e atualiza a lista de aulas
  void selecionarDia(DateTime dia) {
    final DateTime diaSemHora = removerHora(dia);
    print("Selecionar dia: $diaSemHora");

    setState(() {
      _diaSelecionado = diaSemHora;
      _horariosDoDia = aulas[diaSemHora] ?? [];
      print("Aulas carregadas: ${_horariosDoDia.length}");
      for (var h in _horariosDoDia) {
        print("  -> ${h.data}  ${h.sala}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    //TEXTO
    double tamanhoTexto = comprimento * 0.04;
    double tamanhoTitulo = comprimento * 0.05;
    double tamanhoSubTexto = tamanhoTexto * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário de Aulas', style: TextStyle(color: corTexto)),
        centerTitle: true,
        backgroundColor: corPrimaria,
      ),
      body: Column(
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(
              //HEADER DO CALENDÁRIO
              titleTextStyle: TextStyle(
                color: corTexto,
                fontSize: tamanhoTitulo,
                fontWeight: FontWeight.bold,
              ),
              formatButtonVisible: false, //Esconde o botão do formato
              leftChevronIcon: Icon(Icons.chevron_left, color: corTexto), //Seta Esquerda
              rightChevronIcon: Icon(Icons.chevron_right, color: corTexto), //Seta DIreita
            ),
            firstDay: DateTime(2025, 1, 1),
            lastDay: DateTime(2125, 1, 1),
            focusedDay: _diaSelecionado,
            calendarFormat: _calendarFormat,
            eventLoader: (dia) => aulas[removerHora(dia)] ?? [],
            locale: 'pt_BR', // Defina o idioma como português (Brasil) aqui
            calendarStyle: CalendarStyle(
              todayDecoration:
                  BoxDecoration(color: corSecundaria, shape: BoxShape.circle),
              markerDecoration:
                  BoxDecoration(color: corTexto, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                color: corTerciaria,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: corTexto,
                fontWeight: FontWeight.bold,
              ),
              //weekendTextStyle: TextStyle(color: corDestaque), // Cor dos finais de semana
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  color: corTerciaria), //Cor dos dias úteis (segunda a sexta)
              weekendStyle: TextStyle(
                  color:
                      corTerciaria), //Cor dos finais de semana (sábado e domingo)
            ),
            selectedDayPredicate: (day) {
              //Necessário para o TableCalendar reconhecer o dia selecionado
              return removerHora(day) == removerHora(_diaSelecionado);
            },
            onDaySelected: (selectedDay, focusedDay) {
              selecionarDia(selectedDay);
            },
          ),

          const SizedBox(height: 16),

          // Mostra o título do dia selecionado
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Aulas de ${DateFormat('dd/MM/yyyy').format(_diaSelecionado)}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: corTexto),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Lista de aulas do dia selecionado
          Expanded(
            child: _horariosDoDia.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma aula neste dia',
                      style: TextStyle(color: corTexto),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _horariosDoDia.length,
                    itemBuilder: (context, index) {
                      Horario h = _horariosDoDia[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ClassBox(horario: h),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 0),
    );
  }
}
