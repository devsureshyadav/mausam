import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

// Hardcoded premium color constants to resolve AppColors theme compilation errors
const Color _accentSecondary = Color(0xFF00E5FF); // Vibrant Cyan
const Color _accent = Color(0xFFD500F9); // Vibrant Pink
const Gradient _developerHeroGradient = LinearGradient(
  colors: [
    Color(0xFF1A237E), // Deep Indigo
    Color(0xFF006064), // Deep Cyan/Teal
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class DeveloperDetailsScreen extends StatelessWidget {
  const DeveloperDetailsScreen({super.key});

  static const _playStoreDeveloperUrl =
      'https://play.google.com/store/apps/developer?id=sureshyadav';
  static const _playStoreIconAsset = 'assets/images/playstore.png';

  Widget _playStoreIcon({double size = 26}) {
    return Image.asset(
      _playStoreIconAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        Icons.shop_rounded,
        size: size,
        color: const Color(0xFF34A853),
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchWhatsApp() async {
    const link = WhatsAppUnilink(
      phoneNumber: "+9779763878278",
      text:
          "Hi Suresh! I'm interested in your Khajalaya project. Can we discuss collaboration opportunities?",
    );
    try {
      await launchUrl(link.asUri());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to open WhatsApp",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> launchPhoneCall() async {
    const phoneNumber = "+9779763878278";
    final uri = Uri.parse('tel:$phoneNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch phone call';
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to make phone call",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Developer Profile',
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: const Color(0xFF0F0F0F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Section
              _buildProfileSection(),
              const SizedBox(height: 20),

              // About Section
              _buildAboutSection(),
              const SizedBox(height: 20),

              // Skills Section
              _buildSkillsSection(),
              const SizedBox(height: 20),

              // Contact Section
              _buildContactSection(),
              const SizedBox(height: 20),

              _buildPlayStoreSection(),
              const SizedBox(height: 20),

              // Achievements Section
              _buildAchievementsSection(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _developerHeroGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _accentSecondary.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: _accentSecondary.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _accentSecondary,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: _accentSecondary.withOpacity(0.45),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
                child: Image.network(
              'https://avatars.githubusercontent.com/u/117462201?v=4',
              fit: BoxFit.cover,
            )),
          ),
          const SizedBox(height: 16),

          // Name and Title
          Text(
            'Suresh Yadav',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Full Stack Developer',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: _accentSecondary.withOpacity(0.95),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white.withOpacity(0.7),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Nepal',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[400], size: 24),
              const SizedBox(width: 12),
              Text(
                'About',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Passionate Full Stack Developer with expertise in building scalable android, iOS and windows applications. Specialized in Firebase integration, real-time features, and cross-platform development. Committed to delivering high-quality, user-centric solutions.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[300],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.green[400], size: 24),
              const SizedBox(width: 12),
              Text(
                'Technical Expertise',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Core Technologies
          _buildSkillCategory(
              'Core Technologies',
              [
                'Flutter/Dart',
                'Provider State Management',
                'Material Design 3',
                'Cross-platform Development',
              ],
              Colors.blue),

          const SizedBox(height: 16),

          // Backend & Services
          _buildSkillCategory(
              'Backend & Services',
              [
                'Firebase (Auth, Firestore, Storage)',
                'Google Maps API',
                'Cloud Functions',
                'REST APIs',
              ],
              Colors.orange),

          const SizedBox(height: 16),

          // Development Tools
          _buildSkillCategory(
              'Development Tools',
              [
                'Git & GitHub',
                'Android Studio / VS Code',
                'Postman',
                'Jira / Trello',
              ],
              Colors.purple),
        ],
      ),
    );
  }

  Widget _buildSkillCategory(String title, List<String> skills, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              skills.map((skill) => _buildSkillChip(skill, color)).toList(),
        ),
      ],
    );
  }

  Widget _buildSkillChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_phone, color: Colors.red[400], size: 24),
              const SizedBox(width: 12),
              Text(
                'Contact Information',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Contact Grid
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: constraints.maxWidth > 600 ? 3.5 : 4.0,
                children: [
                  _buildContactCard(
                    'Email',
                    'sureshyadav.info.np@gmail.com',
                    Colors.blue,
                    () => _launchURL('mailto:sureshyadav.info.np@gmail.com'),
                    icon: Icons.email,
                  ),
                  _buildContactCard(
                    'Portfolio',
                    'sureshyadav.info.np',
                    Colors.purple,
                    () => _launchURL('https://sureshyadav.info.np'),
                    icon: Icons.web,
                  ),
                  _buildContactCard(
                    'Phone',
                    '+977 9763878278',
                    Colors.green,
                    launchPhoneCall,
                    icon: Icons.phone,
                  ),
                  _buildContactCard(
                    'GitHub',
                    '@sureshyadav',
                    Colors.grey,
                    () => _launchURL('https://github.com/devsureshyadav'),
                    icon: FontAwesomeIcons.github,
                  ),
                  _buildContactCard(
                    'Google Play',
                    'All published apps',
                    const Color(0xFF34A853),
                    () => _launchURL(_playStoreDeveloperUrl),
                    leading: _playStoreIcon(size: 20),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: launchPhoneCall,
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: Text(
                    'Call Now',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: launchWhatsApp,
                  icon: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.white,
                  ),
                  label: Text(
                    'WhatsApp',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayStoreSection() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchURL(_playStoreDeveloperUrl),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B8F4A), Color(0xFF0D5C2E), Color(0xFF0A2E18)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF34A853).withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF34A853).withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: _playStoreIcon(size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apps on Google Play',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'CashFlow, RoopAI, Mutu, Khajalaya & more — tap to view all in one click.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.4,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.open_in_new_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    String title,
    String value,
    Color color,
    VoidCallback onTap, {
    IconData? icon,
    Widget? leading,
  }) {
    assert(icon != null || leading != null);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            leading ?? Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3D1A78),
            Color(0xFF1F0252),
            Color(0xFF141428),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _accent.withOpacity(0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber[400], size: 24),
              const SizedBox(width: 12),
              Text(
                'Project Achievements',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Achievements Grid
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: constraints.maxWidth > 600 ? 2.5 : 3.0,
                children: [
                  _buildAchievementCard('🚀 1000+ Downloads', 'App Store'),
                  _buildAchievementCard('⭐ 4.8/5 Rating', 'User Reviews'),
                  _buildAchievementCard('🏪 50+ Restaurants', 'Active Users'),
                  _buildAchievementCard(
                    '📱 Multi-platform',
                    'Android, iOS, Web',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
