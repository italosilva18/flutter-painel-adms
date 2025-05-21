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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
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
                            Image.asset(
                              'assets/images/margem_logo.png',
                              width: 180,
                              height: 80,
                              fit: BoxFit.contain,
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
                            Obx(() {
                              return CustomTextField(
                                label: 'Senha',
                                hint: 'Informe sua senha',
                                controller: controller.passwordController,
                                obscureText: true,
                                validator: controller.validatePassword,
                                prefixIcon: Icons.lock_outline,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => controller.login(),
                              );
                            }),
                            const SizedBox(height: 24),

                            // Mensagem de erro
                            Obx(() {
                              if (controller.errorMessage.isNotEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    controller.errorMessage,
                                    style: AppTextStyles.bodyText2.copyWith(
                                      color: AppColors.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            }),

                            // Botão Entrar
                            Obx(() {
                              return CustomButton(
                                text: 'Entrar',
                                onPressed: controller.login,
                                isLoading: controller.isLoading,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
