// ignore_for_file: file_names

class Artist {
  Artist({
    this.genre,
    this.image,
    this.name,
    this.popularity,
    this.uri,
    this.isSelected = false,
  });
  var name;
  var image;
  var popularity;
  var uri;
  var genre;
  var isSelected;

  printDetails() {
    print("------------Artist Details------------\n");
    // ignore: unnecessary_this
    if (this.name != null) print("Name:\t${this.name}");
    if (this.image != null) print("Images:\t${this.image}");
    if (this.popularity != null) print("Popularity:\t${this.popularity}");
    if (this.uri != null) print("Uri:\t${this.uri}");
    if (this.genre != null) print("Images:\t${this.genre}");
  }

  toJson() => {
        "name": this.name,
        "image": this.image,
        "popularity": this.popularity,
        "uri": this.uri,
        "genre": this.genre,
      };
}
