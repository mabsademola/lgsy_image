import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

import '../../../linker.dart';

class ImageViewer extends StatelessWidget {
  const ImageViewer({
    super.key,
    required this.selectedEntity,
    required this.isCover,
  });

  final AssetEntity? selectedEntity;
  final bool isCover;

  @override
  Widget build(BuildContext context) {
    return AssetEntityImage(
      selectedEntity!,
      isOriginal: true,
      thumbnailSize: const ThumbnailSize.square(250),
      fit: isCover ? BoxFit.cover : BoxFit.fitHeight,
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      },
    );
  }
}
