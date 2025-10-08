import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../models/ocorrencia_model.dart';

class OcorrenciasScreen extends StatefulWidget {
  final String? categoriaInicial;
  
  const OcorrenciasScreen({
    super.key,
    this.categoriaInicial,
  });

  @override
  State<OcorrenciasScreen> createState() => _OcorrenciasScreenState();
}

class _OcorrenciasScreenState extends State<OcorrenciasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  
  String? _categoriaSelecionada;
  String? _subcategoriaSelecionada;
  List<File> _imagens = [];
  Position? _localizacao;
  bool _isLoading = false;
  bool _carregandoLocalizacao = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.categoriaInicial != null) {
      _categoriaSelecionada = widget.categoriaInicial;
    }
    _obterLocalizacao();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _obterLocalizacao() async {
    setState(() {
      _carregandoLocalizacao = true;
    });

    try {
      // Verificar permissões
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _mostrarErro('Permissão de localização negada');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _mostrarErro('Permissão de localização negada permanentemente');
        return;
      }

      // Obter localização atual
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _localizacao = position;
      });
    } catch (e) {
      _mostrarErro('Erro ao obter localização: $e');
    } finally {
      setState(() {
        _carregandoLocalizacao = false;
      });
    }
  }

  Future<void> _adicionarImagem() async {
    if (_imagens.length >= 3) {
      _mostrarErro('Máximo de 3 imagens permitidas');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imagens.add(File(image.path));
        });
      }
    } catch (e) {
      _mostrarErro('Erro ao capturar imagem: $e');
    }
  }

  Future<void> _adicionarImagemGaleria() async {
    if (_imagens.length >= 3) {
      _mostrarErro('Máximo de 3 imagens permitidas');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _imagens.add(File(image.path));
        });
      }
    } catch (e) {
      _mostrarErro('Erro ao selecionar imagem: $e');
    }
  }

  void _removerImagem(int index) {
    setState(() {
      _imagens.removeAt(index);
    });
  }

  Future<void> _enviarOcorrencia() async {
    if (!_formKey.currentState!.validate()) return;

    if (_categoriaSelecionada == null) {
      _mostrarErro('Selecione uma categoria');
      return;
    }

    if (_subcategoriaSelecionada == null) {
      _mostrarErro('Selecione um assunto');
      return;
    }

    if (_localizacao == null) {
      _mostrarErro('Localização é obrigatória. Tente obter novamente.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final ocorrencia = Ocorrencia(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        categoria: _categoriaSelecionada!,
        subcategoria: _subcategoriaSelecionada!,
        descricao: _descricaoController.text,
        latitude: _localizacao!.latitude,
        longitude: _localizacao!.longitude,
        imagens: _imagens.map((img) => img.path).toList(),
        dataOcorrencia: DateTime.now(),
        status: StatusOcorrencia.aberta,
      );

      // Simular envio
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _mostrarSucesso();
      }
    } catch (e) {
      _mostrarErro('Erro ao enviar ocorrência: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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

  void _mostrarSucesso() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppConstants.secondaryColor,
            ),
            SizedBox(width: 8),
            Text('Sucesso!'),
          ],
        ),
        content: const Text(
          'Sua ocorrência foi enviada com sucesso! '
          'Você receberá atualizações sobre o andamento.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar dialog
              Navigator.of(context).pop(); // Voltar para tela anterior
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? get _categoriaAtual {
    if (_categoriaSelecionada == null) return null;
    return AppConstants.categorias.firstWhere(
      (cat) => cat['id'] == _categoriaSelecionada,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Nova Ocorrência',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoriaSection(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildSubcategoriaSection(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildDescricaoSection(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildImagensSection(),
              const SizedBox(height: AppConstants.paddingLarge),
              _buildLocalizacaoSection(),
              const SizedBox(height: AppConstants.paddingXLarge),
              _buildEnviarButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoria',
          style: TextStyle(
            fontSize: AppConstants.fontLarge,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppConstants.paddingMedium,
            mainAxisSpacing: AppConstants.paddingMedium,
            childAspectRatio: 2.5,
          ),
          itemCount: AppConstants.categorias.length,
          itemBuilder: (context, index) {
            final categoria = AppConstants.categorias[index];
            final isSelected = _categoriaSelecionada == categoria['id'];
            
            return Container(
              decoration: BoxDecoration(
                color: isSelected ? categoria['color'].withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(
                  color: isSelected ? categoria['color'] : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  onTap: () {
                    setState(() {
                      _categoriaSelecionada = categoria['id'];
                      _subcategoriaSelecionada = null; // Reset subcategoria
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    child: Row(
                      children: [
                        Icon(
                          categoria['icon'],
                          color: categoria['color'],
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.paddingSmall),
                        Expanded(
                          child: Text(
                            categoria['nome'],
                            style: TextStyle(
                              fontSize: AppConstants.fontMedium,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? categoria['color'] : AppConstants.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubcategoriaSection() {
    if (_categoriaAtual == null) {
      return const SizedBox.shrink();
    }

    final subcategorias = _categoriaAtual!['subcategorias'] as List<String>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assunto',
          style: TextStyle(
            fontSize: AppConstants.fontLarge,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonFormField<String>(
            value: _subcategoriaSelecionada,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingMedium,
              ),
              border: InputBorder.none,
            ),
            hint: const Text('Selecione o assunto'),
            items: subcategorias.map((subcategoria) {
              return DropdownMenuItem(
                value: subcategoria,
                child: Text(subcategoria),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _subcategoriaSelecionada = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDescricaoSection() {
    return CustomTextField(
      controller: _descricaoController,
      label: 'Descrição da Ocorrência',
      hint: 'Descreva detalhadamente o problema...',
      maxLines: 4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, descreva a ocorrência';
        }
        if (value.length < 10) {
          return 'Descrição deve ter pelo menos 10 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildImagensSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fotos (Opcional)',
          style: TextStyle(
            fontSize: AppConstants.fontLarge,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        const Text(
          'Adicione até 3 fotos para ilustrar o problema',
          style: TextStyle(
            fontSize: AppConstants.fontMedium,
            color: AppConstants.textSecondary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        if (_imagens.isNotEmpty) ...[
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagens.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: AppConstants.paddingSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    image: DecorationImage(
                      image: FileImage(_imagens[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removerImagem(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppConstants.errorColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
        ],
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _imagens.length < 3 ? _adicionarImagem : null,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Câmera'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.primaryColor,
                  side: const BorderSide(color: AppConstants.primaryColor),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _imagens.length < 3 ? _adicionarImagemGaleria : null,
                icon: const Icon(Icons.photo_library),
                label: const Text('Galeria'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.primaryColor,
                  side: const BorderSide(color: AppConstants.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocalizacaoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Localização',
          style: TextStyle(
            fontSize: AppConstants.fontLarge,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _localizacao != null ? Icons.location_on : Icons.location_off,
                    color: _localizacao != null ? AppConstants.secondaryColor : AppConstants.errorColor,
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: Text(
                      _carregandoLocalizacao
                          ? 'Obtendo localização...'
                          : _localizacao != null
                              ? 'Localização obtida com sucesso'
                              : 'Localização não obtida',
                      style: TextStyle(
                        fontSize: AppConstants.fontMedium,
                        fontWeight: FontWeight.w500,
                        color: _localizacao != null ? AppConstants.secondaryColor : AppConstants.errorColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (_localizacao != null) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'Lat: ${_localizacao!.latitude.toStringAsFixed(6)}\n'
                  'Lng: ${_localizacao!.longitude.toStringAsFixed(6)}',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSmall,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppConstants.paddingMedium),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _carregandoLocalizacao ? null : _obterLocalizacao,
                  icon: _carregandoLocalizacao
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(_carregandoLocalizacao ? 'Obtendo...' : 'Obter Localização'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppConstants.primaryColor,
                    side: const BorderSide(color: AppConstants.primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnviarButton() {
    return CustomButton(
      text: 'Enviar Ocorrência',
      onPressed: _enviarOcorrencia,
      isLoading: _isLoading,
      icon: Icons.send,
    );
  }
}
