// lib/features/board/presentation/notice_write_screen.dart
import 'package:flutter/material.dart';

// 공지 관련
import '../model/notice.dart';
import '../model/notice_category.dart';
import '../repository/notice_repository.dart';

// 앱 공통 디자인
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NoticeWriteScreen extends StatefulWidget {
  const NoticeWriteScreen({super.key});

  @override
  State<NoticeWriteScreen> createState() => _NoticeWriteScreenState();
}

class _NoticeWriteScreenState extends State<NoticeWriteScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _submitting = false;

  // 기본은 일반 공지, 버튼 눌렀을 때만 이벤트/점검으로 변경
  NoticeCategory _category = NoticeCategory.general;

  static const int _titleMax = 80;
  static const int _contentMin = 10;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 레포는 route arguments로 전달받는 구조 유지
    final repo =
        ModalRoute.of(context)!.settings.arguments as NoticeRepository?;

    if (repo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('레포지토리를 전달받지 못했습니다. arguments로 레포를 넘겨주세요.'),
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);

    final now = DateTime.now();
    final draft = Notice(
      id: 0,
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      author: '운영팀',
      createdAt: now,
      category: _category,
      pinned: false,
      views: 0,
      commentCount: 0,
    );

    try {
      final created = await repo.createNotice(draft);
      if (!mounted) return;
      Navigator.pop(context, created);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('작성 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('공지사항 작성')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 섹션 타이틀
                    Text(
                      '공지 정보',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 이벤트 / 점검 카테고리 선택 (list_screen 버튼 스타일 재사용)
                    Row(
                      children: [
                        _buildCategoryPill(
                          NoticeCategory.event,
                          '이벤트',
                          Icons.celebration,
                        ),
                        const SizedBox(width: 8),
                        _buildCategoryPill(
                          NoticeCategory.maintenance,
                          '점검',
                          Icons.build_rounded,
                        ),
                        const Spacer(),
                        if (_category == NoticeCategory.general)
                          Text(
                            '일반 공지',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          )
                        else
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _category = NoticeCategory.general;
                              });
                            },
                            child: Text(
                              '일반 공지로 전환',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 제목 필드
                    Text(
                      '제목',
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleCtrl,
                      maxLength: _titleMax,
                      style: AppTextStyles.body1.copyWith(
                        color: AppColors.primaryText,
                      ),
                      decoration: InputDecoration(
                        hintText: '공지 제목을 입력하세요 (최대 80자)',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.primaryText,
                            width: 1.4,
                          ),
                        ),
                        counterStyle: AppTextStyles.caption.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.isEmpty) return '제목을 입력하세요.';
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 20),

                    // 내용 필드
                    Text(
                      '내용',
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contentCtrl,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primaryText,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        hintText: '공지 내용을 작성하세요. (엔터로 줄바꿈)',
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: AppColors.primaryText,
                            width: 1.4,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 12,
                      minLines: 8,
                      validator: (v) {
                        final s = v?.trim() ?? '';
                        if (s.length < _contentMin) {
                          return '내용은 최소 $_contentMin자 이상 입력하세요.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.secondaryText,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '등록 후 공지 목록에서 확인할 수 있어요.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 작성 완료 버튼
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submit,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>((
                                states,
                              ) {
                                if (states.contains(MaterialState.disabled)) {
                                  return AppColors.border;
                                }
                                if (states.contains(MaterialState.pressed)) {
                                  return AppColors.primaryText.withOpacity(0.9);
                                }
                                if (states.contains(MaterialState.hovered)) {
                                  return AppColors.secondaryText;
                                }
                                return AppColors.primaryText;
                              }),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          textStyle: MaterialStateProperty.all(
                            AppTextStyles.body1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('작성 완료'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== UI blocks =====

  Widget _buildCategoryPill(
    NoticeCategory target,
    String label,
    IconData icon,
  ) {
    final isSelected = _category == target;

    return GestureDetector(
      onTap: () {
        setState(() {
          // 같은 걸 한 번 더 누르면 일반 공지로 돌아가게
          if (_category == target) {
            _category = NoticeCategory.general;
          } else {
            _category = target;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryText.withOpacity(0.9)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryText.withOpacity(0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: isSelected ? Colors.white : AppColors.primaryText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== utils =====

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  String _catLabel(NoticeCategory c) {
    switch (c) {
      case NoticeCategory.general:
        return '일반';
      case NoticeCategory.event:
        return '이벤트';
      case NoticeCategory.maintenance:
        return '점검';
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
