# Valora

### Gestão de alimentos e acompanhamento de validade no iOS

O Valora é um aplicativo iOS que apoia a organização doméstica de alimentos. A proposta é tornar visíveis os prazos de validade dos produtos cadastrados, facilitar a consulta da despensa e oferecer lembretes para ajudar no planejamento do consumo e das compras.

**Plataforma:** iOS 26+ · **Interface:** SwiftUI · **Persistência:** SwiftData · **Notificações:** UserNotifications

## Problema e objetivo

Alimentos armazenados em locais diferentes podem ser esquecidos até que sua validade esteja próxima ou tenha passado. O projeto aborda esse problema por meio de uma lista centralizada, organizada pela situação de cada alimento e por sua data de vencimento.

O objetivo é fornecer uma ferramenta de acompanhamento simples: o usuário registra os produtos, consulta sua situação e pode configurar lembretes. O aplicativo apoia a tomada de decisão, mas não determina automaticamente se um alimento está próprio para consumo.

## Funcionalidades implementadas

| Funcionalidade | Comportamento |
| --- | --- |
| **Cadastro de alimentos** | Registra nome e validade, além de categoria, quantidade, unidade, local de armazenamento e observações. |
| **Consulta da despensa** | Lista os itens ativos, ordenados por validade e agrupados em vencidos, vencendo hoje, vencendo em breve e dentro do prazo. |
| **Busca e detalhes** | Filtra alimentos pelo nome e apresenta as informações de cada item. |
| **Manutenção dos registros** | Permite editar, excluir ou marcar um alimento como consumido. |
| **Lembretes de validade** | Agenda notificações locais para o dia do vencimento e, quando configurado, com antecedência. |
| **Lembretes de compras** | Permite configurar frequência e horário para lembretes locais. |
| **Pesquisa de receitas** | Abre uma pesquisa na web usando o nome do alimento como ingrediente. |
| **Configuração inicial** | Apresenta o aplicativo e permite informar preferências de armazenamento, compras e notificações. |
| **Localização** | Disponibiliza textos em português brasileiro e inglês. |

## Casos de uso para avaliação

1. **Cadastrar e localizar um alimento:** adicione um item com nome e validade, volte à despensa e pesquise pelo nome.
2. **Identificar prioridades:** cadastre itens com datas diferentes e observe sua ordenação e agrupamento. Itens com vencimento em até três dias são agrupados como vencendo em breve; itens que vencem hoje e itens vencidos possuem grupos próprios.
3. **Atualizar o estoque:** abra um alimento, edite suas informações e depois marque-o como consumido. Ele deixa de aparecer na lista de itens ativos.
4. **Configurar lembretes:** autorize notificações no iOS e ajuste as opções de validade e compras na aba **Ajustes**.
5. **Buscar uma receita:** nos detalhes de um alimento, selecione **Ver Receitas** para abrir uma pesquisa externa.
6. **Verificar persistência:** cadastre um alimento, encerre e reabra o aplicativo no mesmo dispositivo ou simulador e confira o registro na despensa.

## Arquitetura e decisões técnicas

O projeto segue uma organização inspirada em **MVVM**. As telas SwiftUI apresentam os dados e recebem interações; os view models observáveis coordenam o estado e as ações; os repositórios concentram o acesso aos modelos persistidos. Serviços específicos tratam as notificações e os dados de navegação associados a elas.

```text
Views (SwiftUI)
    │
    ▼
ViewModels (@Observable)
    ├── Repositories ── SwiftData / ModelContext
    └── NotificationService ── UserNotifications

AppRouter: navegação entre abas, detalhes e formulários
AppDependencies: composição das dependências compartilhadas
```

| Componente | Papel no sistema |
| --- | --- |
| **Models** | Representam alimentos, preferências e tipos de domínio, como categorias e unidades. |
| **Views** | Implementam as telas de apresentação inicial, despensa, cadastro, detalhes e ajustes. |
| **ViewModels** | Mantêm o estado das telas e coordenam operações, como busca, edição e configurações. |
| **Repositories** | Consultam e salvam alimentos e preferências usando o contexto SwiftData. |
| **Services** | Agendam e cancelam notificações locais e interpretam informações de navegação. |
| **App e Design System** | Organizam a composição das dependências, o roteamento e os componentes visuais reutilizáveis. |

### Regras e limites relevantes

- A situação de validade é calculada a partir dos dias de calendário entre a data atual e a data registrada para o alimento.
- Os dados são persistidos **localmente** no dispositivo. O projeto não implementa autenticação, sincronização entre dispositivos ou backend próprio.
- O recurso de receitas é uma pesquisa externa, não um catálogo ou serviço próprio. A pesquisa depende de acesso à internet.
- A entrega das notificações depende da autorização do usuário e do comportamento do sistema. Lembretes quinzenais e mensais são agendados como ocorrências únicas e reagendados quando o aplicativo volta a ficar ativo.
- O projeto utiliza APIs e recursos de interface associados ao iOS 26; esse é o alvo mínimo configurado para o aplicativo.

## Estrutura do projeto

```text
Valora/
├── Valora.xcodeproj/     # Projeto Xcode
└── Valora/
    ├── App/              # Dependências e navegação
    ├── Assets.xcassets/  # Recursos visuais
    ├── DesignSystem/     # Componentes, cores e espaçamentos
    ├── Models/           # Modelos e enumerações
    ├── Repositories/     # Acesso aos dados
    ├── Resources/        # Catálogo de traduções
    ├── Services/         # Notificações e navegação por notificações
    ├── ViewModels/       # Estado e lógica das telas
    ├── Views/            # Interface SwiftUI
    └── ValoraApp.swift   # Entrada e configuração do aplicativo
```

## Execução

### Pré-requisitos

- macOS com uma versão do Xcode que inclua o SDK do iOS 26.
- Simulador ou dispositivo com **iOS 26 ou superior**.
- Para um dispositivo físico, assinatura e conta de desenvolvedor configuradas no Xcode.

### Passos

1. Clone este repositório e abra `Valora.xcodeproj` no Xcode.
2. Selecione o esquema **Valora** e um simulador compatível.
3. Execute o projeto com **Run** (`⌘R`).
4. Conclua a apresentação inicial. Para avaliar os lembretes, permita as notificações quando solicitado.

Também é possível compilar pelo terminal, na raiz do repositório:

```bash
xcodebuild -project Valora.xcodeproj \
  -scheme Valora \
  -configuration Debug \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build
```

Caso esse modelo não esteja instalado, consulte `xcrun simctl list devices available` e substitua o nome pelo de um simulador disponível.
