import 'package:flutter/material.dart';

class PlacesScreen extends StatefulWidget {
  final bool isArabic;
  const PlacesScreen({super.key, required this.isArabic});

  static const Color kJordanRed = Color(0xFFB71C1C);

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  double fontScale = 1.0;

  void increaseFont() {
    setState(() {
      fontScale = (fontScale + 0.1).clamp(0.8, 1.6);
    });
  }

  void decreaseFont() {
    setState(() {
      fontScale = (fontScale - 0.1).clamp(0.8, 1.6);
    });
  }

  List<Map<String, String>> get _places => widget.isArabic
      ? [
          {
            'title': 'البتراء',
            'image':
                'https://images.unsplash.com/photo-1615811648503-479d06197ff3?q=80&w=1176&auto=format&fit=crop',
            'desc':
                'مدينة أثرية منحوتة في الصخر في جنوب الأردن وتعد من أشهر المعالم السياحية وتجذب الزوار من مختلف دول العالم',
          },
          {
            'title': 'وادي رم',
            'image':
                'https://media.istockphoto.com/id/145186732/photo/wadi-rum.jpg?s=2048x2048&w=is&k=20&c=HDjfyRpLW8tf2hh8jD7Dw9dvIuCNMWl-2ROj1-2HtlQ=',
            'desc':
                'منطقة صحراوية جميلة تشتهر بالجبال والرمال وتقام فيها رحلات سفاري ومخيمات سياحية وتعد من أجمل مناطق الأردن',
          },
          {
            'title': 'جرش',
            'image':
                'https://media.istockphoto.com/id/681914964/photo/jerash-of-the-jordanian-city.jpg?s=2048x2048&w=is&k=20&c=PSgg5QAaX0SJmSvibdcw2trfMfA4coUBNl94GBpGxHM=',
            'desc':
                'مدينة أثرية رومانية تحتوي على أعمدة ومدرجات وساحات تاريخية وتعرض جزءا مهما من الحضارة القديمة',
          },
          {
            'title': 'البحر الميت',
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Dead_Sea_by_David_Shankbone.jpg/330px-Dead_Sea_by_David_Shankbone.jpg',
            'desc':
                'أخفض نقطة على سطح الأرض ويتميز بمياهه المالحة التي تساعد على الطفو ويعد من أشهر المواقع العلاجية والسياحية',
          },
          {
            'title': 'عجلون',
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/AjlunCastle_outside.JPG/500px-AjlunCastle_outside.JPG',
            'desc':
                'منطقة خضراء جميلة في شمال الأردن وتشتهر بقلعة عجلون والطبيعة والهواء اللطيف وتعد مناسبة للرحلات العائلية',
          },
        ]
      : [
          {
            'title': 'Petra',
            'image':
                'https://images.unsplash.com/photo-1615811648503-479d06197ff3?q=80&w=1176&auto=format&fit=crop',
            'desc':
                'An ancient city carved into rock in southern Jordan. One of the most famous tourist attractions worldwide.',
          },
          {
            'title': 'Wadi Rum',
            'image':
                'https://media.istockphoto.com/id/145186732/photo/wadi-rum.jpg?s=2048x2048&w=is&k=20&c=HDjfyRpLW8tf2hh8jD7Dw9dvIuCNMWl-2ROj1-2HtlQ=',
            'desc':
                'A beautiful desert area known for mountains and sands. Great for safari trips and tourist camps.',
          },
          {
            'title': 'Jerash',
            'image':
                'https://media.istockphoto.com/id/681914964/photo/jerash-of-the-jordanian-city.jpg?s=2048x2048&w=is&k=20&c=PSgg5QAaX0SJmSvibdcw2trfMfA4coUBNl94GBpGxHM=',
            'desc':
                'A Roman archaeological city with columns, theaters, and historic squares showing an important part of ancient history.',
          },
          {
            'title': 'Dead Sea',
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Dead_Sea_by_David_Shankbone.jpg/330px-Dead_Sea_by_David_Shankbone.jpg',
            'desc':
                'The lowest point on Earth, famous for its salty water that helps you float and for therapeutic tourism.',
          },
          {
            'title': 'Ajloun',
            'image':
                'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/AjlunCastle_outside.JPG/500px-AjlunCastle_outside.JPG',
            'desc':
                'A green area in northern Jordan known for Ajloun Castle, nature, and fresh air—perfect for family trips.',
          },
        ];

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final titleColor = Theme.of(context).textTheme.titleLarge?.color;

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            widget.isArabic
                ? 'اماكن سياحية في الاردن'
                : 'Tourist Places in Jordan',
          ),
          backgroundColor: PlacesScreen.kJordanRed,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              tooltip: widget.isArabic ? 'تصغير الخط' : 'Decrease text',
              onPressed: decreaseFont,
              icon: const Icon(Icons.remove),
            ),
            IconButton(
              tooltip: widget.isArabic ? 'تكبير الخط' : 'Increase text',
              onPressed: increaseFont,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _places.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final p = _places[i];

            return Container(
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
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        p['image']!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child:
                              const Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['title']!,
                          style: TextStyle(
                            fontSize: 18 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p['desc']!,
                          style: TextStyle(
                            fontSize: 14 * fontScale,
                            height: 1.5,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Text(
            widget.isArabic
                ? 'حجم الخط: ${(fontScale * 100).round()}٪'
                : 'Text size: ${(fontScale * 100).round()}%',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13 * fontScale, color: textColor),
          ),
        ),
      ),
    );
  }
}
