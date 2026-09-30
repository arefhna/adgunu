import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/event_provider.dart';
import '../utils/formatters.dart';
import '../widgets/empty_state.dart';
import '../widgets/guest_tile.dart';
import '../widgets/total_summary.dart';
import 'guest_form_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  Future<void> _confirmDelete(BuildContext context, Event event) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hadisə silinsin?'),
        content: Text('"${event.title}" və bütün qonaqlar silinəcək.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Ləğv et'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<EventProvider>().deleteEvent(event.id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> _rename(BuildContext context, Event event) async {
    final controller = TextEditingController(text: event.title);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Adı dəyiş'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Hadisə adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ləğv et'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Yadda saxla'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty && context.mounted) {
      await context.read<EventProvider>().renameEvent(event.id, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final event = provider.eventById(eventId);

    if (event == null) {
      return const Scaffold(
        body: Center(child: Text('Hadisə tapılmadı')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _rename(context, event),
            tooltip: 'Adı dəyiş',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, event),
            tooltip: 'Sil',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: event.guests.isEmpty
                ? const EmptyState(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Qonaq yoxdur',
                    subtitle:
                        'Aşağıdakı düymə ilə ilk qonağı əlavə edin.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: event.guests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final g = event.guests[i];
                      return GuestTile(
                        guest: g,
                        onEdit: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GuestFormScreen(
                                eventId: event.id,
                                guest: g,
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          context
                              .read<EventProvider>()
                              .removeGuest(event.id, g.id);
                        },
                      );
                    },
                  ),
          ),
          TotalSummary(event: event),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => GuestFormScreen(eventId: event.id),
            ),
          );
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Qonaq əlavə et'),
      ),
    );
  }
}
