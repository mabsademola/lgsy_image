import 'dart:async';
import 'package:photo_manager/photo_manager.dart';

class MediaServices {
  static Future<List<AssetPathEntity>> loadAlbums(
      RequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];

    if (permission.isAuth == true) {
      albumList = await PhotoManager.getAssetPathList(type: requestType);
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  static Future<List<AssetEntity>> loadAssets(
      AssetPathEntity selectedAlbum) async {
    List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(
        start: 0, end: await selectedAlbum.assetCountAsync);

    return assetList;
  }
}
