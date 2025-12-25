import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../data/create_league_repository.dart';
import '../../data/models/create_league_request_model.dart';
import '../controllers/create_league_controller.dart' as api_ctrl;
import '../widgets/create_league_app_bar.dart';
import '../widgets/create_league_date_location_fields.dart';
import '../widgets/create_league_form_fields.dart';
import '../widgets/create_league_image_upload.dart';
import '../widgets/create_league_rules_section.dart';
import '../widgets/create_league_selection_buttons.dart';
import '../widgets/create_league_validation.dart';
import '../widgets/private_league_code_dialog.dart';

class CreateLeagueScreen extends StatefulWidget {
  const CreateLeagueScreen({super.key});

  @override
  State<CreateLeagueScreen> createState() => _CreateLeagueScreenState();
}

class _CreateLeagueScreenState extends State<CreateLeagueScreen> {
  final api_ctrl.CreateLeagueController apiController = Get.put(
    api_ctrl.CreateLeagueController(
      repository: Get.find<CreateLeagueRepository>(),
    ),
  );

  // simple text controllers for required fields
  final TextEditingController _leagueNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _totalGameWeeksController = TextEditingController(
    text: '0',
  );
  final TextEditingController _entryFeeController = TextEditingController();

  File? _logoImage;
  File? _bannerImage;

  // Selection state for Type, Match Format, and Tiebreak
  String _selectedType = '';
  String _selectedMatchFormat = '';
  String _selectedTiebreak = '';
  String _selectedMatchPlay = '';
  String _selectedLeagueType = '';
  String _selectedPlayerLevel = '';
  bool _allowSubstitutes = false;

