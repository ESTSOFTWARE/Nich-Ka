import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: InteractiveViewer(
        minScale: 1.0,
        maxScale: 5.0,
        child: SizedBox(
          width: size.width,
          height:
              size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              final total = loadingProgress.expectedTotalBytes;
              final progress = total != null
                  ? loadingProgress.cumulativeBytesLoaded / total
                  : null;
              return Center(
                child: CircularProgressIndicator(
                  value: progress,
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image, color: Colors.white54, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Error al cargar la imagen',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
