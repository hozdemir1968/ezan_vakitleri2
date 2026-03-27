import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/country_model.dart';
import '../models/state_model.dart';
import '../models/town_model.dart';
import '../services/api_service.dart';
import 'prayer_time_ctrl.dart';

// COUNTRY
// Arama metni için provider
final countrySearchQueryProvider = StateProvider<String>((ref) => "");

// Ülkeleri çekip filtreleyen ana provider
final countriesProvider = FutureProvider<List<CountryModel>>((ref) async {
  final apiService = ApiService();
  final allCountries = await apiService.getCountries();

  // Özel sıralama mantığınız
  final northCyprus = allCountries.firstWhere((item) => item.code == "NORTH CYPRUS");
  allCountries.removeWhere((item) => item.code == "NORTH CYPRUS");
  allCountries.add(northCyprus);

  // Arama filtresini uygula
  final query = ref.watch(countrySearchQueryProvider).toLowerCase();
  if (query.isEmpty) return allCountries;

  return allCountries.where((e) => (e.name ?? '').toLowerCase().contains(query)).toList();
});

// STATE
// Arama metni için provider
final stateSearchQueryProvider = StateProvider<String>((ref) => "");

// İl verilerini çeken ve filtreleyen provider .family<DönecekVeriTipi, AlacağıParametreTipi>
final statesProvider = FutureProvider.family<List<StateModel>, int>((ref, countryId) async {
  final apiService = ApiService();
  final allStates = await apiService.getStates(countryId);

  // Arama metnini izle
  final query = ref.watch(stateSearchQueryProvider).toLowerCase();
  if (query.isEmpty) return allStates;

  return allStates.where((e) {
    return (e.name ?? '').toLowerCase().contains(query);
  }).toList();
});

// TOWN
// Arama metni için provider
final townSearchQueryProvider = StateProvider<String>((ref) => "");

// İlçe listesini getiren ve filtreleyen provider
final townsProvider = FutureProvider.family<List<TownModel>, int>((ref, stateId) async {
  final apiService = ApiService();
  final allTowns = await apiService.getTowns(stateId);

  final query = ref.watch(townSearchQueryProvider).toLowerCase();

  if (query.isEmpty) return allTowns;

  return allTowns.where((e) => (e.name ?? '').toLowerCase().contains(query)).toList();
});
