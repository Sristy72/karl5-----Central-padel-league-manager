import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../../data/models/create_league_model.dart';


class CreateLeagueScreen extends StatefulWidget {
  const CreateLeagueScreen({super.key});

  @override
  State<CreateLeagueScreen> createState() => _CreateLeagueScreenState();
}

class _CreateLeagueScreenState extends State<CreateLeagueScreen> {
  final CreateLeagueController controller = Get.put(CreateLeagueController());


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
        title: const Text(
          "Create your league",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                "Set up your tournament in minutes-add teams,\nchoose rules,and let the matches begin!",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("League Name"),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _buildTextField("Start Date")),
                const SizedBox(width: 18),
                Expanded(child: _buildTextField("End Date")),
              ],
            ),
            const SizedBox(height: 8),
            _buildTextField("Location"),
            const SizedBox(height: 8),
            _buildTextField(
              "Enter league description",
              maxLines: 8,
              fixedHeight: 183,
            ),
            const SizedBox(height: 8),

            // Dropdown
            DropdownButtonFormField<String>(
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration("Number of Teams"),
              items: ["2", "4", "6", "8", "10"]
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),

            // Add Teams
            const Text(
              "Add Teams",
              style: TextStyle(
                color: Color(0xFFD7D7D7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),

            Obx(
              () => Column(
                children: [
                  for (int i = 0; i < controller.teamList.length; i++)
                    Column(
                      children: [
                        _buildTextField("Team/Player Name"),
                        const SizedBox(height: 10),
                        _buildTextField("Contact Numbers"),
                        const Divider(color: Colors.white30),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 84,
              height: 29,
              child: OutlinedButton(
                onPressed: controller.addTeam,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.green, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                ),
                child: const Text(
                  "Add More +",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Add Entry fee
            const Text(
              "Add Entry Fee",
              style: TextStyle(
                color: Color(0xFFD7D7D7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField("Write here"),
            const SizedBox(height: 20),

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

            _imageUploadBox(isLogo: true),
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

            // Match Format Section
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

            // Tiebreak Option
            const Text(
              "Tiebreak Option:",
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

            const SizedBox(height: 16),

            // Auto Assign Dates & Times
            const Text(
              "Auto Assign Dates & Times",
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
                      "Yes",
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
                      "No",
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

            // Create Button
            Center(
              child: SizedBox(
                width: 138,
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFF2AAF08)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Create Your League",
                    style: TextStyle(
                      color: Color(0xFF2AAF08),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Reusable TextField
  Widget _buildTextField(String hint, {int maxLines = 1, double? fixedHeight}) {
    return SizedBox(
      height: fixedHeight ?? (maxLines > 1 ? null : 48),
      child: TextField(
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
}
