import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treintaypico/core/styles/app_colors.dart';
import 'package:treintaypico/features/admin/presentation/widgets/event_detail_panel.dart';
import 'package:treintaypico/features/admin/presentation/widgets/event_form_dialog.dart';
import 'package:treintaypico/features/admin/presentation/widgets/event_list_panel.dart';
import 'package:treintaypico/features/auth/application/providers/auth_providers.dart';
import 'package:treintaypico/features/auth/application/states/auth_state.dart';
import 'package:treintaypico/features/events/application/providers/event_providers.dart';
import 'package:treintaypico/features/events/application/states/event_state.dart';
import 'package:treintaypico/features/events/domain/entities/event_entity.dart';

class EventosScreen extends ConsumerStatefulWidget {
  final bool isPortrait;

  const EventosScreen({super.key, this.isPortrait = false});

  @override
  ConsumerState<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends ConsumerState<EventosScreen> {
  EventEntity? _selectedEvent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents();
    });
  }

  void _loadEvents() {
    final authState = ref.read(authControllerProvider);
    if (authState is AuthAuthenticated) {
      ref.read(eventControllerProvider.notifier).loadEvents(
            authState.user.companyId ?? '',
          );
    }
  }

  void _handleAddEvent() {
    final eventState = ref.read(eventControllerProvider);
    if (eventState is EventLoaded) {
      final hasActiveEvent = eventState.events.any((e) => e.isAvailable);
      if (hasActiveEvent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Antes de crear un nuevo evento, debes desactivar el activo'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }
    showDialog(
      context: context,
      builder: (_) => EventFormDialog(onSave: _loadEvents),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventControllerProvider);

    // Auto-select first event when loaded
    if (eventState is EventLoaded && _selectedEvent == null && eventState.events.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedEvent = eventState.events.first;
        });
      });
    }

    // Keep selected event in sync with state
    if (eventState is EventLoaded && _selectedEvent != null) {
      final updated = eventState.events.where((e) => e.id == _selectedEvent!.id).firstOrNull;
      if (updated == null) {
        // Event was deactivated and no longer in the list
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _selectedEvent = eventState.events.firstOrNull;
          });
        });
      } else if (updated != _selectedEvent) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _selectedEvent = updated;
          });
        });
      }
    }

    if (widget.isPortrait) {
      return _buildPortraitLayout(eventState);
    }

    return _buildLandscapeLayout(eventState);
  }

  Widget _buildLandscapeLayout(EventState eventState) {
    return Row(
      children: [
        EventListPanel(
          eventState: eventState,
          selectedEvent: _selectedEvent,
          onEventSelected: (event) {
            setState(() {
              _selectedEvent = event;
            });
          },
          onAddEvent: _handleAddEvent,
        ),
        Expanded(
          child: Container(
            color: AppColors.darkBackground,
            child: _selectedEvent != null
                ? EventDetailPanel(
                    event: _selectedEvent!,
                    onEventUpdated: _loadEvents,
                  )
                : const Center(
                    child: Text(
                      'No hay evento activo. Crea uno nuevo.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(EventState eventState) {
    return Container(
      color: AppColors.darkBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
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
                onTap: _handleAddEvent,
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
          const SizedBox(height: 12),

          // Event List (compact, scrollable)
          SizedBox(
            height: 200,
            child: EventListPanel(
              eventState: eventState,
              selectedEvent: _selectedEvent,
              isPortrait: true,
              onEventSelected: (event) {
                setState(() {
                  _selectedEvent = event;
                });
              },
            ),
          ),
          const SizedBox(height: 12),

          // Event Detail
          Expanded(
            child: _selectedEvent != null
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: EventDetailPanel(
                      event: _selectedEvent!,
                      onEventUpdated: _loadEvents,
                      isPortrait: true,
                    ),
                  )
                : const Center(
                    child: Text(
                      'No hay evento activo. Crea uno nuevo.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
