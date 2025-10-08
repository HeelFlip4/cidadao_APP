import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../constants/app_constants.dart';
import '../widgets/notification_card.dart';
import '../widgets/service_card.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  
  final List<Map<String, String>> _banners = [
    {
      'title': 'Nova Praça Inaugurada',
      'subtitle': 'Confira a nova praça do bairro Centro',
      'image': 'assets/images/banner1.jpg',
    },
    {
      'title': 'Campanha de Vacinação',
      'subtitle': 'Vacine-se contra a gripe nas UBS',
      'image': 'assets/images/banner2.jpg',
    },
    {
      'title': 'Obras na Avenida Principal',
      'subtitle': 'Melhorias no trânsito em andamento',
      'image': 'assets/images/banner3.jpg',
    },
  ];

  final List<Map<String, dynamic>> _servicesData = [
    {
      'title': 'Ocorrências',
      'icon': Icons.report_problem,
      'color': AppConstants.errorColor,
      'route': '/ocorrencias',
    },
    {
      'title': 'Vagas',
      'icon': Icons.work,
      'color': AppConstants.secondaryColor,
      'route': '/vagas',
    },
    {
      'title': 'Telefones',
      'icon': Icons.phone,
      'color': AppConstants.primaryColor,
      'route': '/telefones',
    },
    {
      'title': 'Notícias',
      'icon': Icons.newspaper,
      'color': AppConstants.warningColor,
      'route': '/noticias',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildNotificationCard(),
              _buildBannerCarousel(),
              _buildServicesSection(),
              _buildCategoriesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppConstants.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusLarge),
          bottomRight: Radius.circular(AppConstants.radiusLarge),
        ),
      ),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Olá, Cidadão!',
                    style: TextStyle(
                      fontSize: AppConstants.fontXLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Como podemos ajudar hoje?',
                    style: TextStyle(
                      fontSize: AppConstants.fontMedium,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Implementar notificações
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: NotificationCard(
        title: 'Status da Ocorrência',
        message: 'Sua ocorrência #12345 foi atualizada',
        type: NotificationType.info,
        onTap: () {
          // Navegar para detalhes da ocorrência
        },
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
          ),
          items: _banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    gradient: LinearGradient(
                      colors: [
                        AppConstants.primaryColor.withOpacity(0.8),
                        AppConstants.primaryColor.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner['title']!,
                          style: const TextStyle(
                            fontSize: AppConstants.fontXLarge,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          banner['subtitle']!,
                          style: const TextStyle(
                            fontSize: AppConstants.fontMedium,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerIndex == entry.key
                    ? AppConstants.primaryColor
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SERVIÇOS MAIS ACESSADOS',
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
              childAspectRatio: 1.2,
            ),
            itemCount: _servicesData.length,
            itemBuilder: (context, index) {
              final service = _servicesData[index];
              return ServiceCard(
                title: service['title'],
                icon: service['icon'],
                color: service['color'],
                onTap: () {
                  Navigator.of(context).pushNamed(service['route']);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CATEGORIAS',
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
              crossAxisCount: 3,
              crossAxisSpacing: AppConstants.paddingMedium,
              mainAxisSpacing: AppConstants.paddingMedium,
              childAspectRatio: 1,
            ),
            itemCount: AppConstants.categorias.length,
            itemBuilder: (context, index) {
              final categoria = AppConstants.categorias[index];
              return CategoryCard(
                title: categoria['nome'],
                icon: categoria['icon'],
                color: categoria['color'],
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/ocorrencias',
                    arguments: categoria['id'],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
