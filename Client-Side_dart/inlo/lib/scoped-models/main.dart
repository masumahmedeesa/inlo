import 'package:scoped_model/scoped_model.dart';

import './connected_ideas.dart';

class MainModel extends Model with ConnectedIdeasModel, UserModel, IdeasModel, UtilityModel, ProfileModel, CommentBox {
}
