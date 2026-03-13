# HorarioMestrado
Como o **Mestrado** não possui um horário fixo e o departamento apenas disponibiliza um ficheiro **.pdf** com a tabela dos horários — pouco intuitiva e difícil de consultar — desenvolvi esta aplicação para apresentar o horário de forma mais clara e prática.
Este mini projeto permitiu-me atualizar e aprimorar as minhas habilidades em **Flutter**, após alguns meses sem o utilizar.
Inicialmente, o objetivo era apenas ler ficheiros **JSON** e exibir um **calendário**, mas acabei por expandir a ideia e adicionar funcionalidades CRUD completas.

<br><br>
Funcionalidades e Tecnologias <br>

💾 **Leitura & Armazenamento ficheiros JSON** <br>
🗄️ **Base de dados interna** (SQLite)  <br>
📅 **Calendário interativo**  <br>
✏️ **CRUD completo** (Create, Read, Update & Delete)  <br>
🧩 **Componentes reutilizáveis**  <br>
🔄 **Rotas com argumentos**  <br>
🚀 **Estrutura escalável** e fácil de manter  <br>
🎨 **Consistência visual responsiva** (tamanhos de texto, cores e espaçamentos padronizados através de variáveis centralizadas) <br>

<br><br>
A aplicação foi organizada de forma modular para facilitar a manutenção e a escalabilidade.
-> components/ → widgets reutilizáveis (UI) <br>
-> database/ → gestão da base de dados SQLite <br>
-> models/ → classes que representam os dados (Aula, Cadeira, Período) <br>
-> pages/ → ecrãs principais e suas subpáginas <br>
-> variables/ → constantes globais (cores, ícones, tamanhos, enums) <br>

<br><br>
#📥 Downloads <br>

Pode descarregar a aplicação no link abaixo:
* [**Descarregar APK (v3.2)**](https://github.com/SilvaDaMiguel/HorarioMestrado/releases/tag/v3.2/app-release.apk)

Pode também descarregar os JSONs das Cadeiras & Períodos 2025/2027 (se fizer sentido para tal)
* [**Descarregar JSONs (Cadeiras & Períodos)**](https://github.com/SilvaDaMiguel/HorarioMestrado/releases/tag/JSONs)
