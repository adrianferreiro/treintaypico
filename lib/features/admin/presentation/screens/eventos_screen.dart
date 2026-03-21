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
  const EventosScreen({super.key});

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
      if (updated != null && updated != _selectedEvent) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _selectedEvent = updated;
          });
        });
      }
    }

    return Row(
      children: [
        // Events List (left)
        EventListPanel(
          eventState: eventState,
          selectedEvent: _selectedEvent,
          onEventSelected: (event) {
            setState(() {
              _selectedEvent = event;
            });
          },
          onAddEvent: () {
            showDialog(
              context: context,
              builder: (_) => EventFormDialog(onSave: _loadEvents),
            );
          },
        ),

        // Event Detail (right)
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
                      'Selecciona un evento',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
