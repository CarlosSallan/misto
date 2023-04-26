class Usuario {
  final String FullName;
  final String UID;
  bool isFollowedByMe;

  Usuario(this.FullName, this.UID,this.isFollowedByMe);

  get isFollowing => this.isFollowedByMe;
  get gettUID => this.UID;
}