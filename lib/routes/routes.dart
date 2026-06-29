import 'package:cbfapp/screens/agenda/agenda.dart';
import 'package:cbfapp/screens/dashboard/Announcement.dart';
import 'package:cbfapp/screens/dashboard/PartnersandSponsors.dart';
import 'package:cbfapp/screens/dashboard/Profile.dart';
import 'package:cbfapp/screens/dashboard/ProgramDetails.dart';
import 'package:cbfapp/screens/dashboard/SpeakerDetails.dart';
import 'package:cbfapp/screens/dashboard/dashboard.dart';
import 'package:cbfapp/screens/info/info.dart';
import 'package:cbfapp/screens/keynote_speaksers/keynote_speakers.dart';
import 'package:cbfapp/screens/landing.dart';
import 'package:cbfapp/screens/login/HowToLogin.dart';
import 'package:cbfapp/screens/login/login.dart';
import 'package:cbfapp/screens/login/otp.dart';
import 'package:cbfapp/screens/login/password.dart';
import 'package:cbfapp/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// Define routes as a map
Map<String, WidgetBuilder> get appRoutes{
  return {
    '/': (context) => const OnboardingScreen(),
    '/landing': (context) => const Landing(),
    '/login': (context) => const Login(),
    '/otp': (context) => const OtpScreen(),
    '/password': (context) => const Password(),
    '/dashboard': (context) => const Dashboard(),
    '/onboarding': (context) => const OnboardingScreen(),
    '/howToLogIn': (context) => const HowToLogin(),
    '/info': (context) => const Info(),
    '/agenda': (context) => const Agenda(),
    '/keynoteSpeakers': (context) => const KeynoteSpeakers(),
    '/speakers': (context) => const HowToLogin(),
    '/exhibitors': (context) => const HowToLogin(),
    '/sponsors': (context) => const HowToLogin(),
    '/floorPlan': (context) => const HowToLogin(),
    '/search': (context) => const HowToLogin(),
    '/profile': (context) => const Profile(),
    '/speaker-details': (context) => const SpeakerDetails(),
    '/program-details': (context) => const ProgramDetails(),
    '/sponsors-partners': (context) => const PartnersandSponsors(),
    '/announcement': (context) => const AnnouncementPage(),

  };
}

