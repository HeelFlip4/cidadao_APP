import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/telefone_model.dart';

class TelefoneCard extends StatelessWidget {
  final TelefoneUtil telefone;
  final VoidCallback onCall;

  const TelefoneCard({
    super.key,
    required this.telefone,
    required this.onCall,
  });

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
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: telefone.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Icon(
                telefone.icon,
                color: telefone.color,
                size: 24,
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    telefone.nome,
                    style: const TextStyle(
                      fontSize: AppConstants.fontLarge,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    telefone.numero,
                    style: TextStyle(
                      fontSize: AppConstants.fontMedium,
                      fontWeight: FontWeight.w600,
                      color: telefone.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    telefone.descricao,
                    style: const TextStyle(
                      fontSize: AppConstants.fontMedium,
                      color: AppConstants.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          telefone.disponibilidade,
                          style: TextStyle(
                            fontSize: AppConstants.fontSmall,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Container(
              decoration: BoxDecoration(
                color: telefone.color,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: telefone.color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  onTap: onCall,
                  child: const Padding(
                    padding: EdgeInsets.all(AppConstants.paddingMedium),
                    child: Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
