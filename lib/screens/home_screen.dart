import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/empty_state.dart';
import 'event_detail_screen.dart';
import 'event_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    final events = provider.events;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hadisələr',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: !provider.ready
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? const EmptyState(
                  icon: Icons.celebration_outlined,
                  title: 'Hələ hadisə yoxdur',
                  subtitle:
                      'Toy, ad günü və ya nişan üçün yeni bölmə yaradın.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final e = events[i];
                    return EventCard(
                      event: e,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EventDetailScreen(eventId: e.id),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EventFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Yeni hadisə'),
      ),
    );
  }
}
