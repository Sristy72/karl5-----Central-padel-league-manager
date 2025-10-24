import 'dart:io';
import 'package:get/get.dart' hide FormData, MultipartFile;
import '../../../../core/network/services/multiple_form_data_manager.dart';
import '../../domain/repo/report_repo.dart';

class ReportController extends GetxController {
  final ReportRepo _reportRepo;
  ReportController(this._reportRepo);

  final MultiFormDataManager multiFormDataManager = MultiFormDataManager();
  final isLoading = false.obs;

  Future<void> createReport({
    required String userId,
    required String even,
    required String description,
    File? imageFile,
  }) async {
    try {
      isLoading.value = true;

      multiFormDataManager.addTextData("user", userId);
      multiFormDataManager.addTextData("even", even);
      multiFormDataManager.addTextData("description", description);

      if (imageFile != null) {
        multiFormDataManager.addImageFile(imageFile);
      }

      final formData = multiFormDataManager.toFormData();
      final result = await _reportRepo.report(formData);

      result.fold(
            (failure) {
          Get.snackbar("Failed", failure.message);
        },
            (success) {
          Get.snackbar("Success", "Report submitted successfully");
        },
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
