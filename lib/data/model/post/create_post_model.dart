class CreatePostModel{
  final String? content;
  final String? mediaUrls;

  CreatePostModel({
    required this.content,
    this.mediaUrls,
    });
    Map<String,dynamic>toJson(){
      return {
        'content':content,
        'mediaUrls':mediaUrls,
      };
    }
}