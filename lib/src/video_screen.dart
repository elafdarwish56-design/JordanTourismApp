import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  final bool isArabic;
  const VideoScreen({super.key, required this.isArabic});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late final VideoPlayerController _video;
  bool _ready = false;
  String? _error;

  // الوان
  static const Color _primary = Color(0xFF8B1D1D);
  static const Color _accent = Color(0xFFD32F2F);

  @override
  void initState() {
    super.initState();

    _video = VideoPlayerController.asset('assets/videos/tourism.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _ready = true);
      }).catchError((e) {
        if (!mounted) return;
        setState(() => _error = e.toString());
      });
  }

  @override
  void dispose() {
    _video.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_ready) return;
    setState(() {
      _video.value.isPlaying ? _video.pause() : _video.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.isArabic ? 'فيديو السياحة في الاردن' : 'Jordan Tourism Video';
    final cardTitle = widget.isArabic ? 'مشاهدة الفيديو' : 'Watch Video';
    final btnPlay = widget.isArabic ? 'تشغيل الفيديو' : 'Play Video';
    final btnPause = widget.isArabic ? 'ايقاف مؤقت' : 'Pause';
    final desc = widget.isArabic
        ? 'هذا الفيديو يعرض اماكن سياحية مشهورة في الاردن مثل البتراء ووادي رم والبحر الميت ويبين جمال الطبيعة والتاريخ وكيف السياحة بتساعد اقتصاد البلد'
        : 'This video shows famous tourist places in Jordan such as Petra, Wadi Rum, and the Dead Sea. It highlights Jordan’s nature, history, and how tourism supports the economy.';

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(title),
          backgroundColor: _primary,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                        left: BorderSide(color: _primary, width: 6),
                      ),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.play_circle_fill, color: _primary),
                            const SizedBox(width: 8),
                            Text(
                              cardTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              widget.isArabic
                                  ? 'صار خطأ في تحميل الفيديو:\n$_error'
                                  : 'Error loading video:\n$_error',
                              textAlign: TextAlign.center,
                            ),
                          )
                        else if (!_ready)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: AspectRatio(
                              aspectRatio: _video.value.aspectRatio == 0
                                  ? 16 / 9
                                  : _video.value.aspectRatio,
                              child: VideoPlayer(_video),
                            ),
                          ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed:
                              (_ready && _error == null) ? _togglePlay : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon((_ready && _video.value.isPlaying)
                              ? Icons.pause
                              : Icons.play_arrow),
                          label: Text(
                            (_ready && _video.value.isPlaying)
                                ? btnPause
                                : btnPlay,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      desc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
