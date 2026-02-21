import 'package:flutter/material.dart';

class RatingScreen extends StatefulWidget {
  final bool isArabic;
  const RatingScreen({super.key, required this.isArabic});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int selectedRating = 0;

  static const Color kJordanRed = Color(0xFFB71C1C);
  static const Color kJordanBlack = Color(0xFF111111);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.isArabic ? 'قيم التطبيق' : 'Rate App'),
          centerTitle: true,
          backgroundColor: kJordanRed,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isArabic
                      ? 'قديش أعجبك التطبيق؟'
                      : 'How much did you like the app?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        size: 40,
                        color:
                            index < selectedRating ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kJordanBlack,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: selectedRating == 0
                      ? null
                      : () {
                          final msg = widget.isArabic
                              ? 'شكرا! تقييمك $selectedRating نجوم 🌟'
                              : 'Thanks! Your rating is $selectedRating stars 🌟';

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(msg)),
                          );
                        },
                  child: Text(
                    widget.isArabic ? 'إرسال التقييم' : 'Submit Rating',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
