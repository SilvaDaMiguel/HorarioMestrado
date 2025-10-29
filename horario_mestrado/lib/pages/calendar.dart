//calendar.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
//MODELS
import '../models/aula.dart';
//DATABASE
import '../database/database_service.dart';
//COMPONENTS
import '../components/today_class_box.dart';
import '../components/structure/navigation_bar.dart';
import '../components/structure/app_bar.dart';
//FUNCTIONS
import '../functions.dart';
//VARIABLES
import '../variables/colors.dart';
import '../variables/size.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  //Map<DateTime, List<Aula>> para o TableCalendar
  Map<DateTime, List<Aula>> listaAulas = {};
  CalendarFormat _calendarFormat =
      CalendarFormat.month; //Formato inicial do calendário
  DateTime _diaSelecionado = DateTime.now(); // Dia atualmente selecionado
  List<Aula> _aulasDoDia = []; // Lista de listaAulas do dia selecionado

  @override
  void initState() {
    super.initState();
    //Carrega horários da base de dados
    DataBaseService().obterAulas().then((aulas) {
      carregarAulas(aulas);
      //Inicialmente mostra os horários do dia atual
      selecionarDia(_diaSelecionado);
    });
  }

  //Converte lista de Aulas para o Map<DateTime, List<Aula>>
  void carregarAulas(List<Aula> aulas) {
    listaAulas = {}; // limpa antes

    for (var aula in aulas) {
      //DateTime dia = removerHora(DateFormat('dd-MM-yyyy').parse(aula.data));
      DateTime dia = removerHora(stringDDMMYYYYParaDateTime(aula.data)!);

      if (!listaAulas.containsKey(dia)) {
        listaAulas[dia] = [];
      }
      listaAulas[dia]!.add(aula);
    }

    /*
    print("Aulas carregadas:");
    listaAulas.forEach((d, lista) {
      print("Dia $d -> ${lista.length} listaAulas");
    });*/

    setState(() {});
  }

  //Seleciona um dia e atualiza a lista de listaAulas
  void selecionarDia(DateTime dia) {
    final DateTime diaSemHora = removerHora(dia);
    //print("Selecionar dia: $diaSemHora");

    setState(() {
      _diaSelecionado = diaSemHora;
      _aulasDoDia = listaAulas[diaSemHora] ?? [];
      /*
      print("Aulas carregadas: ${_aulasDoDia.length}");
      for (var a in _aulasDoDia) {
        print("  -> ${a.data}  ${a.sala}");
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(nome: 'Calendário de Aulas'),
      body: Column(
        children: [
          TableCalendar(
            headerStyle: HeaderStyle(
              //HEADER DO CALENDÁRIO
              titleTextStyle: TextStyle(
                color: corTexto,
                fontSize: comprimento * tamanhoTitulo,
                fontWeight: FontWeight.bold,
              ),
              formatButtonVisible: false, //Esconde o botão do formato
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: corTexto,
              ), //Seta Esquerda
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: corTexto,
              ), //Seta DIreita
            ),
            firstDay: DateTime(2025, 1, 1),
            lastDay: DateTime(2125, 1, 1),
            focusedDay: _diaSelecionado,
            calendarFormat: _calendarFormat,
            eventLoader: (dia) => listaAulas[removerHora(dia)] ?? [],
            locale: 'pt_BR', // Defina o idioma como português (Brasil) aqui
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: corSecundaria,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: corTexto,
                shape: BoxShape.circle,
              ),
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
                color: corTerciaria,
              ), //Cor dos dias úteis (segunda a sexta)
              weekendStyle: TextStyle(
                color: corTerciaria,
              ), //Cor dos finais de semana (sábado e domingo)
            ),
            selectedDayPredicate: (day) {
              //Necessário para o TableCalendar reconhecer o dia selecionado
              return removerHora(day) == removerHora(_diaSelecionado);
            },
            onDaySelected: (selectedDay, focusedDay) {
              selecionarDia(selectedDay);
            },
          ),

          SizedBox(height: altura * distanciaItens),

          //Mostra o título do dia selecionado
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: comprimento * paddingComprimento,
              //vertical: altura * paddingAltura,
            ),
            child: Row(
              children: [
                Text(
                  'Aulas de ${formatarDataDDMMYYYY(_diaSelecionado)}',
                  style: TextStyle(
                    fontSize: comprimento * tamanhoTitulo,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: altura * distanciaItens),

          // Lista de listaAulas do dia selecionado
          Expanded(
            child: _aulasDoDia.isEmpty
                ? Center(
                    child: Text(
                      'Nenhuma aula neste dia',
                      style: TextStyle(
                        color: corTexto,
                        fontSize: comprimento * tamanhoTexto,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: comprimento * paddingComprimento,
                      vertical: altura * paddingAltura,
                    ),
                    itemCount: _aulasDoDia.length,
                    itemBuilder: (context, index) {
                      Aula a = _aulasDoDia[index];
                      return AulaCalendarioBox(aula: a);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 0),
    );
  }
}