  Future<void> _pickImage(bool isLogo) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isLogo) {
          _logoImage = File(pickedFile.path);
        } else {
          _bannerImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _startDateController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.leagueBackgroundGrey,
      appBar: const CreateLeagueAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 13,
          left: 24,
          right: 24,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreateLeagueFormFields(
              leagueNameController: _leagueNameController,
              descriptionController: _descriptionController,
            ),

            const SizedBox(height: 16),

            CreateLeagueImageUpload(
              logoImage: _logoImage,
              bannerImage: _bannerImage,
              onPickLogo: () => _pickImage(true),
              onPickBanner: () => _pickImage(false),
            ),

            const SizedBox(height: 16),

            CreateLeagueDateLocationFields(
              startDateController: _startDateController,
              locationController: _locationController,
              totalGameWeeksController: _totalGameWeeksController,
              onSelectDate: () => _selectDate(context),
            ),

            const SizedBox(height: 8),

            // New Entry Fee Field
            TextField(
              controller: _entryFeeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Add Entry Fee",
                hintStyle: const TextStyle(
                  color: Color(0xFFCACACA),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.grey[900],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),

            const SizedBox(height: 24),

            CreateLeagueSelectionButtons(
              selectedType: _selectedType,
              selectedMatchFormat: _selectedMatchFormat,
              selectedTiebreak: _selectedTiebreak,
              allowSubstitutes: _allowSubstitutes,
              selectedMatchPlay: _selectedMatchPlay,
              selectedLeagueType: _selectedLeagueType,
              selectedPlayerLevel: _selectedPlayerLevel,
              onTypeChanged: (type) => setState(() => _selectedType = type),
              onMatchFormatChanged: (format) =>
                  setState(() => _selectedMatchFormat = format),
              onTiebreakChanged: (tiebreak) =>
                  setState(() => _selectedTiebreak = tiebreak),
              onAllowSubstitutesChanged: (allow) =>
                  setState(() => _allowSubstitutes = allow),
              onMatchPlayChanged: (matchPlay) =>
                  setState(() => _selectedMatchPlay = matchPlay),
              onLeagueTypeChanged: (leagueType) =>
                  setState(() => _selectedLeagueType = leagueType),
              onPlayerLevelChanged: (level) =>
                  setState(() => _selectedPlayerLevel = level),
            ),

            const SizedBox(height: 16),

            const CreateLeagueRulesSection(),

            const SizedBox(height: 43),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 116,
                  height: 29,
                  child: ElevatedButton(
                    onPressed: _onCreatePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Obx(
                      () => apiController.isLoading.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              "Publish",
                              style: TextStyle(
                                color: Color(0xFF141414),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    String? leagueId;
    if (args is String) {
      leagueId = args;
    } else if (args is Map && args['leagueId'] != null) {
      leagueId = args['leagueId'] as String?;
    }

    if (leagueId != null && leagueId.isNotEmpty) {
      apiController.loadLeagueById(leagueId).then((success) {
        if (success && apiController.league.value != null) {
          final l = apiController.league.value!;
          _leagueNameController.text = l.leagueName;
          _descriptionController.text = l.description;
          if (l.startDate != null) {
            _startDateController.text = l.startDate!.toIso8601String().split(
              'T',
            )[0];
          }
          _locationController.text = l.location;
          setState(() {});
        } else {
          Get.snackbar(
            'Error',
            apiController.errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _leagueNameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _locationController.dispose();
    _totalGameWeeksController.dispose();
    _entryFeeController.dispose();
    super.dispose();
  }

  void _onCreatePressed() async {
    if (!CreateLeagueValidation.validateLeagueForm(
      leagueName: _leagueNameController.text,
      description: _descriptionController.text,
      startDate: _startDateController.text,
      location: _locationController.text,
      totalGameWeeks: _totalGameWeeksController.text,
    )) {
      return;
    }

    // Entry Fee validation
    if (_entryFeeController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter an entry fee',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!_allowSubstitutes) {
      Get.snackbar(
        'Error',
        'Allowing player substitutes is mandatory',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final totalGameWeeks = int.parse(_totalGameWeeksController.text.trim());

    final formattedStartDate = CreateLeagueValidation.validateAndFormatDate(
      _startDateController.text,
    );
    if (formattedStartDate == null) {
      return;
    }

    final endDateCalculated = CreateLeagueValidation.calculateEndDate(
      formattedStartDate,
      totalGameWeeks,
    );
    final formattedEndDate = endDateCalculated.toIso8601String();

    final request = CreateLeagueRequestModel(
      user: '68d10f55d487a29db7269da7',
      leagueName: _leagueNameController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: formattedStartDate,
      location: _locationController.text.trim(),
      totalGameWeeks: totalGameWeeks,
      type: _selectedType,
      matchFormat: _selectedMatchFormat,
      tiebreakOption: _selectedTiebreak,
      allowSubstitutes: _allowSubstitutes,
      matchPlay: _selectedMatchPlay,
      leagueType: _selectedLeagueType,
      price: _entryFeeController.text.trim(),
    );

    final success = await apiController.createLeague(
      request,
      logoFile: _logoImage,
      bannerFile: _bannerImage,
    );

    if (success) {
      // Get the league code from API response
      final leagueCode = apiController.createdLeague.value?.leagueCode?.trim();

      // Show league code dialog for all leagues (private and public)
      if (leagueCode != null && leagueCode.isNotEmpty) {
        print('🎯 League Created - Showing Code: $leagueCode');
        _showLeagueCodeDialog(leagueCode);
      } else {
        // Fallback if no league code in response
        print('⚠️ No league code in response');
        _resetForm();
        Get.snackbar(
          'Success',
          'League published successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        Get.offAll(() => const HomeScreen());
      }
    } else {
      Get.snackbar(
        'Error',
        apiController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _resetForm() {
    _leagueNameController.clear();
    _descriptionController.clear();
    _startDateController.clear();
    _locationController.clear();
    _totalGameWeeksController.text = '0';
    _entryFeeController.clear();

    setState(() {
      _logoImage = null;
      _bannerImage = null;
      _selectedType = '';
      _selectedMatchFormat = '';
      _selectedTiebreak = '';
      _selectedMatchPlay = '';
      _selectedLeagueType = '';
      _selectedPlayerLevel = '';
      _allowSubstitutes = false;
    });
  }

  /// Show dialog with league code from API response
  void _showLeagueCodeDialog(String leagueCode) {
    print('📱 Building League Code Dialog with code: $leagueCode');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PrivateLeagueCodeDialog(leagueCode: leagueCode);
      },
    ).then((_) {
      // Redirect to Home Screen when dialog is dismissed (via tap outside, cancel, or copy)
      Get.offAll(() => const HomeScreen());
    });
  }
}
