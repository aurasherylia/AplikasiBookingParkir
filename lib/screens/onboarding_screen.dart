import 'package:flutter/material.dart';

import '../constants.dart';
import '../routes/custom_routes.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  void _goToPage(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    if (_pageIndex < 2) {
      _goToPage(_pageIndex + 1);
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      fadeRoute(const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _pageIndex = i),
                children: const [
                  _OnboardingPage(
                    imagePath: 'assets/images/logo1.png',
                    title: 'Your no.1 parking assistant',
                    subtitle: '',
                  ),
                  _OnboardingPage(
                    imagePath: 'assets/images/logo2.png',
                    title: 'Booking Parking Space Easily',
                    subtitle:
                        'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit',
                  ),
                  _OnboardingPage(
                    imagePath: 'assets/images/logo3.png',
                    title: 'Quick Navigation',
                    subtitle:
                        'Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kScreenPadding,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _goToLogin,
                    child: const Text(
                      'SKIP',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _pageIndex == index ? 10 : 8,
                        height: _pageIndex == index ? 10 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _pageIndex == index
                              ? Colors.grey.shade800
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  ),
                  TextButton(
                    onPressed: _next,
                    child: Text(
                      _pageIndex == 2 ? 'START' : 'NEXT',
                      style: const TextStyle(
                        color: kPrimaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: kScreenPadding,
        vertical: 32,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: 'splash-logo',
                    child: Center(
                      child: Image.asset(imagePath, fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
