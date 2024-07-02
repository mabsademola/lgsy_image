import 'package:lgsy_image/linker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'components/image_viewer.dart';
import 'components/media_services.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class MediaPicker extends StatefulWidget {
  const MediaPicker({super.key});

  @override
  State<MediaPicker> createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  AssetPathEntity? selectedAlbum;
  AssetEntity? selectedEntity;
  List<AssetPathEntity> albumList = [];
  List<AssetEntity> assetList = [];
  List<AssetEntity> selectedAssetList = [];
  bool isMultiple = false;
  bool isCover = true;

  @override
  void initState() {
    MediaServices.loadAlbums(RequestType.common).then((v) {
      setState(() {
        albumList = v;
        selectedAlbum = v[0];
      });
      MediaServices.loadAssets(selectedAlbum!).then((v) {
        setState(() {
          assetList = v;
          selectedEntity = v[0];
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: Column(
        children: [
          if (selectedEntity != null)
            SizedBox(
                height: context.height() * 0.4,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ImageViewer(
                          selectedEntity: selectedEntity, isCover: isCover),
                    ),
                    if (selectedEntity!.type == AssetType.video)
                      const Positioned.fill(
                          child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.play_circle_sharp,
                                    size: 50,
                                    color: Colors.white,
                                  )))),
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    isCover = !isCover;
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    child: Icon(
                                      isCover
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                )))),
                  ],
                )),
          buildButtom()
        ],
      ),
    );
  }

  Widget buildButtom() {
    return Flexible(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: selectedAlbum != null,
                replacement: 10.width,
                child: SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                          onTap: () {
                            albums();
                          },
                          child: CustomWidget.text6(
                              selectedAlbum != null
                                  ? selectedAlbum!.name
                                  : 'Loading...',
                              fontSize: 17)),
                      6.width,
                      const Icon(Icons.keyboard_arrow_down)
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMultiple = !isMultiple;
                        selectedAssetList = [];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isMultiple
                            ? Colors.blue
                            : Colors.grey.withOpacity(0.3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.collections_outlined,
                            size: 15,
                          ),
                          8.width,
                          CustomWidget.text5('SELECT MULTIPLE', fontSize: 13),
                        ],
                      ),
                    ),
                  ),
                  10.width,
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Flexible(
            child: assetList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, mainAxisSpacing: 1),
                    itemCount: assetList.length,
                    itemBuilder: (context, index) {
                      AssetEntity assetEntity = assetList[index];
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: assetWidget(assetEntity),
                      );
                    }))
      ],
    ));
  }

  AppBar appbar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: CustomWidget.text6('Create Post', fontSize: 20),
      leading: const CloseButton(
        color: kWhiteColor,
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Center(
              child:
                  CustomWidget.text5('Next', color: Colors.blue, fontSize: 14),
            ))
      ],
    );
  }

  void albums() {
    showModalBottomSheet(
        backgroundColor: const Color(0xff101010),
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        builder: (context) {
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: albumList.length,
              itemBuilder: (context, index) => ListTile(
                  onTap: () {
                    setState(() {
                      selectedAlbum = albumList[index];
                    });
                    MediaServices.loadAssets(selectedAlbum!).then((v) {
                      setState(() {
                        assetList = [];
                        assetList = v;
                        selectedEntity = v[0];
                      });
                    });
                    context.close();
                  },
                  title: Text(
                    albumList[index].name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  )));
        });
  }

  Widget assetWidget(AssetEntity assetEntity) {
    return GestureDetector(
      onTap: () {
        if (isMultiple == true) {
          selectAsset(assetEntity);
        }
        setState(() {
          selectedEntity = assetEntity;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
              child: AssetEntityImage(
            assetEntity,
            isOriginal: false,
            thumbnailSize: const ThumbnailSize.square(250),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              );
            },
          )),
          if (selectedEntity!.type == AssetType.video)
            const Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.play_circle_sharp,
                          color: Colors.white,
                        )))),
          if (isMultiple == true)
            Positioned.fill(
                child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: count(assetEntity)))),
        ],
      ),
    );
  }

  Container count(AssetEntity assetEntity) {
    bool isSelected = selectedAssetList.contains(assetEntity);
    return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: CustomWidget.text6(
              !isSelected
                  ? ""
                  : "${selectedAssetList.indexOf(assetEntity) + 1}",
              fontSize: 14),
        ));
  }

  void selectAsset(AssetEntity assetEntity) {
    if (selectedAssetList.contains(assetEntity)) {
      setState(() {
        selectedAssetList.remove(assetEntity);
      });
    } else {
      setState(() {
        selectedAssetList.add(assetEntity);
      });
    }
  }
}
