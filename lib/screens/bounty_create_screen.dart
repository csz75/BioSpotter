import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../features/identification/col_match.dart';
import '../l10n/app_localizations.dart';
import 'species_search_screen.dart';

/// Új kitűzés létrehozása (prémium).
class BountyCreateScreen extends ConsumerStatefulWidget {
  const BountyCreateScreen({super.key});

  @override
  ConsumerState<BountyCreateScreen> createState() =>
      _BountyCreateScreenState();
}

class _BountyCreateScreenState extends ConsumerState<BountyCreateScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _points = TextEditingController(text: '1000');

  ColMatch? _species;
  int _maxWinners = 3;
  DateTime? _expires;
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _points.dispose();
    super.dispose();
  }

  Future<void> _pickSpecies() async {
    final match = await Navigator.of(context).push<ColMatch>(
      MaterialPageRoute(builder: (_) => const SpeciesSearchScreen()),
    );
    if (match != null) setState(() => _species = match);
  }

  Future<void> _pickExpiry() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _expires = d);
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context);
    final title = _title.text.trim();
    final points = int.tryParse(_points.text.trim()) ?? 0;

    // A SAJÁT species.id (uuid) — nem a GBIF-szám.
    // Ez kell ahhoz, hogy a beküldés-illeszkedés pontosan működjön.
    final speciesId = _species?.id;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bountyTitleRequired)),
      );
      return;
    }
    if (points <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.bountyPointsRequired)),
      );
      return;
    }

    setState(() => _busy = true);
    final err = await ref.read(bountyRepositoryProvider).createBounty(
          title: title,
          description: _desc.text.trim().isEmpty
              ? null
              : _desc.text.trim(),
          speciesId: speciesId,
          rewardPoints: points,
          maxWinners: _maxWinners,
          expiresAt: _expires,
        );
    if (!mounted) return;
    setState(() => _busy = false);

    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.bountyCreated)),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.bountyCreate)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info: a létrehozás moderátor-jóváhagyást igényel
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.bountyApprovalNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _title,
            decoration: InputDecoration(
              labelText: l.bountyFieldTitle,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _desc,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l.bountyFieldDescription,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Faj (opcionális)
          OutlinedButton.icon(
            icon: const Icon(Icons.search),
            label: Text(
              _species == null
                  ? l.bountyPickSpecies
                  : (_species!.commonName ?? _species!.scientificName ?? ''),
            ),
            onPressed: _pickSpecies,
          ),
          if (_species != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _species!.scientificName ?? '',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          const SizedBox(height: 16),

          TextField(
            controller: _points,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l.bountyFieldPoints,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Nyertesek száma
          Row(
            children: [
              Expanded(child: Text(l.bountyFieldWinners)),
              DropdownButton<int>(
                value: _maxWinners,
                items: const [1, 2, 3, 5, 10]
                    .map((n) => DropdownMenuItem(
                          value: n,
                          child: Text('$n'),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _maxWinners = v ?? 3),
              ),
            ],
          ),
          const SizedBox(height: 16),

          OutlinedButton.icon(
            icon: const Icon(Icons.event),
            label: Text(
              _expires == null
                  ? l.bountyPickExpiry
                  : _expires!.toString().substring(0, 10),
            ),
            onPressed: _pickExpiry,
          ),
          const SizedBox(height: 24),

          FilledButton.icon(
            icon: _busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(l.bountyCreateButton),
            onPressed: _busy ? null : _submit,
          ),
        ],
      ),
    );
  }
}
