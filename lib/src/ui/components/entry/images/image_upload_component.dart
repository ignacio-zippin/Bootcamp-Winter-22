import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:playground_app/src/ui/components/entry/images/snack_bar_picture_source_component.dart';
import 'package:playground_app/src/ui/popups/loading_popup.dart';
import 'package:playground_app/values/k_colors.dart';
import 'package:playground_app/values/k_values.dart';

// ignore: must_be_immutable
class ImageUploadComponent extends StatefulWidget {
  String? label;
  Function(File?)? getFile;
  File? file;
  String? imageUrl;
  Function()? deleteFile;
  Function()? onTap;
  bool? isEditable;
  double height;
  double width;
  double cropRatio;
  bool editImageAfterPick = false;
  CustomCropperOptions? customCropperOptions;
  bool enableGallery = true;
  bool enableCamera = true;

  ImageUploadComponent({
    Key? key,
    this.label,
    required this.getFile,
    this.file,
    this.imageUrl,
    required this.deleteFile,
    this.onTap,
    this.height = 240,
    this.width = 350,
    this.cropRatio = 1,
    this.isEditable = true,
    this.editImageAfterPick = false,
    this.customCropperOptions,
    this.enableCamera = true,
    this.enableGallery = true,
  }) : super(key: key);

  @override
  _ImageUploadComponentState createState() => _ImageUploadComponentState();
}

