import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../controllers/auth_controller.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400,
                minHeight: size.height - 32, // Ajustado para evitar overflow
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Card principal
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Logo
                              Container(
                                width: 180,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: AppColors.backgroundLight,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.business,
                                  size: 40,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Texto abaixo do logo
                              Text(
                                'A verdade do seu negócio em suas mãos',
                                style: AppTextStyles.subtitle2.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 40),

                              // Email
                              CustomTextField(
                                label: 'E-mail',
                                hint: 'Informe seu e-mail',
                                controller: controller.emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: controller.validateEmail,
                                prefixIcon: Icons.email_outlined,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),

                              // Senha
                              CustomTextField(
                                label: 'Senha',
                                hint: 'Informe sua senha',
                                controller: controller.passwordController,
                                obscureText: true,
                                validator: controller.validatePassword,
                                prefixIcon: Icons.lock_outline,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) =>
                                    _handleLogin(controller),
                              ),
                              const SizedBox(height: 24),

                              // Mensagem de erro - Usando GetBuilder em vez de Obx
                              GetBuilder<AuthController>(
                                id: 'error_message',
                                builder: (controller) {
                                  if (controller.errorMessage.isNotEmpty) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.error
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: AppColors.error
                                                .withValues(alpha: 0.5),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.error_outline,
                                              color: AppColors.error,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                controller.errorMessage,
                                                style: AppTextStyles.bodyText2
                                                    .copyWith(
                                                  color: AppColors.error,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),

                              // Botão Entrar - Usando GetBuilder em vez de Obx
                              GetBuilder<AuthController>(
                                id: 'loading',
                                builder: (controller) {
                                  return CustomButton(
                                    text: 'Entrar',
                                    onPressed: () => _handleLogin(controller),
                                    isLoading: controller.isLoading,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Espaçamento adicional para evitar overflow
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método para lidar com o login
  void _handleLogin(AuthController controller) {
    // Remove o foco dos campos
    FocusScope.of(Get.context!).unfocus();

    // Executa o login
    controller.login();
  }
}
