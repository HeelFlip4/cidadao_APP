import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../widgets/telefone_card.dart';
import '../models/telefone_model.dart';

class TelefonesScreen extends StatefulWidget {
  const TelefonesScreen({super.key});

  @override
  State<TelefonesScreen> createState() => _TelefonesScreenState();
}

class _TelefonesScreenState extends State<TelefonesScreen> {
  List<TelefoneUtil> _telefones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTelefones();
  }

  Future<void> _carregarTelefones() async {
    // Simular carregamento de dados
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _telefones = [
        // Emergência
        TelefoneUtil(
          id: '1',
          nome: 'Bombeiros',
          numero: '193',
          categoria: 'Emergência',
          descricao: 'Combate a incêndios e salvamentos',
          disponibilidade: '24 horas',
          icon: Icons.local_fire_department,
          color: AppConstants.errorColor,
        ),
        TelefoneUtil(
          id: '2',
          nome: 'Polícia Militar',
          numero: '190',
          categoria: 'Emergência',
          descricao: 'Ocorrências policiais e segurança pública',
          disponibilidade: '24 horas',
          icon: Icons.local_police,
          color: AppConstants.errorColor,
        ),
        TelefoneUtil(
          id: '3',
          nome: 'SAMU',
          numero: '192',
          categoria: 'Emergência',
          descricao: 'Serviço de Atendimento Móvel de Urgência',
          disponibilidade: '24 horas',
          icon: Icons.local_hospital,
          color: AppConstants.errorColor,
        ),
        
        // Saúde
        TelefoneUtil(
          id: '4',
          nome: 'UBS Centro',
          numero: '(11) 3456-7890',
          categoria: 'Saúde',
          descricao: 'Unidade Básica de Saúde do Centro',
          disponibilidade: 'Segunda a Sexta: 7h às 17h',
          icon: Icons.local_hospital,
          color: const Color(0xFF2196F3),
        ),
        TelefoneUtil(
          id: '5',
          nome: 'Hospital Municipal',
          numero: '(11) 3456-7891',
          categoria: 'Saúde',
          descricao: 'Hospital Municipal São José',
          disponibilidade: '24 horas',
          icon: Icons.local_hospital,
          color: const Color(0xFF2196F3),
        ),
        TelefoneUtil(
          id: '6',
          nome: 'Farmácia Popular',
          numero: '(11) 3456-7892',
          categoria: 'Saúde',
          descricao: 'Farmácia Popular do Brasil',
          disponibilidade: 'Segunda a Sexta: 8h às 18h',
          icon: Icons.local_pharmacy,
          color: const Color(0xFF2196F3),
        ),
        
        // Serviços Públicos
        TelefoneUtil(
          id: '7',
          nome: 'Prefeitura Municipal',
          numero: '(11) 3456-7893',
          categoria: 'Serviços Públicos',
          descricao: 'Atendimento geral da prefeitura',
          disponibilidade: 'Segunda a Sexta: 8h às 17h',
          icon: Icons.account_balance,
          color: AppConstants.primaryColor,
        ),
        TelefoneUtil(
          id: '8',
          nome: 'Secretaria de Obras',
          numero: '(11) 3456-7894',
          categoria: 'Serviços Públicos',
          descricao: 'Obras públicas e infraestrutura',
          disponibilidade: 'Segunda a Sexta: 8h às 17h',
          icon: Icons.construction,
          color: AppConstants.primaryColor,
        ),
        TelefoneUtil(
          id: '9',
          nome: 'Limpeza Urbana',
          numero: '(11) 3456-7895',
          categoria: 'Serviços Públicos',
          descricao: 'Coleta de lixo e limpeza pública',
          disponibilidade: 'Segunda a Sexta: 7h às 16h',
          icon: Icons.cleaning_services,
          color: AppConstants.primaryColor,
        ),
        
        // Educação
        TelefoneUtil(
          id: '10',
          nome: 'Secretaria de Educação',
          numero: '(11) 3456-7896',
          categoria: 'Educação',
          descricao: 'Informações sobre escolas municipais',
          disponibilidade: 'Segunda a Sexta: 8h às 17h',
          icon: Icons.school,
          color: AppConstants.secondaryColor,
        ),
        TelefoneUtil(
          id: '11',
          nome: 'Transporte Escolar',
          numero: '(11) 3456-7897',
          categoria: 'Educação',
          descricao: 'Informações sobre transporte escolar',
          disponibilidade: 'Segunda a Sexta: 7h às 18h',
          icon: Icons.directions_bus,
          color: AppConstants.secondaryColor,
        ),
        
        // Utilidades
        TelefoneUtil(
          id: '12',
          nome: 'Defesa Civil',
          numero: '199',
          categoria: 'Utilidades',
          descricao: 'Prevenção e resposta a desastres',
          disponibilidade: '24 horas',
          icon: Icons.shield,
          color: AppConstants.warningColor,
        ),
        TelefoneUtil(
          id: '13',
          nome: 'Guarda Municipal',
          numero: '153',
          categoria: 'Utilidades',
          descricao: 'Segurança municipal e patrimônio público',
          disponibilidade: '24 horas',
          icon: Icons.security,
          color: AppConstants.warningColor,
        ),
        TelefoneUtil(
          id: '14',
          nome: 'Ouvidoria',
          numero: '(11) 3456-7898',
          categoria: 'Utilidades',
          descricao: 'Reclamações e sugestões',
          disponibilidade: 'Segunda a Sexta: 8h às 17h',
          icon: Icons.feedback,
          color: AppConstants.warningColor,
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _fazerLigacao(String numero) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: numero,
    );
    
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _mostrarErro('Não foi possível fazer a ligação');
      }
    } catch (e) {
      _mostrarErro('Erro ao tentar fazer a ligação');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: AppConstants.errorColor,
      ),
    );
  }

  Map<String, List<TelefoneUtil>> get _telefonesPorCategoria {
    final Map<String, List<TelefoneUtil>> grouped = {};
    for (final telefone in _telefones) {
      if (!grouped.containsKey(telefone.categoria)) {
        grouped[telefone.categoria] = [];
      }
      grouped[telefone.categoria]!.add(telefone);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Telefones Úteis',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarTelefones,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmergencySection(),
                    const SizedBox(height: AppConstants.paddingLarge),
                    ..._buildCategorySections(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmergencySection() {
    final emergencyNumbers = _telefones
        .where((t) => t.categoria == 'Emergência')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConstants.errorColor,
                AppConstants.errorColor.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.emergency,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: AppConstants.paddingSmall),
                  Text(
                    'EMERGÊNCIA',
                    style: TextStyle(
                      fontSize: AppConstants.fontLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              const Text(
                'Números de emergência disponíveis 24 horas',
                style: TextStyle(
                  fontSize: AppConstants.fontMedium,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Row(
                children: emergencyNumbers.map((telefone) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
                      child: _buildEmergencyButton(telefone),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyButton(TelefoneUtil telefone) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          onTap: () => _fazerLigacao(telefone.numero),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingSmall),
            child: Column(
              children: [
                Icon(
                  telefone.icon,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  telefone.numero,
                  style: const TextStyle(
                    fontSize: AppConstants.fontLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  telefone.nome,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSmall,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCategorySections() {
    final categorias = _telefonesPorCategoria.keys
        .where((categoria) => categoria != 'Emergência')
        .toList();

    return categorias.map((categoria) {
      final telefones = _telefonesPorCategoria[categoria]!;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoria.toUpperCase(),
            style: const TextStyle(
              fontSize: AppConstants.fontLarge,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          ...telefones.map((telefone) {
            return TelefoneCard(
              telefone: telefone,
              onCall: () => _fazerLigacao(telefone.numero),
            );
          }),
          const SizedBox(height: AppConstants.paddingLarge),
        ],
      );
    }).toList();
  }
}
