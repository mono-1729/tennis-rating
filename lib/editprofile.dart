import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'mypage.dart';

class EditProfilePage extends StatefulWidget {
  final String name; //上位Widgetから受け取りたいデータ
  final Image img;
  final String id;
  EditProfilePage(
      {Key? key, required this.name, required this.img, required this.id})
      : super(key: key);

  @override
  _EditProfilePageState createState() =>
      _EditProfilePageState(this.name, this.img, this.id);
}

class _EditProfilePageState extends State<EditProfilePage> {
  // 入力した投稿メッセージ
  String ErrorText = '';
  _EditProfilePageState(this.name, this.img, this.id);
  String name;
  String id;
  Image img;
  String? imagePath;
  File? imageFile;

  Future<void> PickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> test() async {
    Future upload_firebase_web() async {
      final picker = ImagePickerWeb();
      final uint8list = await ImagePickerWeb.getImageAsBytes();
      if (uint8list != null) {
        File file = File.fromRawPath(uint8list);
        FirebaseStorage.instance.ref("sample").putFile(file);
      }
    }
  }

  Future UploadImageURL() async {
    final imageURL = _UploadImage();
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'imgURL': imageURL});
  }

  Future _UploadImage() async {
    Reference ref = FirebaseStorage.instance.ref('/');
    TaskSnapshot snapshot = await ref.child('icons/${id}').putData(
          await imageFile!.readAsBytes(),
          SettableMetadata(contentType: 'image/jpeg'),
        );
    final downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User user = userState.user!;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  imagePath != null
                      ? ClipOval(
                          child: Container(
                            width: 48,
                            height: 48,
                            child: Image.network(imagePath!),
                          ),
                        )
                      : ClipOval(
                          child: Container(
                            width: 48,
                            height: 48,
                            child: img,
                          ),
                        ),
                  ElevatedButton(
                    child: Text('画像を選択'),
                    onPressed: () async {
                      await PickImage();
                    },
                  ),
                ],
              ),
              TextFormField(
                initialValue: widget.name,
                decoration: InputDecoration(labelText: '名前'),
                onChanged: (String value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              SizedBox(height: 8),
              Text(ErrorText),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: ElevatedButton(
                      child: Text('戻る'),
                      onPressed: () async {
                        await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                            return MyWidget(selectedIndex: 3);
                          }),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                        child: Text('保存'),
                        onPressed: () async {
                          if (imagePath != null) {
                            /*Reference ref = FirebaseStorage.instance.ref('/');
                          TaskSnapshot snapshot = await ref
                              .child('icons/${id}')
                              .putFile(imageFile!);

                          final downloadURL =
                              await snapshot.ref.getDownloadURL();
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(id)
                              .update({'imgURL': downloadURL});
                        }*/
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .update({'name': name});
                            await Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return MyWidget(selectedIndex: 3);
                              }),
                            );
                          }
                          ;
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
