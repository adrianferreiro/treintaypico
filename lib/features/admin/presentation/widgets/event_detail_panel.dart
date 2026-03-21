import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/auth/application/providers/auth_providers.dart';
import 'package:treintaypico/features/auth/application/states/auth_state.dart';
import 'package:treintaypico/features/categories/application/providers/category_providers.dart';
import 'package:treintaypico/features/categories/application/states/category_state.dart';
import 'package:treintaypico/features/events/application/providers/event_providers.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';

class EventDetailPanel extends ConsumerStatefulWidget {
  final EventEntity event;
  final VoidCallback onEventUpdated;

  const EventDetailPanel({
    super.key,
    required this.event,
    required this.onEventUpdated,
  });

  @override
  ConsumerState<EventDetailPanel> createState() => _EventDetailPanelState();
}

class _EventDetailPanelState extends ConsumerState<EventDetailPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  void _loadCategories() {
    final authState = ref.read(authControllerProvider);
    if (authState is AuthAuthenticated) {
      ref.read(categoryControllerProvider.notifier).loadCategories(
            authState.user.venueId ?? 'venue_treintaypico',
          );
    }
  }

  void _toggleCategory(String categoryId, bool enable) {
    final currentCategories = List<String>.from(widget.event.categories);
    if (enable) {
      if (!currentCategories.contains(categoryId)) {
        currentCategories.add(categoryId);
      }
    } else {
      currentCategories.remove(categoryId);
    }

    ref.read(eventControllerProvider.notifier).updateEventCategories(
          eventId: widget.event.id,
          categories: currentCategories,
        );
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.event.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(eventControllerProvider.notifier).toggleEventAvailable(
                        id: widget.event.id,
                        isAvailable: !widget.event.isAvailable,
                      );
                },
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.bgInput,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.event.isAvailable ? Icons.pause : Icons.play_arrow,
                        color: AppColors.textPrimary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.event.isAvailable ? 'Desactivar' : 'Activar',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Info Row
          Row(
            children: [
              _InfoBlock(label: 'Fecha', value: _formatDate(widget.event.date)),
              const SizedBox(width: 24),
              _InfoBlock(label: 'Lugar', value: widget.event.venueName ?? '-'),
              const SizedBox(width: 24),
              _InfoBlock(
                label: 'Estado',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.event.isAvailable
                        ? const Color(0x334CAF50)
                        : const Color(0x339E9E9E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.event.isAvailable ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      color: widget.event.isAvailable ? AppColors.badgePaid : AppColors.textSecondary,
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Categories Section
          const Text(
            'Categorías del Evento',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: _buildCategoryList(categoryState),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(CategoryState categoryState) {
    return switch (categoryState) {
      CategoryInitial() || CategoryLoading() => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      CategoryLoaded(:final categories) => ListView.separated(
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isEnabled = widget.event.categories.contains(category.id);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: isEnabled ? AppColors.textPrimary : AppColors.textSecondary,
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: isEnabled ? null : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                  Switch(
                    value: isEnabled,
                    onChanged: (value) => _toggleCategory(category.id, value),
                    activeThumbColor: AppColors.accent,
                    activeTrackColor: AppColors.accent,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.bgInput,
                  ),
                ],
              ),
            );
          },
        ),
      CategoryError(:final message) => Center(
          child: Text(
            message,
            style: const TextStyle(color: AppColors.cancelRed),
          ),
        ),
    };
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? child;

  const _InfoBlock({
    required this.label,
    this.value,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'Inter',
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        child ??
            Text(
              value ?? '',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
      ],
    );
  }
}
