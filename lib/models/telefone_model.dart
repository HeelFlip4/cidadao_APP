import 'package:flutter/material.dart';

class TelefoneUtil {
  final String id;
  final String nome;
  final String numero;
  final String categoria;
  final String descricao;
  final String disponibilidade;
  final IconData icon;
  final Color color;

  TelefoneUtil({
    required this.id,
    required this.nome,
    required this.numero,
    required this.categoria,
    required this.descricao,
    required this.disponibilidade,
    required this.icon,
    required this.color,
  });

  factory TelefoneUtil.fromJson(Map<String, dynamic> json) {
    return TelefoneUtil(
      id: json['id'],
      nome: json['nome'],
      numero: json['numero'],
      categoria: json['categoria'],
      descricao: json['descricao'],
      disponibilidade: json['disponibilidade'],
      icon: _getIconFromString(json['icon']),
      color: Color(json['color']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'numero': numero,
      'categoria': categoria,
      'descricao': descricao,
      'disponibilidade': disponibilidade,
      'icon': _getStringFromIcon(icon),
      'color': color.value,
    };
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'local_police':
        return Icons.local_police;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'local_pharmacy':
        return Icons.local_pharmacy;
      case 'account_balance':
        return Icons.account_balance;
      case 'construction':
        return Icons.construction;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'school':
        return Icons.school;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'shield':
        return Icons.shield;
      case 'security':
        return Icons.security;
      case 'feedback':
        return Icons.feedback;
      default:
        return Icons.phone;
    }
  }

  static String _getStringFromIcon(IconData icon) {
    if (icon == Icons.local_fire_department) return 'local_fire_department';
    if (icon == Icons.local_police) return 'local_police';
    if (icon == Icons.local_hospital) return 'local_hospital';
    if (icon == Icons.local_pharmacy) return 'local_pharmacy';
    if (icon == Icons.account_balance) return 'account_balance';
    if (icon == Icons.construction) return 'construction';
    if (icon == Icons.cleaning_services) return 'cleaning_services';
    if (icon == Icons.school) return 'school';
    if (icon == Icons.directions_bus) return 'directions_bus';
    if (icon == Icons.shield) return 'shield';
    if (icon == Icons.security) return 'security';
    if (icon == Icons.feedback) return 'feedback';
    return 'phone';
  }

  bool get isEmergency => categoria == 'Emergência';
  
  bool get isAvailable24h => disponibilidade.contains('24 horas');
}
