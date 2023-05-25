class Usuario {
  final String FullName;
  final String UID;
  bool isFollowedByMe;
  final String image;

  Usuario(this.FullName, this.UID,this.isFollowedByMe, this.image);

  get isFollowing => this.isFollowedByMe;
  get gettUID => this.UID;
  get getImage => this.image;
}