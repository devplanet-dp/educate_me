import 'package:dio/dio.dart';
import 'package:get/get.dart' as G;

import '../../core/utils/app_controller.dart';
import '../../locator.dart';
import '../remote/api_config.dart';
import '../remote/dio_client.dart';
import 'local_storage_service.dart';

class ApiService {
  late DioClient dioClient;

  final String _baseUrl = ApiConfig.baseURL;
  final _localStorage = locator<LocalStorageService>();
  final AppController controller = G.Get.find<AppController>();

  ApiService() {
    var dio = Dio();
    dioClient = DioClient(_baseUrl, dio);
  }
}
