import 'package:cbfapp/models/speakers_model.dart';
import 'package:cbfapp/services/speaker_service.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';

class KeynoteSpeakers extends StatefulWidget {
  const KeynoteSpeakers({super.key});

  @override
  State<KeynoteSpeakers> createState() => _KeynoteSpeakersState();
}

class _KeynoteSpeakersState extends State<KeynoteSpeakers>
    with TickerProviderStateMixin {
  late Future<SpeakersResponseModel> _sessionsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedSpeakerType;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = SpeakerService().fetchSpeakers();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<SpeakerModel> _filterSpeakers(List<SpeakerModel> speakers) {
    return speakers.where((speaker) {
      final fullName = '${speaker.prefix} ${speaker.fname} ${speaker.lname}';
      final topic = speaker.parallelSessions.isNotEmpty
          ? speaker.parallelSessions.first.topic
          : '';
      final speakerType = speaker.custom;

      final matchesSearch = _searchQuery.isEmpty ||
          fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          topic.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesType = _selectedSpeakerType == null ||
              _selectedSpeakerType == 'All'
          ? true
          : speakerType.toLowerCase() == _selectedSpeakerType!.toLowerCase();

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          alignment: Alignment.topRight,
          opacity: 0.3,
          repeat: ImageRepeat.repeatY,
        ),
      ),
      child: FutureBuilder<SpeakersResponseModel>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: MainText(text: "Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: MainText(text: "No speakers found."));
          }

          final allSpeakers = snapshot.data!.data;

          // Get unique speaker types
          final speakerTypes = allSpeakers
              .map((s) => s.custom)
              .where((type) => type.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

          speakerTypes.insert(0, 'All');

          final filtered = _filterSpeakers(allSpeakers);

          return Column(
            children: [
              // Hero Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryDeepBlue,
                      AppColors.primaryColor,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText(
                                text: 'Featured Speakers',
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 6),
                              MainText(
                                text:
                                    '${allSpeakers.length} experts sharing insights',
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search and Filter Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search speakers by name or topic...",
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primaryGray,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear_rounded,
                                    color: AppColors.primaryGray),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final type in speakerTypes)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: MainText(
                                  text: type,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedSpeakerType == type
                                      ? Colors.white
                                      : AppColors.primaryDeepBlue,
                                ),
                                selected: _selectedSpeakerType == type,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedSpeakerType =
                                        selected ? type : null;
                                  });
                                },
                                backgroundColor: Colors.white,
                                selectedColor: AppColors.primaryColor,
                                side: BorderSide(
                                  color: _selectedSpeakerType == type
                                      ? AppColors.primaryColor
                                      : AppColors.primaryColor.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Speakers Grid
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off_rounded,
                              size: 64,
                              color: AppColors.primaryColor.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            MainText(
                              text: 'No speakers found',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryGray,
                            ),
                            const SizedBox(height: 8),
                            MainText(
                              text: 'Try adjusting your search or filters',
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 2 : 1,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final speaker = filtered[index];
                          final speakerType = speaker.custom;
                          final fullName =
                              '${speaker.prefix} ${speaker.fname} ${speaker.lname}';
                          final company = speaker.company;
                          final topic = speaker.parallelSessions.isNotEmpty
                              ? speaker.parallelSessions.first.topic
                              : 'No topic assigned';
                          final speakerImage = (speaker.image != null &&
                                  speaker.image!.isNotEmpty)
                              ? "https://summitapi.cariscabusinessforum.com${speaker.image}"
                              : null;

                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/speaker-details",
                                  arguments: speaker,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primaryColor
                                        .withOpacity(0.08),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryDeepBlue
                                          .withOpacity(0.06),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Image Section
                                    Container(
                                      height: 160,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.primaryDeepBlue
                                                .withOpacity(0.8),
                                            AppColors.primaryColor
                                                .withOpacity(0.6),
                                          ],
                                        ),
                                      ),
                                      child: speakerImage != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                              child: Image.network(
                                                speakerImage,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Center(
                                              child: Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: MainText(
                                                    text: speaker.fname
                                                                .isNotEmpty ==
                                                            true
                                                        ? speaker.fname[0]
                                                        : "S",
                                                    fontSize: 36,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                    // Content Section
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Speaker Type Badge
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor
                                                    .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: MainText(
                                                text: speakerType,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // Speaker Name
                                            MainText(
                                              text: fullName.trim(),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            // Company
                                            MainText(
                                              text: company,
                                              fontSize: 12,
                                              color: AppColors.primaryGray,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            // Topic
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.topic_rounded,
                                                    size: 12,
                                                    color: AppColors
                                                        .primaryDeepBlue,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: MainText(
                                                      text: topic,
                                                      fontSize: 11,
                                                      color: AppColors
                                                          .primaryDeepBlue,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
