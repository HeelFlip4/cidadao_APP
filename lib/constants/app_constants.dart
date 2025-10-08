import 'package:flutter/material.dart';

class AppConstants {
  // Cores do aplicativo
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color warningColor = Color(0xFFFF9500);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Espaçamentos
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Tamanhos de fonte
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 16.0;
  static const double fontXLarge = 18.0;
  static const double fontXXLarge = 24.0;
  
  // Categorias de ocorrências
  static const List<Map<String, dynamic>> categorias = [
    {
      'id': 'saude',
      'nome': 'Saúde',
      'icon': Icons.local_hospital,
      'color': Color(0xFFE53E3E),
      'subcategorias': [
        'UBS - Unidade Básica de Saúde',
        'Hospital Municipal',
        'Pronto Socorro',
        'Farmácia Popular',
        'Centro de Especialidades',
      ]
    },
    {
      'id': 'infraestrutura',
      'nome': 'Infraestrutura',
      'icon': Icons.construction,
      'color': Color(0xFFFF9500),
      'subcategorias': [
        'Buracos na via',
        'Calçada danificada',
        'Sinalização de trânsito',
        'Semáforo com defeito',
        'Ponte/Viaduto',
      ]
    },
    {
      'id': 'limpeza',
      'nome': 'Limpeza Pública',
      'icon': Icons.cleaning_services,
      'color': Color(0xFF4CAF50),
      'subcategorias': [
        'Coleta de lixo',
        'Limpeza de rua',
        'Poda de árvores',
        'Capina de terreno',
        'Entulho abandonado',
      ]
    },
    {
      'id': 'iluminacao',
      'nome': 'Iluminação',
      'icon': Icons.lightbulb,
      'color': Color(0xFFFFEB3B),
      'subcategorias': [
        'Poste queimado',
        'Fiação exposta',
        'Falta de iluminação',
        'Poste caído',
        'Lâmpada queimada',
      ]
    },
    {
      'id': 'educacao',
      'nome': 'Educação',
      'icon': Icons.school,
      'color': Color(0xFF2196F3),
      'subcategorias': [
        'Escola Municipal',
        'Creche',
        'Transporte escolar',
        'Merenda escolar',
        'Infraestrutura escolar',
      ]
    },
    {
      'id': 'denuncia',
      'nome': 'Denúncia',
      'icon': Icons.report,
      'color': Color(0xFF9C27B0),
      'subcategorias': [
        'Maus tratos a animais',
        'Poluição sonora',
        'Construção irregular',
        'Comércio irregular',
        'Outros',
      ]
    },
  ];
  
  // URLs da API (placeholder para futuro backend)
  static const String baseUrl = 'https://api.cidadao.gov.br';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String ocorrenciasEndpoint = '/ocorrencias';
  static const String vagasEndpoint = '/vagas';
  static const String telefonesEndpoint = '/telefones';
  static const String noticiasEndpoint = '/noticias';
  
  // Configurações de notificação
  static const String notificationChannelId = 'cidadao_app_notifications';
  static const String notificationChannelName = 'Cidadão App';
  static const String notificationChannelDescription = 'Notificações do aplicativo Cidadão';
}