class _ImageUploadComponentState extends State<ImageUploadComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
        onTap();
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: KGrey_L1,
              spreadRadius: -5,
              blurRadius: 10,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              //borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: widget.file != null ||
                      (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                  ? widget.file != null
                      ? Image.file(
                          widget.file!,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height,
                          width: widget.width,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.imageUrl!,
                          fit: BoxFit.cover,
                          width: widget.width,
                          errorWidget: (context, url, error) => _placeHolder(),
                          placeholder: (context, url) => _placeHolder(),
                        )
                  : _placeHolder(),
            ),
            _buttonTrash(widget.file, widget.deleteFile),
          ],
        ),
      ),
    );
  }

  void onTap() {
    /* if (!widget.enableCamera && !widget.enableGallery) {
      Fluttertoast.showToast(
          //i18n?
          msg: "Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: KGrey_L1,
          textColor: KWhite,
          fontSize: 16.0);
    } else if (widget.enableCamera && !widget.enableGallery) {
      getImageFromCamera();
    } else if (!widget.enableCamera && widget.enableGallery) {
      getImageFromGallery();
    } else { */
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBarPictureSourceComponent.build(
            context, getImageFromPDF, getImageFromCamera, getImageFromGallery));
    /* } */
  }

  // Inicio Gallery
  Future getImageFromGallery() async {
    bool permissionsGranted = await checkStoragePermissions();
    if (permissionsGranted) {
      try {
        File? file;
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null) {
          file = File(result.files.single.path!);
        } else {
          debugPrint("Image selection cancelled");
          file = null;
        }

        if (file != null) {
          if (widget.editImageAfterPick) {
            File? temp = await cropImage(file.path);
            if (temp != null) {
              file = temp;
            }
          }
          showFilePicked(file.path);
        }
      } catch (ex) {
        debugPrint(ex.toString());
      }
    } else {
      permission_handler.openAppSettings();
    }
  }

  Future<bool> checkStoragePermissions() async {
    Map<permission_handler.Permission, permission_handler.PermissionStatus>
        statuses = await [
      permission_handler.Permission.storage,
      permission_handler.Permission.photos,
    ].request();

    return statuses[permission_handler.Permission.storage]!.isGranted == true &&
        statuses[permission_handler.Permission.photos]!.isGranted == true;
  }

  // Fin Gallery

  // Inicio PDF
  Future getImageFromPDF() async {}

  // Fin PDF

  // Inicio Camera
  getImageFromCamera() async {
    await LoadingPopup(
        context: context,
        onLoading: getCameras(),
        onResult: (data) => openViewer(data),
        onError: (error) => {}).show();
  }

  getCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    return cameras;
  }

  openViewer(List<CameraDescription> cameras) async {
    String? navigationResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(cameras),
      ),
    );
    if (navigationResult != null) {
      if (widget.editImageAfterPick) {
        File? temp = await cropImage(navigationResult);
        if (temp != null) {
          navigationResult = temp.path;
        }
      }
      showFilePicked(navigationResult);
    }
  }

  showFilePicked(String path) {
    setState(() {
      widget.file = File(path);
      widget.file != null
          ? widget.getFile!(widget.file)
          : widget.getFile!(File(path));
    });
  }

  Future<File?> cropImage(String? path) async {
    CustomCropperOptions _customOptions =
        widget.customCropperOptions ?? CustomCropperOptions();
    _customOptions.aspectRatio =
        CropAspectRatio(ratioX: widget.cropRatio, ratioY: 1);
    // ignore: prefer_conditional_assignment
    if (_customOptions.uiSettings == null) {
      _customOptions.uiSettings = [
        AndroidUiSettings(
          statusBarColor: KPrimary,
          toolbarTitle: "",
          toolbarColor: KPrimary,
          //lockAspectRatio: true,
          toolbarWidgetColor: KWhite,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
        ),
        IOSUiSettings(
          title: "",
        ),
      ];
    }
    if (path != null) {
      try {
        CroppedFile? temp = await ImageCropper().cropImage(
          sourcePath: path,
          aspectRatio: _customOptions.aspectRatio,
          compressFormat: _customOptions.compressFormat,
          compressQuality: _customOptions.compressQuality,
          cropStyle: _customOptions.cropStyle,
          uiSettings: _customOptions.uiSettings,
          maxHeight: _customOptions.maxHeight,
          maxWidth: _customOptions.maxWidth,
        );
        if (temp != null) {
          return File(temp.path);
        } else {
          throw Exception("Error al intentar recortar la imagen");
        }
      } catch (err) {
        throw Exception(err);
      }
    } else {
      throw Exception("Error al intentar recortar la imagen");
    }
  }

  _placeHolder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "images/icon_camera.png",
          height: 20,
          width: 20,
          color: KGrey_L1,
          fit: BoxFit.contain,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          widget.label ?? "Inserte imágen del documento",
          style: const TextStyle(
            color: KGrey_L1,
            fontWeight: FontWeight.normal,
            fontSize: KFontSizeSmall30,
          ),
        )
      ],
    );
  }

  _buttonTrash(_file, Function? function) {
    return Visibility(
      visible: _file != null && widget.isEditable!,
      child: Positioned(
        bottom: -2,
        right: -2,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15, right: 15),
          child: GestureDetector(
            onTap: () {
              _file != null ? function!() : null;
            },
            child: Container(
              height: 35,
              width: 35,
              padding: const EdgeInsets.all(8),
              decoration: _iconTrashDecoration(),
              child: Image.asset(
                "images/icon_trash.png",
                fit: BoxFit.contain,
                color: KWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _iconTrashDecoration() {
    return BoxDecoration(
      color: const Color(0xFFE12E31),
      borderRadius: BorderRadius.all(
        Radius.circular(widget.height),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x40A62123),
          spreadRadius: 1,
          blurRadius: 1,
        ),
      ],
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const TakePictureScreen(this.cameras, {Key? key}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  CameraDescription? cameraDescription;

  @override
  void initState() {
    super.initState();
    _initCamera(widget.cameras.first);
  }

  void _initCamera(CameraDescription description) {
    _controller =
        CameraController(description, ResolutionPreset.max, enableAudio: false);
    try {
      _initializeControllerFuture = _controller.initialize();
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  takePicture() async {
    await _initializeControllerFuture;
    return await _controller.takePicture();
  }

  FlashMode flashMode = FlashMode.off;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KBlack,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            flashMode == FlashMode.off
                ? _controller.setFlashMode(FlashMode.off)
                : _controller.setFlashMode(FlashMode.always);
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CameraPreview(_controller),
                      Positioned(
                        bottom: MediaQuery.of(context).size.height / 8,
                        child: Row(
                          children: [
                            FloatingActionButton(
                                heroTag: "button flash",
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                onPressed: () {
                                  setState(() {
                                    if (flashMode == FlashMode.off) {
                                      _controller
                                          .setFlashMode(FlashMode.always);
                                      flashMode = FlashMode.always;
                                    } else {
                                      _controller.setFlashMode(FlashMode.off);
                                      flashMode = FlashMode.off;
                                    }
                                  });
                                },
                                child: flashMode == FlashMode.off
                                    ? const Icon(Icons.flash_off)
                                    : const Icon(Icons.flash_on)),
                            const SizedBox(width: 20),
                            FloatingActionButton(
                              backgroundColor: KPrimary,
                              heroTag: "button camera",
                              onPressed: () async {
                                await LoadingPopup(
                                    context: context,
                                    onLoading: takePicture(),
                                    onResult: (image) =>
                                        Navigator.pop(context, image.path),
                                    onError: (error) =>
                                        {Navigator.pop(context)}).show();
                              },
                              child: const Icon(Icons.camera_alt),
                            ),
                            const SizedBox(width: 20),
                            Visibility(
                              visible: widget.cameras.length > 1,
                              child: FloatingActionButton(
                                  heroTag: "button change camera",
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () async {
                                    setState(() {
                                      // get current lens direction (front / rear)
                                      final lensDirection =
                                          _controller.description.lensDirection;
                                      CameraDescription newDescription;
                                      if (lensDirection ==
                                          CameraLensDirection.front) {
                                        newDescription = widget.cameras
                                            .firstWhere((description) =>
                                                description.lensDirection ==
                                                CameraLensDirection.back);
                                      } else {
                                        newDescription = widget.cameras
                                            .firstWhere((description) =>
                                                description.lensDirection ==
                                                CameraLensDirection.front);
                                      }
                                      _initCamera(newDescription);
                                    });
                                  },
                                  child: Platform.isIOS
                                      ? const Icon(Icons.flip_camera_ios)
                                      : const Icon(Icons.flip_camera_android)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class CustomCropperOptions {
  CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1);
  ImageCompressFormat compressFormat = ImageCompressFormat.jpg;
  int compressQuality = 90;
  CropStyle cropStyle = CropStyle.rectangle;
  int? maxHeight;
  int? maxWidth;
  List<PlatformUiSettings>? uiSettings = [
    AndroidUiSettings(
      statusBarColor: KPrimary,
      toolbarTitle: "",
      toolbarColor: KPrimary,
      lockAspectRatio: true,
      toolbarWidgetColor: KWhite,
    ),
    IOSUiSettings(
      title: "",
    ),
  ];

  CustomCropperOptions({
    this.aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
    this.compressFormat = ImageCompressFormat.jpg,
    this.compressQuality = 90,
    this.cropStyle = CropStyle.rectangle,
    this.maxHeight,
    this.maxWidth,
    this.uiSettings,
  });
}
