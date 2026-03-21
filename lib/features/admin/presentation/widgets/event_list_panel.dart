import 'package:flutter/material.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/events/application/states/event_state.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';

class EventListPanel extends StatelessWidget {
  final EventState eventState;
  final EventEntity? selectedEvent;
  final ValueChanged<EventEntity> onEventSelected;
  final VoidCallback? onAddEvent;

  const EventListPanel({
    super.key,
    required this.eventState,
    required this.selectedEvent,
    required this.onEventSelected,
    this.onAddEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      color: AppColors.darkBackground,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Text(
                'Eventos',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onAddEvent,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Event List
          Expanded(
            child: switch (eventState) {
              EventInitial() || EventLoading() => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
              EventLoaded(:final events) => ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final isSelected = selectedEvent?.id == event.id;
                    return _EventRow(
                      event: event,
                      isSelected: isSelected,
                      onTap: () => onEventSelected(event),
                    );
                  },
                ),
              EventError(:final message) => Center(
                  child: Text(
                    message,
                    style: const TextStyle(color: AppColors.cancelRed),
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final EventEntity event;
  final bool isSelected;
  final VoidCallback onTap;

  const _EventRow({
    required this.event,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? const Border(
                  left: BorderSide(
                    color: AppColors.badgePaid,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _StatusBadge(isAvailable: event.isAvailable),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  _formatDate(event.date),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
                if (event.venueName != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    event.venueName!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAvailable;

  const _StatusBadge({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isAvailable
            ? const Color(0x334CAF50)
            : const Color(0x339E9E9E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isAvailable ? 'Activo' : 'Inactivo',
        style: TextStyle(
          color: isAvailable ? AppColors.badgePaid : AppColors.textSecondary,
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
