import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prak_arsitektur_tugas/main.dart';

void main() {
  for (final mode in ['MVC', 'MVVM']) {
    testWidgets('$mode menyaring tugas belum selesai dengan benar',
        (tester) async {
      await tester.pumpWidget(const AplikasiTugas());
      await tester.tap(find.text('Buka $mode'));
      await tester.pumpAndSettle();

      final input = find.byKey(const ValueKey('judul-tugas'));
      final tambah = find.text('Tambah tugas');
      final filterChip = find.byKey(const ValueKey('filter-belum-selesai'));

      // 1. Tambah dua tugas, lalu centang tugas pertama
      await tester.enterText(input, 'Rancang UI Flutter');
      await tester.tap(tambah);
      await tester.pumpAndSettle();

      await tester.enterText(input, 'Catat hasil pengujian');
      await tester.tap(tambah);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rancang UI Flutter'));
      await tester.pumpAndSettle();

      expect(find.text('Rancang UI Flutter'), findsOneWidget);
      expect(find.text('Catat hasil pengujian'), findsOneWidget);
      expect(find.text('1 dari 2 selesai'), findsOneWidget);

      // 2. Aktifkan filter
      await tester.tap(filterChip);
      await tester.pumpAndSettle();

      expect(find.text('Rancang UI Flutter'), findsNothing);
      expect(find.text('Catat hasil pengujian'), findsOneWidget);
      expect(find.text('1 dari 2 selesai'), findsOneWidget);

      // 3. Matikan filter
      await tester.tap(filterChip);
      await tester.pumpAndSettle();

      expect(find.text('Rancang UI Flutter'), findsOneWidget);
      expect(find.text('Catat hasil pengujian'), findsOneWidget);
      final checkboxPertama = tester.widget<CheckboxListTile>(
        find.widgetWithText(CheckboxListTile, 'Rancang UI Flutter'),
      );
      expect(checkboxPertama.value, isTrue);

      // 4. Aktifkan filter lagi, lalu centang tugas kedua
      await tester.tap(filterChip);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Catat hasil pengujian'));
      await tester.pumpAndSettle();

      expect(
        find.text('Tidak ada tugas yang belum selesai.'),
        findsOneWidget,
      );
      expect(find.text('2 dari 2 selesai'), findsOneWidget);
    });
  }
}