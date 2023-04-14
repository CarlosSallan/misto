class User {
  final String FullName;
  bool isFollowedByMe;

  User(this.FullName, this.isFollowedByMe);

  get isFollowing => false;
}