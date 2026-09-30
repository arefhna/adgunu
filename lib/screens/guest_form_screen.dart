import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/guest.dart';
import '../providers/event_provider.dart';

class GuestFormScreen extends StatefulWidget {
  final String eventId;
  final Guest? guest;

  const GuestFormScreen({
    super.key,
    required this.eventId,
    this.guest,
  });

  @override
  State<GuestFormScreen> createState() => _GuestFormScreenState();
}

class _GuestFormScreenState extends State<GuestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _countController;
  late final TextEditingController _amountController;
  bool _saving = false;

  bool get _isEditing => widget.guest != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.guest?.name ?? '');
    _countController = TextEditingController(
      text: (widget.guest?.count ?? 1).toString(),
    );
    _amountController = TextEditingController(
      text: widget.guest == null
          ? ''
          : widget.guest!.amount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final name = _nameController.text.trim();
    final count = int.parse(_countController.text.trim());
    final amount =
        double.parse(_amountController.text.trim().replaceAll(',', '.'));

    final provider = context.read<EventProvider>();

    if (_isEditing) {
      await provider.updateGuest(
        widget.eventId,
        widget.guest!.copyWith(name: name, count: count, amount: amount),
      );
    } else {
      await provider.addGuest(
        widget.eventId,
        Guest(
          id: provider.newGuestId(),
          name: name,
          count: count,
          amount: amount,
        ),
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Qonağı redaktə et' : 'Qonaq əlavə et',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  autofocus: !_isEditing,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Ad, soyad',
                    hintText: 'Məsələn: Filankəs Filankəsoğlu',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ad boş ola bilməz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Neçə nəfər gəlib',
                    hintText: '1',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Sayı yazın';
                    }
                    final n = int.tryParse(v.trim());
                    if (n == null || n < 1) {
                      return 'Ən azı 1 nəfər';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Verilən məbləğ (₼)',
                    hintText: '50.00',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Məbləği yazın';
                    }
                    final n =
                        double.tryParse(v.trim().replaceAll(',', '.'));
                    if (n == null || n < 0) {
                      return 'Yanlış məbləğ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _saving ? null : _submit,
                  icon: const Icon(Icons.check),
                  label: Text(_isEditing ? 'Yenilə' : 'Əlavə et'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
