// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

class AppUser {
  AppUser({
    this.age,
    this.name,
    this.gender,
    this.uid,
    this.images,
    this.imgcount,
    this.likedUsers,
    this.likedBy,
    this.ageMaxPref,
    this.ageMinPref,
    this.matches,
    this.bio,
    this.genderPref,
    this.agePref,
    this.dob,
    this.profile,
    this.dislikes,
    this.favArtists,
    this.matchPercent,
  });

  String name;
  var age;
  var gender;
  var uid;
  List images;
  var imgcount;
  var likedUsers;
  var likedBy;
  var ageMaxPref;
  var ageMinPref;
  var matches;
  var bio;
  var genderPref;
  var agePref;
  var dob;
  var profile;
  var dislikes;
  List favArtists;
  double matchPercent;

  printDetails() {
    print("------------User Details------------\n");
    if (name != null) print("Name:\t$name");
    if (gender != null) print("Gender:\t$gender");
    if (uid != null) print("UID:\t$uid");
    if (images != null) print("Images:\t$images");
    if (age != null) print("Age:\t$age");
    if (ageMaxPref != null) print("Age Max:\t$ageMaxPref");
    if (ageMinPref != null) print("Age Min:\t$ageMinPref");
    if (bio != null) print("Bio:\t$bio");
    if (genderPref != null) {
      print("Gender Preference:\t$genderPref");
    }
    if (dob != null) print("DOB:\t$dob");
    if (profile != null) print("Profile:\t$profile");
    if (favArtists != null) print("FavArtists:\t$favArtists");
    if (matchPercent != null) {
      print("Match Percent:\t$matchPercent");
    }
  }
}
