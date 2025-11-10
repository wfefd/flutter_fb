import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 로고나 타이틀
              Text(
                '로그인',
                textAlign: TextAlign.center,
                style: AppTextStyles.h1.copyWith(color: AppColors.primaryText),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 이메일 입력
              CustomTextField(hintText: '이메일 주소', controller: emailController),
              const SizedBox(height: AppSpacing.md),

              // 비밀번호 입력
              CustomTextField(hintText: '비밀번호', controller: passwordController),
              const SizedBox(height: AppSpacing.lg),

              // 로그인 버튼
              PrimaryButton(
                text: '로그인',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // 회원가입 / 아이디 / 비밀번호 찾기
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextButton(
                    label: '회원가입',
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                  ),
                  _buildTextButton(
                    label: 'ID 찾기',
                    onPressed: () => Navigator.pushNamed(context, '/find_id'),
                  ),
                  _buildTextButton(
                    label: '비밀번호 찾기',
                    onPressed: () =>
                        Navigator.pushNamed(context, '/find_password'),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              // 게스트 로그인
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  icon: const Icon(Icons.person_outline),
                  label: Text(
                    '게스트 로그인',
                    style: AppTextStyles.body1.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 공통 서브 텍스트 버튼
  Widget _buildTextButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: AppTextStyles.body2.copyWith(color: AppColors.primaryText),
      ),
    );
  }
}
