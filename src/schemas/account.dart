import 'package:dartson/dartson.dart';

@Entity()
class Account {
  int id;
  String name;
  String type;
  String status;
  bool favorite;
}
