import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnersandSponsors extends StatefulWidget {
  const PartnersandSponsors({super.key});

  @override
  State<PartnersandSponsors> createState() => _PartnersandSponsorsState();
}

class _PartnersandSponsorsState extends State<PartnersandSponsors> {
  final List<Map<String, String>> partnerLogos = [
    {'image': 'assets/images/knust.png', 'url': 'https://www.knust.edu.gh'},
    {
      'image': 'assets/images/learnlogistics.png',
      'url': 'https://www.kuehne-stiftung.org/'
    },
    {'image': 'assets/images/asu.png', 'url': 'https://www.asu.edu'},
    {'image': 'assets/images/arcesm.png', 'url': 'https://arc-esm.org'},
    {'image': 'assets/images/federal.png', 'url': 'https://futo.edu.ng'},
    {'image': 'assets/images/lsu.png', 'url': 'https://lasu.edu.gh'},
  ];

  final List<Map<String, String>> sponsorLogos = [
    {
      'image': 'assets/images/learnlogistics.png',
      'url': 'https://www.kuehne-stiftung.org/'
    },
    {'image': 'assets/images/arcesm.png', 'url': 'https://arc-esm.org'},
    {'image': 'assets/images/asu.png', 'url': 'https://www.asu.edu'},
    {
      'image': 'assets/images/clinton.png',
      'url': 'https://www.clintonhealthaccess.org'
    },
    {'image': 'assets/images/kaizen.png', 'url': 'https://www.kaizen.com'},
  ];

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MainText(text: "Partners and Sponsors"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText(
              text: "Partners",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGold,
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: partnerLogos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = partnerLogos[index];
                return GestureDetector(
                  onTap: () => _launchURL(item['url']!),
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            MainText(
              text: "Sponsors",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGold,
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sponsorLogos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = sponsorLogos[index];
                return GestureDetector(
                  onTap: () => _launchURL(item['url']!),
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        item['image']!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
