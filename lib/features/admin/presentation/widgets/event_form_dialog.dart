import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/auth/application/providers/auth_providers.dart';
import 'package:treintaypico/features/auth/application/states/auth_state.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/application/states/category_state.dart';
import 'package:treintaypico/features/events/application/providers/event_providers.dart';

class EventFormDialog extends ConsumerStatefulWidget {
  final VoidCallback onSave;

  const EventFormDialog({
    super.key,
    required this.onSave,
  });

  @override
  ConsumerState<EventFormDialog> createState() => _EventFormDialogState();
}

class _EventFormDialogState extends ConsumerState<EventFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _frontpageController;
  late final TextEditingController _logoController;
  DateTime _selectedDate = DateTime.now();
  final Set<String> _selectedCategoryIds = {};
  bool _isLoading = false;

  static const _defaultFrontpage =
      'https://images.pexels.com/photos/1105666/pexels-photo-1105666.jpeg?auto=compress&cs=tinysrgb&w=800';
  static const _defaultLogo =
      'https://res.cloudinary.com/dgbgtsnbi/image/upload/v1774040932/caramelo_128_r65wbs.png';
  static const _defaultVenueId = 'venue_treintaypico';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _frontpageController = TextEditingController();
    _logoController = TextEditingController();

    // Cargar categorías
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authControllerProvider);
      if (authState is AuthAuthenticated) {
        ref.read(categoryControllerProvider.notifier).loadCategories(
              authState.user.venueId ?? _defaultVenueId,
            );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _frontpageController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accent,
              surface: AppColors.cardDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final authState = ref.read(authControllerProvider);
    if (authState is! AuthAuthenticated) return;

    // Validar que la cuenta no esté suspendida
    final isActive = await ref.read(authControllerProvider.notifier).validateSession();
    if (!isActive && mounted) {
      Navigator.of(context).pop();
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.cardDark,
          title: const Text(
            'Cuenta suspendida',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'Tu cuenta se encuentra suspendida',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: AppColors.accent)),
            ),
          ],
        ),
      );
      if (mounted) context.go('/login');
      return;
    }

    setState(() => _isLoading = true);

    final frontpage = _frontpageController.text.trim().isEmpty
        ? _defaultFrontpage
        : _frontpageController.text.trim();
    final logo = _logoController.text.trim().isEmpty
        ? _defaultLogo
        : _logoController.text.trim();

    await ref.read(eventControllerProvider.notifier).createEvent(
          name: name,
          date: _selectedDate,
          companyId: authState.user.companyId ?? '',
          venueId: _defaultVenueId,
          frontpage: frontpage,
          logo: logo,
          categories: _selectedCategoryIds.toList(),
        );

    if (mounted) {
      widget.onSave();
      Navigator.of(context).pop();
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryControllerProvider);

    return Dialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nuevo Evento',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Nombre (obligatorio)
              TextField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Nombre *',
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.bgInput,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Fecha
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.bgInput,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 12),
                      Text(
                        _formatDate(_selectedDate),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Inter',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Frontpage URL
              TextField(
                controller: _frontpageController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Frontpage URL (opcional)',
                  hintText: 'Default: imagen de concierto',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.bgInput,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Logo URL
              TextField(
                controller: _logoController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Logo URL (opcional)',
                  hintText: 'Default: logo Caramelo',
                  hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  labelStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.bgInput,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Categorías
              const Text(
                'Categorías del evento',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildCategorySelector(categoryState),

              const SizedBox(height: 24),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Crear Evento',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(CategoryState categoryState) {
    return switch (categoryState) {
      CategoryInitial() || CategoryLoading() => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        ),
      CategoryLoaded(:final categories) => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .where((c) => c.isActive)
              .map((category) {
            final isSelected = _selectedCategoryIds.contains(category.id);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedCategoryIds.remove(category.id);
                  } else {
                    _selectedCategoryIds.add(category.id);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : AppColors.bgInput,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.accent : Colors.transparent,
                  ),
                ),
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      CategoryError(:final message) => Text(
          message,
          style: const TextStyle(color: AppColors.cancelRed, fontSize: 12),
        ),
    };
  }
}
