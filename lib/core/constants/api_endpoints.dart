class ApiEndPoints{
  static const signUp="Registration/signup";
  static const signIn="Registration/signin";
  static const initialprofile="Profile/createProfile";
  static const uploadImages = "FileUpload/upload-multiple";
  static const createPost = "Post/CreatePost";
  static const fetchPost="Post/FetchAllPosts";
  static const toggleLike="Like/toggle";
  static const getMyProfile   = 'Profile/me'; 
  static const createComment = 'comments';
  static String getPostComments(String postId) => 'posts/$postId/comments';
}
