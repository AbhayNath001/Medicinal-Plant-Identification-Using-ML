//4
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  List? _results;
  bool imageSelect = false;
  bool ima = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt"))!; //working
    // model: "assets/model.tflite",
    // labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    File image = File(pickedFile!.path);
    imageclassification(image);
  }

  Future imageclassification(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      // numResults: 6,
      // threshold: 0.05,
      // imageMean: 127.5,
      // imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
      ima = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Classification"),
      ),
      body: ListView(
        children: [
          imageSelect == true
              ? Container(
                  margin: EdgeInsets.all(10),
                  child: Image.file(_image!),
                )
              : Container(
                  margin: EdgeInsets.all(10),
                  child: Opacity(
                    opacity: 0.8,
                    child: Center(
                      child: Text("No image selected"),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      ima = true;
                    });
                  },
                  child: Text("Detect")),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: Column(
              children: ima == true
                  ? _results!.map((result) {
                      return Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "${result['label']}-${result['confidence'].toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }).toList()
                  : [],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickImage,
        child: Icon(Icons.image),
      ),
    );
  }
}

//3
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   File? _image;
//   List<dynamic>? _output;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   loadModel() async {
//     await Tflite.loadModel(
//         model: "assets/model_resnet.tflite",
//         labels: "assets/labels.txt",
//         isAsset: true,
//         numThreads: 1,
//         useGpuDelegate: false);
//   }

//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }

//   classifyImage() async {
//     if (_image == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     var output = await Tflite.runModelOnImage(
//       path: _image!.path,
//       numResults: 5,
//     );

//     setState(() {
//       _isLoading = false;
//       _output = output;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Plant Detection"),
//       ),
//       body: Column(
//         children: <Widget>[
//           _image == null
//               ? Center(child: Text("Select an image."))
//               : Image.file(_image!),
//           _isLoading
//               ? CircularProgressIndicator()
//               : _output != null
//                   ? Column(
//                       children: <Widget>[
//                         Text(
//                           "Results:",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: _output!.length,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(
//                                   "${_output![index]["label"]}: ${(_output![index]["confidence"] * 100).toStringAsFixed(2)}%"),
//                             );
//                           },
//                         ),
//                       ],
//                     )
//                   : SizedBox(height: 0),
//           ElevatedButton(
//             onPressed: () async {
//               var image =
//                   await ImagePicker().getImage(source: ImageSource.gallery);
//               setState(() {
//                 _image = File(image!.path);
//               });
//               classifyImage();
//             },
//             child: Text("Pick an image"),
//           ),
//         ],
//       ),
//     );
//   }
// }

// 1
// // ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   var pickedImage = null;
//   Future<dynamic> showProfilePictureDialog(BuildContext context) async {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext c) {
//         return Dialog(
//           child: Container(
//             height: 170,
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text(
//                     "Choose Photo",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 3,
//                   ),
//                   Divider(
//                     height: 1,
//                     color: Colors.black,
//                     thickness: 1,
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.0, right: 8, top: 8),
//                     child: GestureDetector(
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.camera,
//                             size: 30,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             "Camera",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         pickImage(ImageSource.camera);
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 8.0, right: 8, top: 8),
//                     child: GestureDetector(
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.image,
//                             size: 30,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             "Gallery",
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         pickImage(ImageSource.gallery);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   pickImage(ImageSource imagetype) async {
//     final ImagePicker picker = ImagePicker();
//     try {
//       final photo = await picker.pickImage(source: imagetype);
//       if (photo == null) {
//         return;
//       }
//       final tempImg = File(photo.path);
//       setState(() {
//         this.pickedImage = tempImg;
//       });
//       print("wnfnevvv $pickedImage");
//       Navigator.of(context).pop();
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         toolbarHeight: 60,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(30),
//             bottomRight: Radius.circular(30),
//           ),
//         ),
//         elevation: 10,
//         title: Text("Edit Profile"),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(25.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 width: 100,
//                 height: 100,
//                 child: pickedImage != null
//                     ? Image.file(
//                         pickedImage!,
//                         fit: BoxFit.cover,
//                       )
//                     : Icon(Icons.image),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await showProfilePictureDialog(context);
//                 },
//                 child: Text("add Image"),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               ElevatedButton(
//                 onPressed: () async {},
//                 child: Text("save Image"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// 2
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
// import 'package:image_picker/image_picker.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   bool _loading = true;
//   late FileImage _image;
//   late List _output;
//   final picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     loadModel().then((value) {
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     Tflite.close();
//   }

//   classifyImage(File image) async {
//     var output = await Tflite.runModelOnImage(
//       path: image.path,
//       numResults: 36,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );
//     setState(() {
//       _output = output!;
//       _loading = false;
//     });
//   }

//   loadModel() async {
//     await Tflite.loadModel(
//         model: 'assets/model/model_unquant.tflite',
//         labels: 'assets/model/labels.txt');
//   }

//   pickImage() async {
//     var image = await picker.pickImage(source: ImageSource.camera);
//     if (image == null) return null;
//     setState(() {
//       _image = File(image.path) as FileImage;
//     });
//     classifyImage(_image as File);
//   }

//   pickGalleryImage() async {
//     var image = await picker.pickImage(source: ImageSource.gallery);
//     if (image == null) return null;
//     setState(() {
//       _image = File(image.path) as FileImage;
//     });
//     classifyImage(_image as File);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           'Plant',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w200,
//             fontSize: 20,
//             letterSpacing: 0.8,
//           ),
//         ),
//       ),
//       body: Container(
//         color: Colors.black.withOpacity(0.9),
//         padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
//         child: Container(
//           alignment: Alignment.center,
//           padding: EdgeInsets.all(30),
//           decoration: BoxDecoration(
//             color: Color(0xFF2A363B),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 child: Center(
//                   child: _loading == true
//                       ? null
//                       : Container(
//                           child: Column(
//                             children: [
//                               Container(
//                                 height: 250,
//                                 width: 250,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(30),
//                                   child: Image.file(
//                                     _image as File,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                               ),
//                               Divider(
//                                 height: 25,
//                                 thickness: 1,
//                               ),
//                               _output != null
//                                   ? Text(
//                                       'The object is: ${_output[0]['label']}!',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w400),
//                                     )
//                                   : Container(),
//                               Divider(
//                                 height: 25,
//                                 thickness: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                 ),
//               ),
//               Container(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: pickImage, //no parenthesis
//                       child: Container(
//                         width: MediaQuery.of(context).size.width - 200,
//                         alignment: Alignment.center,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 24, vertical: 17),
//                         decoration: BoxDecoration(
//                             color: Colors.blueGrey[600],
//                             borderRadius: BorderRadius.circular(15)),
//                         child: Text(
//                           'Take A Photo',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     GestureDetector(
//                       onTap: pickGalleryImage, //no parenthesis
//                       child: Container(
//                         width: MediaQuery.of(context).size.width - 200,
//                         alignment: Alignment.center,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 24, vertical: 17),
//                         decoration: BoxDecoration(
//                             color: Colors.blueGrey[600],
//                             borderRadius: BorderRadius.circular(15)),
//                         child: Text(
//                           'Pick From Gallery',
//                           style: TextStyle(color: Colors.white, fontSize: 16),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
