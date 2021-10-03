// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:ui';

import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:new_registreation1/models/genre.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/app_user.dart';
import 'models/Artist.dart';

AppUser currentAppUser = AppUser();
int minAge;
int maxAge;
String selectedGenderPreference;
String bio;
File image;
String profileUrl;
List<String> downloadAddress = [];
List selectedImgFiles = List.filled(6, null, growable: false);
List<Artist> artists = [];
int minCriteria = 1;
//SwiperController swiperController = SwiperController();
final genrecontroller = DragSelectGridViewController();
final artistcontroller = DragSelectGridViewController();
List genreNames = [
  'Rock',
  'Hip-Hop',
  'Pop',
  'Jazz',
  'Country',
  'Dance',
  'Blues',
  'Heavy',
  'Folk',
  'Classical',
  'Soul',
  'Electronic',
  'Punk',
  'Techno',
  'Funk',
  'Disco',
  'Indie',
  'Instrumental',
  'K-Pop',
  'Dubstep',
  'Rap',
  'Bollywood',
  'Opera',
  'Anime',
  'Edm',
  'Metal',
  'Punjabi',
  'Telugu'
];
var uploadingProfilePictureAttempt = 0;
List<Genre> genres = [];
final List<Color> colors = [
  const Color(0xff268469),
  const Color(0xff1d3362),
  const Color(0xff8b68aa),
  const Color(0xffe71159),
  const Color(0xffaf2795),
  const Color(0xffa56752),
  const Color(0xff538007),
  const Color(0xff8a1a32),
  const Color(0xfffc4630),
  const Color(0xff2d46ba),
  const Color(0xff467e95),
  const Color(0xff268469),
  const Color(0xff1d3362),
  const Color(0xff8b68aa),
  const Color(0xffe71159),
  const Color(0xffaf2795),
  const Color(0xffa56752),
  const Color(0xff538007),
  const Color(0xff8a1a32),
  const Color(0xfffc4630),
  const Color(0xff2d46ba),
  const Color(0xff467e95),
  const Color(0xff268469),
  const Color(0xff1d3362),
  const Color(0xff1d3362),
  const Color(0xff8b68aa),
  const Color(0xffe71159),
  const Color(0xffaf2795),
];
List selectedGenres = [];
List<Artist> userPreferredArtists = List.filled(
  100,
  Artist(genre: "", image: "", name: "", popularity: 0, uri: ""),
  growable: true,
);
List<Artist> selectedArtists = [];
void launchURL(url) async =>
    await canLaunch(url) ? await launch(url) : print('Could not launch $url');
var temporaryuserPreferredArtists;

dispose() {
  genrecontroller.dispose();
  artistcontroller.dispose();
}

intializeGlobalVariables() {
  currentAppUser = AppUser();
  minAge = 18;
  maxAge = 25;
  selectedGenderPreference = "";
  bio = "";
  image = null;
  profileUrl = "";
  downloadAddress = [];
  selectedImgFiles = List.filled(6, null, growable: false);
  artists = [];
  minCriteria = 1;
  //swiperController = SwiperController()
  selectedArtists = [];
  userPreferredArtists = List.filled(
    100,
    Artist(genre: "", image: "", name: "", popularity: 0, uri: ""),
    growable: true,
  );
}
