import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/vaga_model.dart';

class VagaCard extends StatelessWidget {
  final Vaga vaga;
  final VoidCallback onTap;

  const VagaCard({
    super.key,
    required this.vaga,
    required this.onTap,
  });

  Color get _statusColor {
    switch (vaga.statusVaga) {
      case 'Vencida':
        return AppConstants.errorColor;
      case 'Últimos dias':
        return AppConstants.warningColor;
      case 'Encerrando em breve':
        return AppConstants.warningColor;
      default:
        return AppConstants.secondaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vaga.titulo,
                            style: const TextStyle(
                              fontSize: AppConstants.fontLarge,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            vaga.local,
                            style: const TextStyle(
                              fontSize: AppConstants.fontMedium,
                              color: AppConstants.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: Text(
                        vaga.statusVaga,
                        style: TextStyle(
                          fontSize: AppConstants.fontSmall,
                          fontWeight: FontWeight.w600,
                          color: _statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  vaga.descricao,
                  style: const TextStyle(
                    fontSize: AppConstants.fontMedium,
                    color: AppConstants.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.attach_money,
                      label: vaga.salario,
                      color: AppConstants.secondaryColor,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    _buildInfoChip(
                      icon: Icons.access_time,
                      label: vaga.cargaHoraria,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(width: AppConstants.paddingSmall),
                    _buildInfoChip(
                      icon: Icons.people,
                      label: '${vaga.vagas} vaga${vaga.vagas > 1 ? 's' : ''}',
                      color: AppConstants.warningColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                      ),
                      child: Text(
                        vaga.categoria,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSmall,
                          fontWeight: FontWeight.w500,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ),
                    if (!vaga.isVencida)
                      Text(
                        '${vaga.diasRestantes} dias restantes',
                        style: TextStyle(
                          fontSize: AppConstants.fontSmall,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSmall,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
