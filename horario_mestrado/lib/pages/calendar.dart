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
//FUNCTIONS
import '../functions.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  // Map<DateTime, List<Horario>> para o TableCalendar
  Map<DateTime, List<Horario>> eventos = {};
  CalendarFormat _calendarFormat =
      CalendarFormat.month; //Formato inicial do calendário
  DateTime _diaSelecionado = DateTime.now(); // Dia atualmente selecionado
  List<Horario> _horariosDoDia = []; // Lista de aulas do dia selecionado

  @override
  void initState() {
    super.initState();
    // Carrega horários do banco
    DataBaseService().obterHorarios().then((horarios) {
      carregarEventos(horarios);
      // Inicialmente exibe os horários do dia atual
      selecionarDia(_diaSelecionado);
    });
  }

  // Converte lista de Horarios para o Map<DateTime, List<Horario>>
  void carregarEventos(List<Horario> horarios) {
    eventos = {}; // limpa antes
    for (var horario in horarios) {
      DateTime dia = removerHora(DateFormat("dd-MM-yyyy").parse(horario.data));
      if (eventos[dia] == null) {
        eventos[dia] = [];
      }
      eventos[dia]!.add(horario);
    }
    setState(() {});
  }

  // Seleciona um dia e atualiza a lista de aulas
  void selecionarDia(DateTime dia) {
    _diaSelecionado = dia;
    _horariosDoDia = eventos[removerHora(dia)] ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário de Aulas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2025, 1, 1),
            lastDay: DateTime(2125, 1, 1),
            focusedDay: _diaSelecionado,
            calendarFormat: _calendarFormat,
            eventLoader: (dia) => eventos[removerHora(dia)] ?? [],
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              markerDecoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 184, 224),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                  "Aulas de ${DateFormat('dd/MM/yyyy').format(_diaSelecionado)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Lista de aulas do dia selecionado
          Expanded(
            child: _horariosDoDia.isEmpty
                ? const Center(child: Text("Nenhuma aula neste dia"))
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
    );
  }
}
