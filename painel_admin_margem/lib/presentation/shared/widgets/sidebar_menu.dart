// lib/presentation/shared/widgets/sidebar_menu.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../auth/controllers/auth_controller.dart';

class SidebarMenu extends StatelessWidget {
  final int selectedIndex;

  // Convertido para usar super parameter para 'key'
  const SidebarMenu({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Drawer(
      child: Column(
        children: [
          // Cabeçalho do menu
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo ou ícone
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.business,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                // Nome do usuário logado
                Text(
                  authController.currentUser?.name ?? 'Usuário',
                  style: AppTextStyles.subtitle1.copyWith(
                    color: Colors.white,
                  ),
                ),
                // Email do usuário
                Text(
                  authController.currentUser?.email ?? 'email@exemplo.com',
                  style: AppTextStyles.bodyText2.copyWith(
                    // Substituído withOpacity por withValues para evitar erro de depreciação
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Item de menu: Lojas
          _buildMenuItem(
            icon: Icons.store,
            title: 'Lojas',
            isSelected: selectedIndex == 0,
            onTap: () => Get.offAllNamed('/stores'),
          ),

          // Item de menu: Usuários Mobile
          _buildMenuItem(
            icon: Icons.phone_android,
            title: 'Usuários Mobile',
            isSelected: selectedIndex == 1,
            onTap: () => Get.offAllNamed('/mobile'),
          ),

          // Item de menu: Suporte
          _buildMenuItem(
            icon: Icons.support_agent,
            title: 'Suporte',
            isSelected: selectedIndex == 2,
            onTap: () => Get.offAllNamed('/support'),
          ),

          // Espaçador flexível
          const Spacer(),

          // Divisor
          const Divider(),

          // Botão de logout
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Sair',
            isSelected: false,
            onTap: () => _showLogoutConfirmation(context),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Constrói um item do menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: isSelected ? AppTextStyles.navItemActive : AppTextStyles.navItem,
      ),
      selected: isSelected,
      selectedTileColor: AppColors.backgroundLight,
      onTap: onTap,
    );
  }

  // Mostra diálogo de confirmação para logout
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sair',
          style: AppTextStyles.headline3,
        ),
        content: Text(
          'Tem certeza que deseja sair do sistema?',
          style: AppTextStyles.bodyText2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final authController = Get.find<AuthController>();
              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
