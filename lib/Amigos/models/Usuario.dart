class Usuario {
  final String FullName;
  bool isFollowedByMe;

  Usuario(this.FullName, this.isFollowedByMe);

  get isFollowing => this.isFollowedByMe;
}