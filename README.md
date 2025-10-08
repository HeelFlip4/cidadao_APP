# Cidadão App - Aplicativo para Prefeituras

Um aplicativo móvel desenvolvido em Flutter para conectar cidadãos aos serviços municipais, permitindo o registro de ocorrências, consulta de vagas de emprego, acesso a telefones úteis e acompanhamento de notícias da cidade.

## 📱 Funcionalidades

### 🔐 Autenticação
- **Splash Screen** com animação de carregamento
- **Login/Cadastro** com validação de dados
- **Verificação por SMS** para novos usuários
- Interface moderna e intuitiva

### 🏠 Tela Principal (Home)
- **Dashboard** com informações relevantes
- **Banner rotativo** com notícias da cidade
- **Serviços mais acessados** em destaque
- **Categorias de ocorrências** organizadas
- **Sistema de notificações** para atualizações

### 💼 Vagas de Emprego
- **Listagem completa** de vagas disponíveis
- **Sistema de busca** por cargo ou categoria
- **Filtros por categoria** (Administrativo, Saúde, Educação, etc.)
- **Detalhes completos** de cada vaga
- **Sistema de candidatura** integrado

### 📞 Telefones Úteis
- **Números de emergência** em destaque (190, 192, 193)
- **Telefones organizados por categoria**
- **Discagem direta** com um toque
- **Informações de disponibilidade** de cada serviço

### 📋 Sistema de Ocorrências
- **6 Categorias principais**: Saúde, Infraestrutura, Limpeza Pública, Iluminação, Educação, Denúncia
- **Subcategorias específicas** para cada área
- **Upload de até 3 fotos** para documentar o problema
- **Localização GPS obrigatória** para precisão
- **Acompanhamento de status** das ocorrências

## 🛠️ Tecnologias Utilizadas

- **Flutter 3.24.3** - Framework multiplataforma
- **Dart 3.5.3** - Linguagem de programação
- **Geolocator** - Serviços de localização GPS
- **Image Picker** - Captura e seleção de imagens
- **URL Launcher** - Discagem telefônica
- **HTTP/Dio** - Requisições para backend
- **Provider** - Gerenciamento de estado
- **Firebase** - Notificações push (preparado)

## 📁 Estrutura do Projeto

```
lib/
├── constants/          # Constantes globais
├── models/            # Modelos de dados
├── screens/           # Telas do aplicativo
├── widgets/           # Componentes reutilizáveis
├── services/          # Serviços (API, localização, notificações)
└── main.dart         # Arquivo principal
```

## 🚀 Como Executar

1. **Instalar Flutter SDK 3.24.3+**
2. **Clonar o repositório**
3. **Instalar dependências**: `flutter pub get`
4. **Executar**: `flutter run`

## 🔧 Configuração para Produção

### Permissões Android
- Localização (GPS)
- Câmera
- Telefone
- Internet

### Configuração de Backend
Edite `lib/constants/app_constants.dart` com suas URLs de API.

## 📱 Telas Implementadas

1. **Splash Screen** - Animação de abertura
2. **Login/Cadastro** - Autenticação com SMS
3. **Home** - Dashboard principal com navegação
4. **Vagas** - Listagem e busca de empregos
5. **Telefones** - Contatos úteis organizados
6. **Ocorrências** - Registro com fotos e GPS

## 🔄 Integração com Backend

O aplicativo está preparado para consumir APIs REST com endpoints para:
- Autenticação (login/cadastro)
- Ocorrências (CRUD)
- Vagas de emprego
- Telefones úteis
- Upload de imagens
- Notificações push

## 📞 Suporte

Para dúvidas sobre implementação ou customização, consulte a documentação completa no código ou entre em contato com a equipe de desenvolvimento.

---

**Desenvolvido para conectar cidadãos e prefeituras de forma eficiente e moderna.**
