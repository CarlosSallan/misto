class Usuario {
  final String FullName;
  final String UID;
  bool isFollowedByMe;
  double latitude;
  double longitude;

  Usuario(this.FullName, this.UID,this.isFollowedByMe, this.latitude, this.longitude);

  get isFollowing => this.isFollowedByMe;
  get gettUID => this.UID;
  get getLatitude => this.latitude;
  get getLongitude => this.longitude;
}