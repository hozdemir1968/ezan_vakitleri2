import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/selection_ctrl.dart';

class SelectStatePage extends ConsumerWidget {
  final int countryId;
  const SelectStatePage({super.key, required this.countryId});

  static const routeName = '/selectStatePage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statesData = ref.watch(statesProvider(countryId));

    return Scaffold(
      appBar: AppBar(title: const Text('İL'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              onChanged: (value) {
                ref.read(stateSearchQueryProvider.notifier).state = value;
              },
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-ZığüşöçİĞÜŞÖÇ ]"))],
              decoration: const InputDecoration(hintText: 'İl...', border: UnderlineInputBorder()),
            ),
          ),
          Expanded(
            child: statesData.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (filteredData) {
                return ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final state = filteredData[index];
                    return ListTile(
                      title: Center(child: Text(state.name ?? '')),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/selectTownPage',
                          arguments: {'stateId': state.id!},
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
