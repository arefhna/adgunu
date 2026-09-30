import 'package:flutter/material.dart';
import '../models/guest.dart';
import '../utils/formatters.dart';

class GuestTile extends StatelessWidget {
  final Guest guest;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GuestTile({
    super.key,
    required this.guest,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: scheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                guest.name.trim().isEmpty
                    ? '?'
                    : guest.name.trim()[0].toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSecondaryContainer,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guest.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${Fmt.people(guest.count)}  •  ${Fmt.money(guest.amount)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Redaktə',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Sil',
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Qonaq silinsin?'),
                    content: Text(guest.name),
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
                if (ok == true) onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}
