import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/vaga_card.dart';
import '../models/vaga_model.dart';

class VagasScreen extends StatefulWidget {
  const VagasScreen({super.key});

  @override
  State<VagasScreen> createState() => _VagasScreenState();
}

class _VagasScreenState extends State<VagasScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Vaga> _vagas = [];
  List<Vaga> _vagasFiltradas = [];
  bool _isLoading = true;
  String _filtroSelecionado = 'Todas';

  final List<String> _filtros = [
    'Todas',
    'Administrativo',
    'Saúde',
    'Educação',
    'Obras',
    'Limpeza',
  ];

  @override
  void initState() {
    super.initState();
    _carregarVagas();
    _searchController.addListener(_filtrarVagas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarVagas() async {
    // Simular carregamento de dados
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _vagas = [
        Vaga(
          id: '1',
          titulo: 'Auxiliar Administrativo',
          descricao: 'Auxiliar nas atividades administrativas da prefeitura',
          categoria: 'Administrativo',
          salario: 'R\$ 1.500,00',
          cargaHoraria: '40h semanais',
          requisitos: 'Ensino médio completo, conhecimentos básicos em informática',
          dataPublicacao: DateTime.now().subtract(const Duration(days: 2)),
          dataVencimento: DateTime.now().add(const Duration(days: 28)),
          local: 'Prefeitura Municipal',
          vagas: 2,
        ),
        Vaga(
          id: '2',
          titulo: 'Enfermeiro(a)',
          descricao: 'Atendimento em Unidade Básica de Saúde',
          categoria: 'Saúde',
          salario: 'R\$ 3.200,00',
          cargaHoraria: '40h semanais',
          requisitos: 'Graduação em Enfermagem, COREN ativo',
          dataPublicacao: DateTime.now().subtract(const Duration(days: 1)),
          dataVencimento: DateTime.now().add(const Duration(days: 29)),
          local: 'UBS Centro',
          vagas: 1,
        ),
        Vaga(
          id: '3',
          titulo: 'Professor de Matemática',
          descricao: 'Lecionar matemática para ensino fundamental',
          categoria: 'Educação',
          salario: 'R\$ 2.800,00',
          cargaHoraria: '30h semanais',
          requisitos: 'Licenciatura em Matemática',
          dataPublicacao: DateTime.now().subtract(const Duration(days: 3)),
          dataVencimento: DateTime.now().add(const Duration(days: 27)),
          local: 'Escola Municipal João Silva',
          vagas: 1,
        ),
        Vaga(
          id: '4',
          titulo: 'Operador de Máquinas',
          descricao: 'Operar máquinas pesadas para obras públicas',
          categoria: 'Obras',
          salario: 'R\$ 2.200,00',
          cargaHoraria: '44h semanais',
          requisitos: 'CNH categoria D, experiência comprovada',
          dataPublicacao: DateTime.now().subtract(const Duration(days: 4)),
          dataVencimento: DateTime.now().add(const Duration(days: 26)),
          local: 'Secretaria de Obras',
          vagas: 3,
        ),
        Vaga(
          id: '5',
          titulo: 'Gari',
          descricao: 'Serviços de limpeza urbana',
          categoria: 'Limpeza',
          salario: 'R\$ 1.320,00',
          cargaHoraria: '40h semanais',
          requisitos: 'Ensino fundamental, disponibilidade de horário',
          dataPublicacao: DateTime.now().subtract(const Duration(days: 5)),
          dataVencimento: DateTime.now().add(const Duration(days: 25)),
          local: 'Secretaria de Limpeza Urbana',
          vagas: 5,
        ),
      ];
      _vagasFiltradas = _vagas;
      _isLoading = false;
    });
  }

  void _filtrarVagas() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _vagasFiltradas = _vagas.where((vaga) {
        final matchesSearch = vaga.titulo.toLowerCase().contains(query) ||
            vaga.descricao.toLowerCase().contains(query) ||
            vaga.categoria.toLowerCase().contains(query);
        
        final matchesFilter = _filtroSelecionado == 'Todas' ||
            vaga.categoria == _filtroSelecionado;
        
        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _selecionarFiltro(String filtro) {
    setState(() {
      _filtroSelecionado = filtro;
    });
    _filtrarVagas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Vagas de Emprego',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildFilterSection(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildVagasList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      color: AppConstants.primaryColor,
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingMedium,
        0,
        AppConstants.paddingMedium,
        AppConstants.paddingMedium,
      ),
      child: CustomTextField(
        controller: _searchController,
        label: 'Pesquisar vagas',
        hint: 'Digite o cargo ou categoria...',
        prefixIcon: Icons.search,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                },
              )
            : null,
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
        itemCount: _filtros.length,
        itemBuilder: (context, index) {
          final filtro = _filtros[index];
          final isSelected = filtro == _filtroSelecionado;
          
          return Padding(
            padding: const EdgeInsets.only(right: AppConstants.paddingSmall),
            child: FilterChip(
              label: Text(
                filtro,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppConstants.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _selecionarFiltro(filtro);
                }
              },
              backgroundColor: Colors.white,
              selectedColor: AppConstants.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: AppConstants.primaryColor.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVagasList() {
    if (_vagasFiltradas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Nenhuma vaga encontrada',
              style: TextStyle(
                fontSize: AppConstants.fontLarge,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              'Tente ajustar os filtros de pesquisa',
              style: TextStyle(
                fontSize: AppConstants.fontMedium,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregarVagas,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: _vagasFiltradas.length,
        itemBuilder: (context, index) {
          final vaga = _vagasFiltradas[index];
          return VagaCard(
            vaga: vaga,
            onTap: () {
              _mostrarDetalhesVaga(vaga);
            },
          );
        },
      ),
    );
  }

  void _mostrarDetalhesVaga(Vaga vaga) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppConstants.radiusLarge),
                topRight: Radius.circular(AppConstants.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vaga.titulo,
                          style: const TextStyle(
                            fontSize: AppConstants.fontXXLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          vaga.local,
                          style: const TextStyle(
                            fontSize: AppConstants.fontMedium,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingLarge),
                        _buildDetailRow('Salário', vaga.salario),
                        _buildDetailRow('Carga Horária', vaga.cargaHoraria),
                        _buildDetailRow('Vagas Disponíveis', '${vaga.vagas}'),
                        _buildDetailRow('Categoria', vaga.categoria),
                        const SizedBox(height: AppConstants.paddingLarge),
                        const Text(
                          'Descrição',
                          style: TextStyle(
                            fontSize: AppConstants.fontLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          vaga.descricao,
                          style: const TextStyle(
                            fontSize: AppConstants.fontMedium,
                            color: AppConstants.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingLarge),
                        const Text(
                          'Requisitos',
                          style: TextStyle(
                            fontSize: AppConstants.fontLarge,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          vaga.requisitos,
                          style: const TextStyle(
                            fontSize: AppConstants.fontMedium,
                            color: AppConstants.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingXLarge),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implementar candidatura
                              Navigator.of(context).pop();
                              _mostrarDialogoCandidatura(vaga);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                              ),
                            ),
                            child: const Text(
                              'Candidatar-se',
                              style: TextStyle(
                                fontSize: AppConstants.fontLarge,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: AppConstants.fontMedium,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: AppConstants.fontMedium,
                color: AppConstants.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCandidatura(Vaga vaga) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Candidatura'),
        content: Text('Deseja se candidatar para a vaga de ${vaga.titulo}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Candidatura enviada com sucesso!'),
                  backgroundColor: AppConstants.secondaryColor,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
