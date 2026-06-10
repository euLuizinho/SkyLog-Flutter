# 🛰️ SkyLog Gestor — Painel de Riscos Ambientais e Frota

### *Global Solution 2026.1 · FIAP · Sistemas de Informação · Turma 3SIZ*

---

## 📌 Proposta da Aplicação e Objetivos
O **SkyLog Gestor** é uma plataforma inovadora em **Flutter Web** projetada para frotas de transporte rodoviário de cargas no Brasil. Diante do aumento de eventos climáticos extremos e desastres naturais, a segurança de motoristas e cargas é o maior desafio logístico do país.

A proposta do aplicativo é **centralizar a telemetria via satélite** e cruzar dados geoespaciais em tempo real para:
* **Prevenir acidentes:** Mapear focos de incêndio, inundações, deslizamentos de terra e tempestades que bloqueiam estradas.
* **Otimizar rotas:** Permitir que gestores tomem decisões rápidas de desvio antes que os caminhões entrem em áreas de risco crítico.
* **Reduzir custos operacionais:** Minimizar atrasos e perda de sinistros causados por eventos de força maior.

---

## 🚀 Descrição da Solução
O sistema é composto por duas variantes de interface conectadas ao mesmo ecossistema de dados, permitindo a escolha entre uma abordagem mobile-first acadêmica e um dashboard desktop profissional:

1. **Versão 1 (Mobile-Style - Raiz):** Interface focada nos requisitos acadêmicos da FIAP, contendo controle estrito de autenticação de usuários gestores e navegação coordenada em abas inferiores (Home, Alertas e Perfil).
2. **Versão 2 (Premium Desktop Dashboard - Projeto Separado):** Painel B2B com layout expandido, barra lateral (sidebar) fixa, widgets de métricas avançados e bypass de autenticação automática para apresentações e demonstrações rápidas.


### Recursos Técnicos Principais:
* **Autenticação Real:** Sistema de cadastro e login de gestores via **Firebase Auth**.
* **Integração com Google Maps:** Renderização dinâmica da malha rodoviária com marcadores coloridos baseados na severidade do risco.
* **Banco de Dados em Tempo Real:** Escuta contínua de alertas e persistência de dados de perfil (como limiar de exibição e tema preferido) via **Cloud Firestore**.
* **População Automática (Seed):** Inicialização autônoma do banco de dados com 8 alertas reais em rodovias federais caso a base esteja vazia.

---

## 🏗️ Arquitetura do Projeto (MVVM)
O projeto segue o padrão **MVVM (Model-View-ViewModel)** recomendado para assegurar modularidade, testabilidade e facilidade de manutenção.

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart         # Tokens de cores (Coral, Areia, Charcoal)
│   │   └── app_theme.dart          # Definições de tema claro e escuro
│   └── dependency_injection.dart   # Injeção de dependência (GetIt)
├── data/
│   ├── models/
│   │   ├── alerta_model.dart       # Serialização do documento de alertas
│   │   └── usuario_model.dart      # Serialização dos dados do usuário
│   └── repositories/
│       ├── alerta_repository.dart  # Integração direta com o Firestore
│       └── auth_repository.dart    # Conexão com Firebase Auth e perfis
├── domain/
│   └── viewmodels/
│       ├── auth_viewmodel.dart     # Regras de negócio de login e sessão
│       ├── home_viewmodel.dart     # Gerenciamento de estado do mapa
│       ├── alertas_viewmodel.dart  # Lógica de listagem e filtros
│       └── perfil_viewmodel.dart   # Configurações do usuário
└── presentation/
    ├── components/                 # Componentes reutilizáveis (AlertCard, MetricCard...)
    ├── navigation/
    │   └── app_router.dart         # Sistema de rotas nomeadas
    └── screens/                    # Telas da aplicação (Login, Home, Detalhes...)
```

---

## 💻 Como Executar as Aplicações

Ambos os projetos estão configurados com a biblioteca do Google Maps e credenciais ativas do Firebase.

### Pré-requisitos
* Flutter SDK instalado (versão `^3.12.0` ou superior).
* Google Chrome.

### Executando a Versão 1 (Mobile-Style - Raiz)
1. Abra o terminal na raiz do projeto:
   ```bash
   cd SkyLog
   ```
2. Limpe os builds em cache e baixe as dependências:
   ```bash
   flutter clean
   flutter pub get
   ```
3. Inicie o servidor local no Chrome:
   ```bash
   flutter run -d chrome
   ```

### Executando a Versão 2 (Premium Desktop Dashboard - Projeto Separado)
1. Abra um terminal na pasta do projeto desktop (`skylog_desktop`):
   ```bash
   cd ../skylog_desktop
   ```
2. Limpe o cache e baixe as dependências:
   ```bash
   flutter clean
   flutter pub get
   ```
3. Inicie o servidor local no Chrome:
   ```bash
   flutter run -d chrome
   ```

---

## 👥 Integrantes do Grupo
* **Luiz Fabiano Nascimento Vale da Silva** - RM 553529
* **Lucas Fontes Peruzin** - RM 552877
* **Fernando Youngbin Kang** - RM 553499

---

## 🎥 Link do Pitch de Apresentação
* 🔗 **[Assista ao Pitch do Projeto SkyLog no YouTube](https://youtu.be/oWIz45x7whg)**
