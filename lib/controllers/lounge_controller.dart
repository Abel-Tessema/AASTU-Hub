import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/lounge.dart';
import '../services/dio_service.dart';

class LoungeController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = true.obs;
  var lounges = <Lounge>[].obs;

  var selectedLounge = Lounge().obs;

  @override
  void onInit() {
    super.onInit();
    fetchLounges();
  }

  Future<void> fetchLounges() async {
    isLoading.value = true;

    const path =
        "/Lounge?select=id,createdAt,name,latitude,longitude,imageUrl,rating,startTime,endTime,"
        "Lounge_Food(id,price,rating,Food(name,description,imageUrl,isFasting)),"
        "Lounge_Beverage(id,price,rating,Beverage(name,description,imageUrl,isFasting))";

    await DioService.dioGet(
      path: path,
      onSuccess: (response) {
        if (response.data.isNotEmpty) {
          lounges.value = response.data.map<Lounge>((data) {
            return Lounge.fromMap(data);
          }).toList();
        } else {
          lounges.clear();
        }
        isLoading.value = false;
      },
      onFailure: (error, response) {
        Logger().e("Failed to fetch lounges: $error");
        isLoading.value = false;
      },
    );
  }
}
