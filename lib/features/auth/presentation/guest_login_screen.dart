import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/custom_button.dart';

class GuestLoginScreen extends StatelessWidget {
  const GuestLoginScreen({super.key});

  void _onContinueAsGuest(BuildContext context) {
    // TODO: 필요하면 guest 플래그 저장
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false, // 👈 이거 추가
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        title: Text(
          '게스트 로그인',
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), // 네가 요즘 좋아하는 16 고정
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 64,
                  color: AppColors.secondaryText,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '게스트로 로그인하시겠습니까?',
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '게스트 계정은 일부 기능이 제한될 수 있습니다.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // 게스트로 계속하기
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: PrimaryButton(
                    text: '게스트로 계속하기',
                    onPressed: () => _onContinueAsGuest(context),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // 취소
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    '취소',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
