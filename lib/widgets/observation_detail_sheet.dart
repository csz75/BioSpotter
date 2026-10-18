import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/providers.dart';
import '../features/observations/observation.dart';
import '../l10n/app_localizations.dart';

/// A megfigyelés részletnézete — alsó lap, a nagy fotóval.
///
/// Közös minden nézet számára (kereső, térkép, megfigyeléseim):
/// egyszer kell karbantartani.
///
/// [allowReport]    — mutassa-e a „Jelentés" gombot (mások megfigyelésénél)
/// [showStatusLine] — mutassa-e a moderációs állapotot (a sajátomnál)
Future<void> showObservationDetail(
  BuildContext context,
  WidgetRef ref,
  Observation o,
  String lang, {
  bool allowReport = false,
  bool showStatusLine = false,
}) {
  final l = AppLocalizations.of(context);
  final bigPath = o.photoPath ?? o.photoThumbPath;
  final photoUrl = bigPath != null
      ? ref.read(observationRepositoryProvider).photoUrl(bigPath)
      : null;
  final name =
      o.hasSpecies ? o.displayNameFor(lang) : l.observationsUnknownSpecies;

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            if (photoUrl != null)
              GestureDetector(
                onTap: () => showFullImage(context, photoUrl),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      Image.network(
                        photoUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            height: 220,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (_, __, ___) => const SizedBox(
                          height: 220,
                          child: Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          l.tapForFullSize,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            Text(name, style: Theme.of(ctx).textTheme.titleLarge),
            if (o.scientificName != null && o.scientificName != name) ...[
              const SizedBox(height: 4),
              Text(
                o.scientificName!,
                style: Theme.of(ctx)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
            const SizedBox(height: 8),
            Text(l.observationsGps(
              o.latitude.toStringAsFixed(5),
              o.longitude.toStringAsFixed(5),
            )),
            if (o.observedAt != null)
              Text(l.observationsDateTime(
                  o.observedAt!.toLocal().toString())),

            // ── Moderációs állapot — csak a saját megfigyelésnél ──────
            if (showStatusLine && !o.isPublished) ...[
              const Divider(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _statusIcon(o.moderationStatus),
                    size: 18,
                    color: _statusColor(o.moderationStatus),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _statusLabel(o, l),
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],

            // ── Jelentés — csak MÁSOK megfigyelésénél ─────────────────
            if (allowReport) ...[
              const Divider(height: 32),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(ctx).colorScheme.error,
                ),
                icon: const Icon(Icons.flag_outlined),
                label: Text(l.reportButton),
                onPressed: () => _showReportDialog(ctx, o, l),
              ),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

/// A fotó teljes méretben — külön képernyőn, nagyíthatóan.
void showFullImage(BuildContext context, String url) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            child: Image.network(url, fit: BoxFit.contain),
          ),
        ),
      ),
    ),
  );
}

// ── Segédek ──────────────────────────────────────────────────────────

IconData _statusIcon(String status) {
  switch (status) {
    case 'pending':
      return Icons.hourglass_empty;
    case 'flagged':
      return Icons.flag;
    case 'rejected':
      return Icons.block;
    default:
      return Icons.check_circle;
  }
}

Color _statusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange.shade700;
    case 'flagged':
      return Colors.red.shade700;
    case 'rejected':
      return Colors.grey.shade700;
    default:
      return Colors.green.shade700;
  }
}

String _statusLabel(Observation o, AppLocalizations l) {
  switch (o.moderationStatus) {
    case 'pending':
      return l.statusPending;
    case 'flagged':
      return l.statusFlagged;
    case 'rejected':
      return l.statusRejected;
    default:
      return '';
  }
}

Future<void> _showReportDialog(
  BuildContext context,
  Observation o,
  AppLocalizations l,
) async {
  final reason = await showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text(l.reportTitle),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.of(ctx).pop('not_nature'),
          child: Text(l.reportNotNature),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(ctx).pop('violent'),
          child: Text(l.reportViolent),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(ctx).pop('adult'),
          child: Text(l.reportAdult),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(ctx).pop('other'),
          child: Text(l.reportOther),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(l.reportCancel),
        ),
      ],
    ),
  );

  if (reason == null) return;

  try {
    await Supabase.instance.client.rpc(
      'report_observation',
      params: {
        'p_observation_id': o.id,
        'p_reason': reason,
        'p_note': null,
      },
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.reportSent)),
    );
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l.reportFailed)),
    );
  }
}
