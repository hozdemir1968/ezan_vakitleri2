import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/providers.dart';

class SelectCountryPage extends ConsumerWidget {
  const SelectCountryPage({super.key});

  static const routeName = '/selectCountryPage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesData = ref.watch(countriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('ÜLKE'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) => ref.read(countrySearchQueryProvider.notifier).state = value,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-ZığüşöçİĞÜŞÖÇ ]"))],
              decoration: const InputDecoration(
                hintText: 'Ülke...',
                border: UnderlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: countriesData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (filteredData) => ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final country = filteredData[index];
                  return ListTile(
                    title: Center(child: Text(country.name ?? '')),
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/selectStatePage',
                      arguments: {'countryId': country.id!},
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
