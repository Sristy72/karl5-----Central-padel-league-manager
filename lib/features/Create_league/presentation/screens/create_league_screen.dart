import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../controllers/create_league_controller.dart' as api_ctrl;
import '../../data/create_league_repository.dart';
import '../../data/models/create_league_model.dart' as form_model;
import '../../data/models/create_league_request_model.dart';


class CreateLeagueScreen extends StatefulWidget {
  const CreateLeagueScreen({super.key});

  @override
  State<CreateLeagueScreen> createState() => _CreateLeagueScreenState();
}

class _CreateLeagueScreenState extends State<CreateLeagueScreen> {
  final api_ctrl.CreateLeagueController apiController = Get.put(
    api_ctrl.CreateLeagueController(repository: Get.find<CreateLeagueRepository>()),
  );

  // form controller for teams list
  final form_model.CreateLeagueFormController formController = Get.put(form_model.CreateLeagueFormController());

  // simple text controllers for required fields
  final TextEditingController _leagueNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _entryfeeController = TextEditingController();

  File? _logoImage;
  File? _bannerImage;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Hello Mosh,",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Welcome to Pedal app",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {

              },
              child: Image.asset(
                "assets/icons/notification.png",
                width: 28,
                height: 28,
                // color: Colors.white,
              ),
            ),
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 8.0,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Create League Button
                  SizedBox(
                      width: 103,
                      height: 29,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "Create League +",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  // const SizedBox(width: 8),

                  // Update Score Button
                  SizedBox(
                      width: 90,
                      height: 29,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          // side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          "Update score",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  // const SizedBox(width: 8),

                  // Send Announcements Button
                  Expanded(
                    child: SizedBox(
                      width: 133,
                        height: 29,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            "Send announcements",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // body
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 13,left: 24, right: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Enter League Name", controller: _leagueNameController),

            const SizedBox(height: 8),

            _buildTextField(
              "Enter league description",
              maxLines: 8,
              fixedHeight: 183,
              controller: _descriptionController,
            ),
            const SizedBox(height: 16 ),

            // // Dropdown
            // DropdownButtonFormField<String>(
            //   dropdownColor: Colors.grey[900],
            //   style: const TextStyle(color: Colors.white),
            //   decoration: _fieldDecoration("Number of Teams"),
            //   items: ["2", "4", "6", "8", "10"]
            //       .map(
            //         (e) => DropdownMenuItem(
            //           value: e,
            //           child: Text(
            //             e,
            //             style: const TextStyle(color: Colors.white),
            //           ),
            //         ),
            //       )
            //       .toList(),
            //   onChanged: (val) {},
            // ),
            // const SizedBox(height: 16),

            // // Add Teams
            // const Text(
            //   "Add Teams",
            //   style: TextStyle(
            //     color: Color(0xFFD7D7D7),
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            // const SizedBox(height: 8),

            // Obx(
            //   () => Column(
            //     children: [
            //       for (int i = 0; i < formController.teamList.length; i++)
            //         Column(
            //           children: [
            //             _buildTextField("Team/Player Name"),
            //             const SizedBox(height: 10),
            //             _buildTextField("Contact Numbers"),
            //             const Divider(color: Colors.white30),
            //           ],
            //         ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   width: 84,
            //   height: 29,
            //   child: OutlinedButton(
            //     onPressed: formController.addTeam,
            //     style: OutlinedButton.styleFrom(
            //       side: const BorderSide(color: Colors.green, width: 1),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //       padding: const EdgeInsets.symmetric(horizontal: 7),
            //     ),
            //     child: const Text(
            //       "Add More +",
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 12,
            //         fontWeight: FontWeight.w400,
            //       ),
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 16),

            // Add Entry fee
            // const Text(
            //   "Add Entry Fee",
            //   style: TextStyle(
            //     color: Color(0xFFD7D7D7),
            //     fontSize: 14,
            //     fontWeight: FontWeight.w400,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // _buildTextField("Write here"),
            // const SizedBox(height: 20),

            // Upload logo/photo
            const Text(
              "Upload your logo/photo",
              style: TextStyle(
                color: Color(0xFFD7D7D7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),

            _imageUploadBox1(isLogo: true),
            const SizedBox(height: 12),

            // Tournament Banner
            const Text(
              "Tournament Banner Image Upload",
              style: TextStyle(
                color: Color(0xFFD7D7D7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            _imageUploadBox(isLogo: false),

            const SizedBox(height: 27),

            Row(
              children: [
                Expanded(child: _buildTextField("Start Date", controller: _startDateController)),
                const SizedBox(width: 18),
                Expanded(child: _buildTextField("End Date", controller: _endDateController)),
              ],
            ),
            const SizedBox(height: 8),
            _buildTextField("Location", controller: _locationController),


            const SizedBox(height: 20),
            const Text(
              "Add Entry Fee",
              style: TextStyle(
                color: Color(0xFFD7D7D7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 8),
            _buildTextField("Write here", controller: _entryfeeController),

            const SizedBox(height: 24),

            // Type
            const Text(
              "Type:",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  height: 29,
                  width: 116,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2AAF08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "Singles",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 7),

                SizedBox(
                  height: 29,
                  width: 116,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFF2AAF08)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "Doubles",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tiebreak Option
            const Text(
              "Match Format:",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  height: 29,
                  width: 116,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2AAF08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "Best of 3 sets",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                SizedBox(
                  height: 29,
                  width: 116,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFF2AAF08)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "Best of 5 sets",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Auto Assign Dates & Times
            const Text(
              "Tiebreak Option",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  height: 29,
                  width: 116,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2AAF08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "Standard 7-point",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                SizedBox(
                  height: 29,
                  width: 116,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Color(0xFF2AAF08)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "No tiebreak",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Allow substitutes
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.circle,
                      size: 10,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Allow players substitutes",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Rules & Regulation
            const Text(
              "Rules & Regulation",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: "1. Match Format\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "   • Best of 3 sets: First to win 2 sets wins the match \n     (scores: 2–0 or 2–1).\n\n",


                  ),
                  TextSpan(
                    text: "2. Tiebreak Options\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "   • At 6–6 games, choose:\n"
                        "       - Standard Tiebreak (7 points) – win by 2\n"
                        "       - No Tiebreak – play until 2-game lead\n"
                        "       - Super Tiebreak (10 points) – used instead of full 3rd set\n\n",
                  ),
                  TextSpan(
                    text: "3. Scoring Rules\n",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "   • Traditional: 15–30–40–Game\n"
                        "   • No-Advantage (Golden Point): 40–40 → next point wins\n"
                        "   • Points for standings: Win = 3, Loss = 1 (customizable; bonuses possible)\n",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 43),

            // Publish Button
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
    // Check for league id in Get.arguments to load existing league
    final args = Get.arguments;
    String? leagueId;
    if (args is String) {
      leagueId = args;
    } else if (args is Map && args['leagueId'] != null) {
      leagueId = args['leagueId'] as String?;
    }

    if (leagueId != null && leagueId.isNotEmpty) {
      // load league and populate fields
      apiController.loadLeagueById(leagueId).then((success) {
        if (success && apiController.league.value != null) {
          final l = apiController.league.value!;
          _leagueNameController.text = l.leagueName;
          _descriptionController.text = l.description;
          // use ISO date strings for inputs; format as yyyy-MM-dd for readability
          if (l.startDate != null) _startDateController.text = l.startDate!.toIso8601String();
          if (l.endDate != null) _endDateController.text = l.endDate!.toIso8601String();
          _locationController.text = l.location;
          if (l.price != null) _entryfeeController.text = l.price!;

          // populate team list using ids as names (backend returns ids)
          formController.teamList.assignAll(
            l.addTeams.map((id) => {"name": id, "contact": ""}).toList(),
          );
          setState(() {});
        } else {
          Get.snackbar('Error', apiController.errorMessage.value, snackPosition: SnackPosition.BOTTOM);
        }
      });
    }
  }

  // Reusable TextField
  Widget _buildTextField(String hint, {int maxLines = 1, double? fixedHeight, TextEditingController? controller}) {
    return SizedBox(
      height: fixedHeight ?? (maxLines > 1 ? null : 48),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: _fieldDecoration(hint),
      ),
    );
  }

  // Decoration
  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
    );
  }

  // Image Upload Box
  Widget _imageUploadBox({required bool isLogo}) {
    final file = isLogo ? _logoImage : _bannerImage;
    return GestureDetector(
      onTap: () => _pickImage(isLogo),
      child: Container(
        height: 105,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF050505),
          // border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
        ),
        child: file == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/Report_drop_photo.png',
                    width: 17,
                    height: 17,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "Drop your files here",
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Choose File",
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ],
              )
            : Image.file(file, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }

  Widget _imageUploadBox1({required bool isLogo}) {
    final file = isLogo ? _logoImage : _bannerImage;
    return GestureDetector(
      onTap: () => _pickImage(isLogo),
      child: Container(
        height: 105,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF3C3C3C),
          // border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
        ),
        child: file == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/Report_drop_photo.png',
              width: 17,
              height: 17,
              color: Colors.white,
            ),
            const SizedBox(height: 7),
            const Text(
              "Drop your files here",
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
            const SizedBox(height: 10),
            const Text(
              "Choose File",
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
          ],
        )
            : Image.file(file, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }

  @override
  void dispose() {
    _leagueNameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _onCreatePressed() async {
    final request = CreateLeagueRequestModel(
      user: '68d10f55d487a29db7269da7', // TODO: replace with actual user id
      leagueName: _leagueNameController.text,
      description: _descriptionController.text,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      location: _locationController.text,
      addTeams: formController.teamList.map((e) => e['name'] ?? '').toList(),
      totalGameWeeks: 0,
      type: 'Singles',
      matchFormat: 'Best of 3 sets',
      tiebreakOption: 'No tiebreak',
      allowSubstitutes: false,
    );

    final success = await apiController.createLeague(request);
    if (success) {
      Get.snackbar('Success', apiController.successMessage.value, snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', apiController.errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
