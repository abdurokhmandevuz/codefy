import 'package:flutter/material.dart';
import '../widgets/btn_3d.dart';

class ProPaywallScreen extends StatelessWidget {
  const ProPaywallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryFixed,
              theme.colorScheme.primaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surface.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      'CODEFY PRO',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.surface,
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Mascot
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: Image.asset('assets/images/mascot.png', fit: BoxFit.contain),
                      ),
                      
                      // Headline
                      Text(
                        'O\'rganishni keyingi bosqichga olib chiqing!',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Features
                      _buildFeature(context, Icons.block, 'Reklamasiz tajriba', 'Chalg\'ishlarsiz, faqat bilim o\'rganing.'),
                      const SizedBox(height: 16),
                      _buildFeature(context, Icons.all_inclusive, 'Cheksiz jonlar', 'Xato qilishdan qo\'rqmang, xatolar orqali o\'rganing.'),
                      const SizedBox(height: 16),
                      _buildFeature(context, Icons.workspace_premium, 'Maxsus loyihalar', 'Faqat Pro foydalanuvchilar uchun maxsus amaliy ishlar.'),
                      const SizedBox(height: 32),
                      
                      // Pricing Cards
                      Row(
                        children: [
                          Expanded(
                            child: _buildPricingCard(
                              context,
                              '1 OY',
                              '49,000',
                              'so\'m / oy',
                              false,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPricingCard(
                              context,
                              '12 OY',
                              '39,000',
                              'so\'m / oy',
                              true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom Action
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Btn3D(
                        text: 'PRO GA O\'TISH',
                        backgroundColor: theme.colorScheme.primary,
                        shadowColor: const Color(0xFF4F00D0),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Istalgan vaqtda bekor qilishingiz mumkin.',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(BuildContext context, IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.colorScheme.onPrimary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primaryFixedDim,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard(BuildContext context, String duration, String price, String period, bool isActive) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.surfaceContainerLow : theme.colorScheme.surface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ] : [],
      ),
      child: Column(
        children: [
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ENG MASHHUR',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            duration,
            style: theme.textTheme.titleSmall?.copyWith(
              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            period,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isActive ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.primaryFixedDim,
            ),
          ),
        ],
      ),
    );
  }
}
