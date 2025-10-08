import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _smsCodeController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _showSmsVerification = false;
  String _verificationId = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _showSmsVerification = false;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await _performLogin();
      } else {
        if (!_showSmsVerification) {
          await _sendSmsVerification();
        } else {
          await _verifySmsAndRegister();
        }
      }
    } catch (e) {
      _showErrorDialog('Erro', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performLogin() async {
    // Simular login
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _sendSmsVerification() async {
    // Simular envio de SMS
    await Future.delayed(const Duration(seconds: 1));
    
    // Gerar código de verificação simulado
    _verificationId = '123456';
    
    setState(() {
      _showSmsVerification = true;
    });
    
    _showSuccessDialog('SMS Enviado', 
        'Código de verificação enviado para ${_phoneController.text}');
  }

  Future<void> _verifySmsAndRegister() async {
    if (_smsCodeController.text != '123456') {
      throw Exception('Código de verificação inválido');
    }
    
    // Simular registro
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.paddingXLarge),
                _buildHeader(),
                const SizedBox(height: AppConstants.paddingXLarge),
                _buildForm(),
                const SizedBox(height: AppConstants.paddingLarge),
                _buildSubmitButton(),
                const SizedBox(height: AppConstants.paddingMedium),
                _buildToggleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppConstants.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_city,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppConstants.paddingLarge),
        Text(
          _showSmsVerification 
              ? 'Verificação SMS'
              : _isLogin 
                  ? 'Bem-vindo de volta!'
                  : 'Criar conta',
          style: const TextStyle(
            fontSize: AppConstants.fontXXLarge,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          _showSmsVerification
              ? 'Digite o código enviado para seu celular'
              : _isLogin
                  ? 'Entre na sua conta para continuar'
                  : 'Preencha os dados para se cadastrar',
          style: const TextStyle(
            fontSize: AppConstants.fontMedium,
            color: AppConstants.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    if (_showSmsVerification) {
      return _buildSmsVerificationForm();
    }

    return Column(
      children: [
        if (!_isLogin) ...[
          CustomTextField(
            controller: _nameController,
            label: 'Nome completo',
            prefixIcon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite seu nome';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          CustomTextField(
            controller: _phoneController,
            label: 'Telefone',
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, digite seu telefone';
              }
              if (value.length < 10) {
                return 'Telefone deve ter pelo menos 10 dígitos';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.paddingMedium),
        ],
        CustomTextField(
          controller: _emailController,
          label: 'E-mail',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite seu e-mail';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Por favor, digite um e-mail válido';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        CustomTextField(
          controller: _passwordController,
          label: 'Senha',
          prefixIcon: Icons.lock,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite sua senha';
            }
            if (value.length < 6) {
              return 'Senha deve ter pelo menos 6 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSmsVerificationForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _smsCodeController,
          label: 'Código de verificação',
          prefixIcon: Icons.sms,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite o código';
            }
            if (value.length != 6) {
              return 'Código deve ter 6 dígitos';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        TextButton(
          onPressed: _sendSmsVerification,
          child: const Text('Reenviar código'),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: _isLoading
          ? 'Carregando...'
          : _showSmsVerification
              ? 'Verificar código'
              : _isLogin
                  ? 'Entrar'
                  : 'Cadastrar',
      onPressed: _isLoading ? null : _handleSubmit,
      isLoading: _isLoading,
    );
  }

  Widget _buildToggleButton() {
    if (_showSmsVerification) {
      return TextButton(
        onPressed: () {
          setState(() {
            _showSmsVerification = false;
          });
        },
        child: const Text('Voltar'),
      );
    }

    return TextButton(
      onPressed: _toggleMode,
      child: Text(
        _isLogin
            ? 'Não tem conta? Cadastre-se'
            : 'Já tem conta? Entre',
        style: const TextStyle(
          color: AppConstants.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
