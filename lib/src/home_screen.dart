import 'package:flutter/material.dart';
import 'quize_screen.dart';
import 'video_screen.dart';
import 'places_screen.dart';
import 'rating_screen.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLanguage;
  final bool isArabic;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.onToggleLanguage,
    required this.isArabic,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color kJordanRed = Color(0xFFB71C1C);
  static const Color kJordanBlack = Color(0xFF111111);

  final List<String> _images = [
    'https://images.unsplash.com/photo-1615811648503-479d06197ff3?q=80&w=1176&auto=format&fit=crop',
    'https://media.istockphoto.com/id/145186732/photo/wadi-rum.jpg?s=2048x2048&w=is&k=20&c=HDjfyRpLW8tf2hh8jD7Dw9dvIuCNMWl-2ROj1-2HtlQ=',
    'https://ar.visitjordan.com/uploads/attractions/cecd3bd7-c707-402f-8d70-2a00c839e33c.png',
  ];

  late final PageController _page;
  int _current = 0;
  Timer? _timer;

  String get _articleIntroAr => '''
تعد الأردن من الدول التي تجمع بين التاريخ والطبيعة في آن واحد
تعتبر البترا من أشهر المدن الأثرية المنحوتة في الصخر وتظهر جرش آثار الحضارة الرومانية
أما وادي رم فيتميز بصحرائه الجميلة ويعد البحر الميت أخفض نقطة على سطح الأرض
يساعد هذا التطبيق المستخدم على التعرف إلى أهم الأماكن السياحية في الأردن
وتعلم معلومات سريعة عنها ثم اختبار معرفته من خلال أسئلة قصيرة
''';

  String get _articleIntroEn => '''
Jordan is a country that combines history and nature in one place.
Petra is a famous rock-carved ancient city, Jerash shows impressive Roman ruins,
Wadi Rum is known for its beautiful desert, and the Dead Sea is the lowest point on Earth.
This app helps users learn about Jordan’s top tourist attractions,
get quick information, and test their knowledge with a short quiz.
''';

  String get _introText => widget.isArabic ? _articleIntroAr : _articleIntroEn;

  Widget _buildInfoBox(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double maxH = size.height * 0.22;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          border: const Border(
            left: BorderSide(color: kJordanRed, width: 6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.travel_explore, color: kJordanRed),
                  const SizedBox(width: 8),
                  Text(
                    widget.isArabic ? 'استكشف الاردن' : 'Explore Jordan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxH),
                child: SingleChildScrollView(
                  child: Text(
                    _introText,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDots() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_images.length, (i) {
        final active = i == _current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 14 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? kJordanRed
                : (isDark ? Colors.white24 : Colors.black26),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _page = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (t) {
      if (!mounted) return;
      final next = (_current + 1) % _images.length;
      _page.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topHeight = size.height * 0.25;

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.isArabic
              ? 'تطبيق السياحة في الاردن'
              : 'Jordan Tourism App'),
          backgroundColor: kJordanRed,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              tooltip: widget.isArabic ? 'تغيير اللغة' : 'Change Language',
              icon: const Icon(Icons.language),
              onPressed: widget.onToggleLanguage,
            ),
            IconButton(
              tooltip: widget.isArabic ? 'تغيير الوضع' : 'Change Theme',
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.onToggleTheme,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: topHeight,
                child: PageView.builder(
                  controller: _page,
                  itemCount: _images.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (context, i) {
                    return Image.network(
                      _images[i],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              _buildDots(),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.isArabic
                      ? 'اهلا فيك تعلم عن الاردن واكتشف اماكن سياحية رائعة'
                      : 'Welcome! Learn about Jordan and discover amazing places.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoBox(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kJordanRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          // ✅✅✅ مهم: ابعثي isArabic للكويز
                          MaterialPageRoute(
                            builder: (_) =>
                                QuizScreen(isArabic: widget.isArabic),
                          ),
                        );
                      },
                      child: Text(
                          widget.isArabic ? 'ابدأ الاختبار' : 'Start Quiz'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).textTheme.bodyLarge?.color,
                        side: BorderSide(
                          color: Theme.of(context).textTheme.bodyLarge?.color ??
                              kJordanBlack,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          // ✅✅✅ مهم: ابعثي isArabic للفيديو
                          MaterialPageRoute(
                            builder: (_) =>
                                VideoScreen(isArabic: widget.isArabic),
                          ),
                        );
                      },
                      child: Text(
                          widget.isArabic ? 'شاهد الفيديو' : 'Watch Video'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kJordanBlack,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PlacesScreen(isArabic: widget.isArabic),
                          ),
                        );
                      },
                      child: Text(widget.isArabic
                          ? 'استكشف الاماكن'
                          : 'Explore Places'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          // ✅✅✅ مهم: ابعثي isArabic للتقييم
                          MaterialPageRoute(
                            builder: (_) =>
                                RatingScreen(isArabic: widget.isArabic),
                          ),
                        );
                      },
                      child: Text(widget.isArabic ? 'قيم التطبيق' : 'Rate App'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
