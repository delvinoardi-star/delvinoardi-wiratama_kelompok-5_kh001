import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/api_exception.dart';
import '../services/api_result.dart';

/// Kotak info berwarna untuk menjelaskan perilaku fake API di layar.
class InfoBanner extends StatelessWidget {
  const InfoBanner(this.text, {super.key, this.icon = Icons.info_outline});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: scheme.onSecondaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(color: scheme.onSecondaryContainer)),
          ),
        ],
      ),
    );
  }
}

/// Tampilan saat FutureBuilder berakhir dengan error.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.hint, this.onRetry});

  final Object error;
  final String? hint;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final apiError = error is ApiException ? error as ApiException : null;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: scheme.error),
            const SizedBox(height: 12),
            Text(
              apiError?.message ?? error.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (apiError?.statusCode != null) ...[
              const SizedBox(height: 8),
              StatusChip(apiError!.statusCode!),
            ],
            if (apiError?.body != null) ...[
              const SizedBox(height: 8),
              Text('Body respons: ${apiError!.body!.isEmpty ? '(kosong)' : apiError.body}',
                  style: const TextStyle(fontFamily: 'monospace')),
            ],
            if (hint != null) ...[
              const SizedBox(height: 12),
              Text(hint!, textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Chip status code: hijau untuk 2xx, merah untuk selain itu.
class StatusChip extends StatelessWidget {
  const StatusChip(this.code, {super.key});

  final int code;

  @override
  Widget build(BuildContext context) {
    final ok = code >= 200 && code < 300;
    return Chip(
      avatar: Icon(ok ? Icons.check_circle : Icons.cancel,
          color: ok ? Colors.green.shade700 : Colors.red.shade700, size: 18),
      label: Text('Status code: $code ${_reason(code)}'),
      backgroundColor: ok ? Colors.green.shade50 : Colors.red.shade50,
    );
  }

  static String _reason(int code) {
    switch (code) {
      case 200:
        return 'OK';
      case 201:
        return 'Created';
      case 204:
        return 'No Content';
      case 404:
        return 'Not Found';
      case 500:
        return 'Server Error';
      default:
        return '';
    }
  }
}

/// Kartu hasil request untuk halaman uji: method, URL, status code, body.
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.method,
    required this.url,
    this.statusCode,
    required this.body,
    this.note,
  });

  /// Dari ApiResult (request berhasil).
  factory ResultCard.fromResult(ApiResult<dynamic> r, {String? note}) =>
      ResultCard(
        method: r.method,
        url: r.url,
        statusCode: r.statusCode,
        body: r.body,
        note: note,
      );

  /// Dari ApiException (request gagal / status code bukan sukses).
  factory ResultCard.fromError(String method, String url, Object e,
      {String? note}) {
    final apiError = e is ApiException ? e : null;
    return ResultCard(
      method: method,
      url: url,
      statusCode: apiError?.statusCode,
      body: apiError?.body ?? e.toString(),
      note: [apiError?.message, note].whereType<String>().join('\n'),
    );
  }

  final String method;
  final String url;
  final int? statusCode;
  final String body;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$method  $url',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (statusCode != null)
              StatusChip(statusCode!)
            else
              const Chip(label: Text('Tidak ada respons dari server')),
            const SizedBox(height: 8),
            const Text('Body respons:'),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                prettyJson(body),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
              ),
            ),
            if (note != null && note!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(note!, style: const TextStyle(fontStyle: FontStyle.italic)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Merapikan JSON agar mudah dibaca. Jika bukan JSON, tampilkan apa adanya.
String prettyJson(String raw) {
  if (raw.trim().isEmpty) return '(kosong)';
  try {
    return const JsonEncoder.withIndent('  ').convert(jsonDecode(raw));
  } catch (_) {
    return raw;
  }
}

/// Dialog input ID (dipakai untuk "detail berdasarkan ID" & "hapus berdasarkan ID").
Future<int?> showIdDialog(BuildContext context,
    {required String title, required int initialId}) {
  final controller = TextEditingController(text: '$initialId');
  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'ID'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, int.tryParse(controller.text.trim())),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

/// Dialog konfirmasi sebelum menghapus. Mengembalikan true jika "Hapus".
Future<bool> showConfirmDelete(BuildContext context, String what) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi hapus'),
      content: Text('Yakin ingin menghapus $what?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );
  return result ?? false;
}
