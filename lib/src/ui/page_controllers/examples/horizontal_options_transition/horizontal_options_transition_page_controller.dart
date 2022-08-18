import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:playground_app/src/interfaces/i_view_controller.dart';
import 'package:playground_app/src/managers/page_manager/page_manager.dart';
import 'package:playground_app/src/models/horizontal_options_transition/song_model.dart';
import 'package:playground_app/src/providers/horizontal_options_transition_provider.dart';
import 'package:playground_app/utils/page_args.dart';
import 'package:provider/provider.dart';

class HorizontalOptionsTransitionPageController extends ControllerMVC
    implements IViewController {
  static late HorizontalOptionsTransitionPageController _this;

  factory HorizontalOptionsTransitionPageController() {
    _this = HorizontalOptionsTransitionPageController._();
    return _this;
  }

  static HorizontalOptionsTransitionPageController get con => _this;
  final formKey = GlobalKey<FormState>();

  PageArgs? args;

  HorizontalOptionsTransitionPageController._();

  //Horizontal Options Transition
  AnimationController? animationController;
  Animation<double>? startAnimation;
  Animation<double>? endAnimation;
  Animation<double>? horizontalAnimation;
  PageController? pageController;

  //Light Switches
  final List<Map> homeItems = [
    {
      'location': 'Oficina 17 5to Piso',
      'power': '15.7 Mwh',
      'icon': Icons.lightbulb_outline
    },
    {
      'location': 'Oficina 15 5to Piso',
      'power': '2.3 Mwh',
      'icon': Icons.lightbulb_outline
    },
    {
      'location': 'Oficina 6 1er Piso',
      'power': '8.4 Mwh',
      'icon': Icons.lightbulb_outline
    },
  ];

  @override
  void initPage(
      {PageArgs? arguments,
      BuildContext? context,
      TickerProviderStateMixin? page}) {
    pageController = PageController();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 750), vsync: page!);

    startAnimation = CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0.000, 0.500, curve: Curves.easeInExpo),
    );

    endAnimation = CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0.500, 1.000, curve: Curves.easeOutExpo),
    );

    horizontalAnimation = CurvedAnimation(
      parent: animationController!,
      curve: const Interval(0.750, 1.000, curve: Curves.easeInOutQuad),
    );

    animationController!
      ..addStatusListener((status) {
        final model = Provider.of<HorizontalOptionsTransitionProvider>(context!,
            listen: false);
        if (status == AnimationStatus.completed) {
          model.swapColors();
          animationController!.reset();
        }
      })
      ..addListener(() {
        final model = Provider.of<HorizontalOptionsTransitionProvider>(context!,
            listen: false);
        if (animationController!.value > 0.5) {
          model.isHalfWay = true;
        } else {
          model.isHalfWay = false;
        }
      });
  }

  @override
  disposePage() {}

  onBack() {
    PageManager().goBack();
  }

  List<SongModel> getSongs() {
    List<SongModel> songs = [];
    songs.add(SongModel(0, 'Mi Propio Repo', 'por Eddie Macaroff',
        'images/horizontal_options_transition/song_list/mi_propio_repo.png'));
    songs.add(SongModel(1, 'La Mano de Dios', 'por Rodrigo Bueno',
        'images/horizontal_options_transition/song_list/la_mano_de_dios.png'));
    songs.add(SongModel(2, 'De Música Ligera', 'por Soda Stereo',
        'images/horizontal_options_transition/song_list/de_musica_ligera.png'));
    songs.add(SongModel(3, 'Fix You', 'por Coldplay',
        'images/horizontal_options_transition/song_list/fix_you.png'));
    songs.add(SongModel(4, 'Time', 'por Pink Floyd',
        'images/horizontal_options_transition/song_list/time.png'));
    songs.add(SongModel(5, 'Feel Good Inc.', 'por Gorillaz',
        'images/horizontal_options_transition/song_list/feel_good_inc.png'));

    return songs;
  }
}
