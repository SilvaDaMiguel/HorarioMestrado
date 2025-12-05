//calendar.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
//MODELS
import '../models/aula.dart';
import '../models/prova.dart'; // NOVO
//DATABASE
import '../database/database_service.dart';
//COMPONENTS
import '../components/today_class_box.dart';
import '../components/today_exam_box.dart'; // NOVO
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
  //Map<DateTime, List<Aula>> para o TableCalendar (apenas aulas)
  Map<DateTime, List<Aula>> listaAulas = {};
  //Map<DateTime, List<Prova>> para as provas
  Map<DateTime, List<Prova>> listaProvas = {};
  //Map combinado para todos os eventos (Aulas e Provas)
  Map<DateTime, List<dynamic>> listaEventos = {};

  final CalendarFormat _calendarFormat =
      CalendarFormat.month; //Formato inicial do calendário
  DateTime _diaSelecionado = DateTime.now(); //Dia atualmente selecionado
  //Lista de eventos (Aulas e Provas) do dia selecionado
  List<dynamic> _eventosDoDia = []; // ALTERADO: De List<Aula> para List<dynamic>

  @override
  void initState() {
    super.initState();
    //Carrega horários (aulas e provas) da base de dados
    Future.wait([
      DataBaseService().obterAulas(),
      DataBaseService().obterProvas(),
    ]).then((resultados) {
      carregarAulas(resultados[0] as List<Aula>);
      carregarProvas(resultados[1] as List<Prova>);
      combinarEventos(); //Combina aulas e provas
      //Mostra os eventos do dia atual
      selecionarDia(_diaSelecionado);
    });
  }

  //Converte lista de Aulas para o Map<DateTime, List<Aula>>
  void carregarAulas(List<Aula> aulas) {
    listaAulas = {}; //limpa antes

    for (var aula in aulas) {
      DateTime dia = removerHora(stringDDMMYYYYParaDateTime(aula.data)!);

      if (!listaAulas.containsKey(dia)) {
        listaAulas[dia] = [];
      }
      listaAulas[dia]!.add(aula);
    }
  }

  //Converte a lista de Provas para o Map<DateTime, List<Prova>>
  void carregarProvas(List<Prova> provas) {
    listaProvas = {}; //limpa antes

    for (var prova in provas) {
      DateTime dia = removerHora(stringDDMMYYYYParaDateTime(prova.data)!);

      if (!listaProvas.containsKey(dia)) {
        listaProvas[dia] = [];
      }
      listaProvas[dia]!.add(prova);
    }
  }

  //Combina as aulas e provas em um único Map de eventos
  void combinarEventos() {
    listaEventos = {};
    
    //Adiciona aulas
    listaAulas.forEach((dia, eventos) {
      listaEventos[dia] = [...eventos];
    });

    //Adiciona provas (e combina se já houver aulas)
    listaProvas.forEach((dia, eventos) {
      if (listaEventos.containsKey(dia)) {
        listaEventos[dia]!.addAll(eventos);
      } else {
        listaEventos[dia] = [...eventos];
      }
    });

    setState(() {}); //Após carregar e combinar tudo
  }

  //Seleciona um dia e atualiza a lista de eventos (aulas e provas)
  void selecionarDia(DateTime dia) {
    final DateTime diaSemHora = removerHora(dia);
    //print("Selecionar dia: $diaSemHora");

    setState(() {
      _diaSelecionado = diaSemHora;
      _eventosDoDia = listaEventos[diaSemHora] ?? []; //ALTERADO: Usa listaEventos
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESPONSIVIDADE
    var tamanho = MediaQuery.of(context).size;
    double comprimento = tamanho.width;
    double altura = tamanho.height;

    return Scaffold(
      appBar: MinhaAppBar(nome: 'Calendário de Eventos'),
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
            eventLoader: (dia) => listaEventos[removerHora(dia)] ?? [], // ALTERADO
            locale: 'pt_BR', // Definir o idioma como português
            //PT: "segunda" "terça" / BR: "seg." "ter." => Por isso a escolha do BR
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: corSecundaria,
                shape: BoxShape.circle,
              ),
              //removido markerDecoration para que o custom builder funcione corretamente.
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
            //Lógica para múltiplos marcadores de cores diferentes
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isEmpty) {
                  return null;
                }
                
                //Map de eventos para widgets de marcador (dots)
                final List<Widget> dots = events.map((event) {
                  //Define a cor para Provas e Aulas
                  Color markerColor = event is Prova ? corTerciaria : corTexto;
                  return Container(
                    width: 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: markerColor,
                    ),
                  );
                }).toList();
                
                //Limita a 5 pontos e mostra-os em uma linha na parte inferior
                //Isso mantém a funcionalidade dos "pontinhos" com cores distintas.
                return Positioned(
                  bottom: 1,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: dots.take(5).toList(), //Limita a 5 dots visíveis
                  ),
                );
              },
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
                  'Eventos de ${formatarDataDDMMYYYY(_diaSelecionado)}',
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

          //Lista de eventos (aulas e provas) do dia selecionado
          Expanded(
            child: _eventosDoDia.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum evento neste dia',
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
                    itemCount: _eventosDoDia.length,
                    itemBuilder: (context, index) {
                      final item = _eventosDoDia[index];
                      if (item is Aula) {
                        return AulaCalendarioBox(aula: item);
                      } else if (item is Prova) {
                        return ProvaCalendarioBox(prova: item);
                      }
                      return Container();
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: MyNavigationBar(IconSelecionado: 0),
    );
  }
}