import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:digital_geeks_agent/model/MyTasks.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

const List<String> list = <String>['Resolved', 'Pending', 'Closed'];

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool _apiHasData = false;
  var _apiHasDataCount = 0;
  final Dio dio = Dio();
  late final Future allTasks;
  DateTime selectedDate = DateTime.now();
  final ImagePicker picker = ImagePicker();
  String dropdownValue = list.first;
  XFile? photo;
  XFile? cameraVideo;
  bool _photoCaptured = false;
  bool _videoCaptured = false;
  late VideoPlayerController _controller;
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();

  Future<MyTasks?> _getAgentTasks() async {
    // EasyLoading.show();
    //Call the Api and assign data to future
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // Save an String value to 'action' key.
      var userJson = json.decode(prefs.getString('user')!);

      final formData = FormData.fromMap({
        'privilege': 'a',
        'date': DateTime.now().toIso8601String(),
        'id': 1,
      });
      final Response response = await dio.post(
        'https://crm.mygeeks.net.au/api/v1/my_tasks',
        data: formData,
        onSendProgress: (int sent, int total) {
          print('${sent / total}');
          EasyLoading.showProgress(sent / total);
        },
      );
      if (response.statusCode == 200) {
        var responseData = json.decode(json.encode(response.data)) as Map;
        print(responseData['data']['followUps'].length);
        _apiHasDataCount = responseData['data']['followUps'].length;
        EasyLoading.dismiss();
        setState(() {
          _apiHasData = true;
        });
        return MyTasks.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e, s) {
      print(e);
      print(s);
      EasyLoading.showInfo("$e");
    }
    return null;
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    Map<String, dynamic>? params = {'api': '1', 'query': '$lat,$lon'};
    final uri = Uri.https(
      'www.google.com',
      '/maps/search/',
      params,
    );
    if (await canLaunchUrl(uri)) {
      EasyLoading.dismiss();
      await launchUrl(uri);
    } else {
      EasyLoading.showError("Could not launch maps");
      throw 'Could not launch $uri';
    }
  }

  Future<List<Location>> getLatAndLongitude(String address) async {
    List<Location> locations = await locationFromAddress(address);
    print(locations);
    return locations;
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url)).then((value) => EasyLoading.dismiss());
    } else {
      EasyLoading.showError("Could not make a call");
      throw 'Could not launch $url';
    }
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        EasyLoading.showInfo("Saving Changes");
      });
    }
    return picked;
  }

  rescheduleAppointment(selectedDate, potId) async {
    final formData = FormData.fromMap({
      'pot_id': potId,
      'appointment_date': DateTime.now().toIso8601String(),
      'appointment_time': 1,
    });
    final Response response = await dio.post(
      'https://crm.mygeeks.net.au/api/v1/my_tasks_reschedule',
      data: formData,
      onSendProgress: (int sent, int total) {
        print('${sent / total}');
        EasyLoading.showProgress(sent / total);
      },
    );
    print(response.data);
    if (response.statusCode == 200) {
      EasyLoading.showSuccess("Saved");
    }
    EasyLoading.dismiss();
  }

  _saveJobSheet({job_id, comment_id, comment_notes, status, user_id, video, photo}) async {
   try{
     if(photo != null && video != null){
       final formData = FormData.fromMap({
         'job_id': job_id,
         'comment_id': comment_id,
         'comment_notes': comment_notes,
         'status': status,
         'user_id': user_id,
         'photo' : await MultipartFile.fromFile(photo.path, filename:photo.path.split('/').last),
         'video' : await MultipartFile.fromFile(video.path, filename:video.path.split('/').last),
       });
       print(formData.fields);
       final Response response = await dio.post(
         'https://crm.mygeeks.net.au/api/v1/add_job_sheet',
         data: formData,
         onSendProgress: (int sent, int total) {
           print('${sent / total}');
           EasyLoading.showProgress(sent / total);
         },
       );
       if(response.statusCode == 200){
         var responseData = jsonDecode(jsonEncode(response.data)) as Map;
         print(response.data);
         EasyLoading.showInfo("${responseData['message']}");
       }else{
         EasyLoading.showError("Missing Data");
       }
     }else{
       EasyLoading.showError("Please snap a picture and a video");
     }
   }catch(e){
     EasyLoading.showError(e.toString());
   }
  }


  acceptTask({followup_id}) async {
    final formData = FormData.fromMap({
      'followup_id': followup_id
    });
    final Response response = await dio.post(
      'https://crm.mygeeks.net.au/api/v1/my_tasks_accept',
      data: formData,
      onSendProgress: (int sent, int total) {
        print('${sent / total}');
        EasyLoading.showProgress(sent / total);
      },
    );
    if(response.statusCode == 200){
      var responseData = jsonDecode(jsonEncode(response.data)) as Map;
      EasyLoading.showInfo("${responseData['message']}");
    }else{
      EasyLoading.showError("Missing Data");
    }
  }
  rejectTask({followup_id}) async {
    final formData = FormData.fromMap({
      'followup_id': followup_id
    });
    final Response response = await dio.post(
      'https://crm.mygeeks.net.au/api/v1/my_tasks_reject',
      data: formData,
      onSendProgress: (int sent, int total) {
        print('${sent / total}');
        EasyLoading.showProgress(sent / total);
      },
    );
    if(response.statusCode == 200){
      var responseData = jsonDecode(jsonEncode(response.data)) as Map;
      EasyLoading.showInfo("${responseData['message']}");
    }else{
      EasyLoading.showError("Missing Data");
    }
  }

  Future<void> _handleRefresh() {
    return _getAgentTasks().then((value) {
      _refreshIndicatorKey.currentState!.show();
    });
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _getAgentTasks());
    allTasks = _getAgentTasks();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      key: _refreshIndicatorKey,	// key if you want to add
      onRefresh: _handleRefresh,
      showChildOpacityTransition: true,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              _apiHasData
                  ? Card(
                      child: SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              const Expanded(
                                  flex: 1,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/3d-daily-planner-calendar-pencil-alarm-clock.png'))),
                              Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      AutoSizeText(
                                        "Total Assigned tasks",
                                        style: GoogleFonts.aBeeZee(fontSize: 20),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      AutoSizeText("$_apiHasDataCount",
                                          style: GoogleFonts.orbitron(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black87)),
                                      AutoSizeText("Details",
                                          style: GoogleFonts.aBeeZee(
                                              fontSize: 13,
                                              color: Colors.blueAccent)),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Card(
                      child: SizedBox(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: Shimmer.fromColors(
                          baseColor: Colors.black12,
                          highlightColor: Colors.black87,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                    ),
              // SizedBox(
              //   height: 250,
              //   width: MediaQuery.of(context).size.width,
              //   child: Padding(
              //     padding: const EdgeInsets.all(0.0),
              //     child: Row(
              //       children: [
              //         Expanded(
              //             flex: 1,
              //             child: Card(
              //               child: Padding(
              //                 padding: const EdgeInsets.all(15.0),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.center,
              //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                   children: [
              //                     const Image(
              //                         image: AssetImage(
              //                             'assets/images/Wavy_Tech-17_Single-04.png'),
              //                         fit: BoxFit.fitWidth),
              //                     const SizedBox(
              //                       height: 10,
              //                     ),
              //                     AutoSizeText(
              //                       "20 Hours",
              //                       style: GoogleFonts.abel(fontSize: 20),
              //                     ),
              //                     AutoSizeText(
              //                       "Total Hours Worked",
              //                       style: GoogleFonts.abel(fontSize: 13),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             )),
              //         Expanded(
              //             flex: 1,
              //             child: Card(
              //               child: Padding(
              //                 padding: const EdgeInsets.all(15.0),
              //                 child: Column(
              //                   children: [
              //                     const Image(
              //                       image: AssetImage(
              //                           'assets/images/3d-render-red-paper-clipboard-with-cross-mark.png'),
              //                       fit: BoxFit.cover,
              //                       height: 160,
              //                     ),
              //                     const SizedBox(
              //                       height: 10,
              //                     ),
              //                     AutoSizeText(
              //                       "10 Hours",
              //                       style: GoogleFonts.abel(fontSize: 20),
              //                     ),
              //                     AutoSizeText(
              //                       "Total Hours Rejected",
              //                       style: GoogleFonts.abel(fontSize: 13),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             )),
              //       ],
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text("Tasks", style: GoogleFonts.aBeeZee(fontSize: 22))),
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder(
                  future: allTasks,
                  builder: (context, dataSnapshot) {
                    List<Widget> children = <Widget>[];
                    print(dataSnapshot.hasData);
                    if (dataSnapshot.hasError) {
                      children = <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text('Error: ${dataSnapshot.error}'),
                        ),
                      ];
                    } else if (dataSnapshot.hasData) {
                      print(dataSnapshot.hasData);
                      for (var index = 0;
                          index < dataSnapshot.data!.data!.followUps!.length;
                          index++) {
                        print(
                            "${dataSnapshot.data!.data!.followUps![index].salesClientFname}");
                        children.add(Card(
                          color: dataSnapshot.data!.data!.followUps![index].accepted == 'yes' ? Colors.white70 : Colors.white,
                          child: SizedBox(
                              height: 260.0,
                              width: 350,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].salesClientFname}",
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 22,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w900)),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].salesAddress1}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].salesAddress2}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].salesCity}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].salesState}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].salesPinCode}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].commentsComment}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].createdAt}",
                                                style: GoogleFonts.changa(
                                                    fontSize: 12,
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].salesMobile}",
                                                style: GoogleFonts.changa(
                                                    fontSize: 12,
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.followUps![index].salesEmail}",
                                                style: GoogleFonts.changa(
                                                    fontSize: 12,
                                                    color: Colors.black54)),
                                          ],
                                        )),
                                    dataSnapshot.data!.data!.followUps![index].status == 'inprogress' ? Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  EasyLoading.show();
                                                  getLatAndLongitude(
                                                          "${dataSnapshot.data!.data!.followUps![index].salesAddress1}, ${dataSnapshot.data!.data!.followUps![index].salesAddress2}, ${dataSnapshot.data!.data!.followUps![index].salesCity}, ${dataSnapshot.data!.data!.followUps![index].salesState}, ${dataSnapshot.data!.data!.followUps![index].salesPinCode}")
                                                      .then((value) =>
                                                          _launchMapsUrl(
                                                              value[0].latitude,
                                                              value[0]
                                                                  .longitude));
                                                },
                                                child: Icon(
                                                  Icons.location_pin,
                                                  color: Colors.blue[400],
                                                )),
                                            AutoSizeText(
                                              "Open Maps",
                                              style:
                                                  GoogleFonts.abel(fontSize: 10),
                                            ),
                                            dataSnapshot
                                                        .data!
                                                        .data!
                                                        .followUps![index]
                                                        .accepted ==
                                                    'no'
                                                ? GestureDetector(
                                                    onTap: () {
                                                      EasyLoading.showInfo(
                                                          "Accepting task");
                                                      acceptTask(followup_id: dataSnapshot.data!.data!.followUps![index].id);
                                                    },
                                                    child: Icon(
                                                      Icons.check_box_outlined,
                                                      color: Colors.blue[400],
                                                    ),
                                                  )
                                                : Container(),
                                            dataSnapshot
                                                        .data!
                                                        .data!
                                                        .followUps![index]
                                                        .accepted ==
                                                    'no'
                                                ? AutoSizeText(
                                                    "Accept",
                                                    style: GoogleFonts.abel(
                                                        fontSize: 10),
                                                  )
                                                : Container(),
                                            dataSnapshot
                                                        .data!
                                                        .data!
                                                        .followUps![index]
                                                        .accepted ==
                                                    'yes'
                                                ? GestureDetector(
                                                    onTap: () {
                                                      rejectTask(followup_id : 1);
                                                      EasyLoading.showInfo(
                                                          "Rejecting task");
                                                    },
                                                    child: Icon(
                                                      Icons.crop_square_sharp,
                                                      color: Colors.blue[400],
                                                    ),
                                                  )
                                                : Container(),
                                            dataSnapshot
                                                        .data!
                                                        .data!
                                                        .followUps![index]
                                                        .accepted ==
                                                    'yes'
                                                ? AutoSizeText(
                                                    "Reject",
                                                    style: GoogleFonts.abel(
                                                        fontSize: 10),
                                                  )
                                                : Container(),
                                            GestureDetector(
                                              onTap: () {
                                                _selectDate(context)
                                                    .then((value) {
                                                  rescheduleAppointment(
                                                      value,
                                                      dataSnapshot
                                                          .data!
                                                          .data!
                                                          .followUps![index]
                                                          .salesId);
                                                  return value;
                                                });
                                              },
                                              child: Icon(
                                                Icons.calendar_month_sharp,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Reschedule",
                                              style:
                                                  GoogleFonts.abel(fontSize: 10),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                EasyLoading.show();
                                                _makePhoneCall(
                                                    'tel:${dataSnapshot.data!.data!.followUps![index].salesMobile}');
                                              },
                                              child: Icon(
                                                Icons.phone,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Call",
                                              style:
                                                  GoogleFonts.abel(fontSize: 10),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showCupertinoModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      StatefulBuilder(builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setState /*You can rename this!*/) {
                                                    return Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.85,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                                15.0),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              AutoSizeText(
                                                                "Add a job sheet",
                                                                style: GoogleFonts.abel(
                                                                    fontSize: 25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              AutoSizeText(
                                                                "${dataSnapshot.data!.data!.followUps![index].commentsComment}",
                                                                style: GoogleFonts.abel(
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _notesController,
                                                                maxLines: 10,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  border: OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                              color:
                                                                                  Colors.teal)),
                                                                  // hintText: 'Tell us about yourself',
                                                                  helperText:
                                                                      'Mention all the efforts made for the task',
                                                                  labelText:
                                                                      'Notes',
                                                                  // prefixIcon:
                                                                  //     Icon(
                                                                  //   Icons
                                                                  //       .note_alt_outlined,
                                                                  //   color: Colors
                                                                  //       .green,
                                                                  // ),
                                                                  // prefixText:
                                                                  //     ' ',
                                                                  // suffixText:
                                                                  //     'USD',
                                                                  // suffixStyle:
                                                                  //     TextStyle(
                                                                  //         color:
                                                                  //             Colors.green)
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              DropdownButton<
                                                                  String>(
                                                                hint:
                                                                    const AutoSizeText(
                                                                        "Status"),
                                                                value:
                                                                    dropdownValue,
                                                                isExpanded: true,
                                                                icon: const Icon(Icons
                                                                    .arrow_downward),
                                                                elevation: 16,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .teal),
                                                                underline:
                                                                    Container(
                                                                  height: 2,
                                                                  color:
                                                                      Colors.teal,
                                                                ),
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  // This is called when the user selects an item.
                                                                  setState(() {
                                                                    dropdownValue =
                                                                        value!;
                                                                  });
                                                                },
                                                                items: list.map<
                                                                    DropdownMenuItem<
                                                                        String>>((String
                                                                    value) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value: value,
                                                                    child: Text(
                                                                        value),
                                                                  );
                                                                }).toList(),
                                                              ),
                                                              _photoCaptured ==
                                                                      false
                                                                  ? IconButton(
                                                                      iconSize:
                                                                          100,
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .image,
                                                                        size: 45,
                                                                      ),
                                                                      // the method which is called
                                                                      // when button is pressed
                                                                      onPressed:
                                                                          () async {
                                                                        print(
                                                                            "camera pressed");
                                                                        // Pick an image.
                                                                        // final XFile? image =
                                                                        //     await picker.pickImage(
                                                                        //         source: ImageSource
                                                                        //             .gallery);
                                                                        // Capture a photo.
                                                                        photo = await picker
                                                                            .pickImage(
                                                                                source: ImageSource.camera)
                                                                            .then((value) {
                                                                          setState(
                                                                              () {
                                                                            _photoCaptured =
                                                                                true;
                                                                          });
                                                                          return value;
                                                                        });
                                                                      },
                                                                    )
                                                                  : Container(),
                                                              _photoCaptured ==
                                                                      false
                                                                  ? AutoSizeText(
                                                                      "Add image",
                                                                      style: GoogleFonts.abel(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    )
                                                                  : Container(),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              _photoCaptured
                                                                  ? Stack(
                                                                      children: [
                                                                        ClipRRect(
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(25)),
                                                                          child: Image.file(
                                                                              File(photo!.path)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : Container(),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              !_videoCaptured ? IconButton(
                                                                iconSize: 100,
                                                                icon: const Icon(
                                                                  Icons
                                                                      .video_camera_back_outlined,
                                                                  size: 45,
                                                                ),
                                                                // the method which is called
                                                                // when button is pressed
                                                                onPressed: () {
                                                                  setState(
                                                                    () async {
                                                                      // Capture a video.
                                                                      cameraVideo = await picker
                                                                          .pickVideo(
                                                                              source: ImageSource
                                                                                  .camera)
                                                                          .then(
                                                                              (value) {
                                                                        setState(
                                                                            () {
                                                                          _controller = VideoPlayerController.file(File(value!
                                                                              .path))
                                                                            ..initialize()
                                                                                .then((_) {
                                                                              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                              setState(() {
                                                                                _videoCaptured = true;
                                                                                _controller.play();
                                                                              });
                                                                            });
                                                                        });
                                                                        return value;
                                                                      });
                                                                    },
                                                                  );
                                                                },
                                                              ) : Container(),
                                                              !_videoCaptured ? AutoSizeText(
                                                                "Add video",
                                                                style: GoogleFonts.abel(
                                                                    fontSize: 15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ) : Container(),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              _videoCaptured &&
                                                                      _controller
                                                                          .value
                                                                          .isInitialized
                                                                  ? AspectRatio(
                                                                      aspectRatio:
                                                                          _controller
                                                                              .value
                                                                              .aspectRatio,
                                                                      child: VideoPlayer(
                                                                          _controller),
                                                                    )
                                                                  : Container(),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              const SizedBox(
                                                                height: 30,
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.75,
                                                                height: 40.0,
                                                                child:
                                                                    ElevatedButton
                                                                        .icon(
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.save,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  label: Text(
                                                                    "Save",
                                                                    style: GoogleFonts
                                                                        .aBeeZee(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                  onPressed: () {
                                                                    EasyLoading
                                                                        .show();
                                                                    print(photo
                                                                        ?.path);
                                                                    print(cameraVideo
                                                                        ?.path);
                                                                    print(
                                                                        _notesController
                                                                            .text);
                                                                    print(
                                                                        dropdownValue);
                                                                    _saveJobSheet(
                                                                      job_id: dataSnapshot.data!.data!.followUps![index].commentsJobId,
                                                                      comment_id: dataSnapshot.data!.data!.followUps![index].commentId,
                                                                      comment_notes: _notesController.text,
                                                                      status: dropdownValue.toLowerCase(),
                                                                      user_id: 1,
                                                                      photo: photo,
                                                                      video: cameraVideo
                                                                    );
                                                                    EasyLoading
                                                                        .dismiss();

                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              32.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                );
                                              },
                                              child: Icon(
                                                Icons.note_add_outlined,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Add Note",
                                              style:
                                                  GoogleFonts.abel(fontSize: 10),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                EasyLoading.showToast("Feature coming soon, meanwhile you can add it by logging in our web version",
                                                );
                                              },
                                              child: Icon(
                                                Icons.currency_pound,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Add Invoice",
                                              style:
                                              GoogleFonts.abel(fontSize: 10),
                                            ),
                                          ],
                                        )) : Container()
                                  ],
                                ),
                              )),
                        ));
                        // return  Card(
                        //   child: SizedBox(
                        //       height: 250.0,
                        //       width: 350,
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(15.0),
                        //         child: Row(
                        //           children: [
                        //             Expanded(flex:4,
                        //                 child: Column(
                        //                   mainAxisAlignment: MainAxisAlignment.start,
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text("${dataSnapshot.data!.data!.followUps![index].salesClientFname}", style: GoogleFonts.aBeeZee(fontSize: 22, color: Colors.black54, fontWeight: FontWeight.w900)),
                        //                     Text("#443/Q Hayward University", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("Gate Number 67, Howard Campus", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("London", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("Bridgestone", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("900100", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     const SizedBox(
                        //                       height: 20,
                        //                     ),
                        //                     Text("Issue .............................",
                        //                         style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("Issue description .............................",
                        //                         style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     const SizedBox(height: 30,),
                        //                     Text("10 May 2023 - 10:20",
                        //                         style: GoogleFonts.changa(fontSize: 12, color: Colors.black54)),
                        //                   ],
                        //                 )),
                        //             Expanded(flex: 1,
                        //                 child: Column(
                        //                   children: [
                        //                     Icon(Icons.location_pin, color: Colors.blue[400],),
                        //                     AutoSizeText("Open Maps", style: GoogleFonts.abel(fontSize: 10),),
                        //                     Icon(Icons.check_box_outlined, color: Colors.blue[400],),
                        //                     AutoSizeText("Accept", style: GoogleFonts.abel(fontSize: 10),),
                        //                     Icon(Icons.crop_square_sharp, color: Colors.blue[400],),
                        //                     AutoSizeText("Reject", style: GoogleFonts.abel(fontSize: 10),),
                        //                     Icon(Icons.calendar_month_sharp, color: Colors.blue[400],),
                        //                     AutoSizeText("Reschedule", style: GoogleFonts.abel(fontSize: 10),),
                        //                   ],
                        //                 ))
                        //
                        //
                        //           ],
                        //         ),
                        //       )),
                        // );
                      }
                      for (var index = 0;
                      index < dataSnapshot.data!.data!.appointmentsFollowUps!.length;
                      index++) {
                        print(
                            "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsClientFname}");
                        children.add(Card(
                          color: dataSnapshot.data!.data!.appointmentsFollowUps![index].followUpsAccepted == 'yes' ? Colors.white70 : Colors.white,
                          child: SizedBox(
                              height: 260.0,
                              width: 350,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsClientFname}",
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 22,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w900)),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsAddress1}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsAddress2}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsCity}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsState}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsPinCode}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].commentsComment}",
                                                style: GoogleFonts.aBeeZee(
                                                    color: Colors.black54)),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsCreatedAt}",
                                                style: GoogleFonts.changa(
                                                    fontSize: 12,
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsMobile}",
                                                style: GoogleFonts.changa(
                                                    fontSize: 12,
                                                    color: Colors.black54)),
                                            Text(
                                                "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsEmail}",
                                                style: GoogleFonts.changa(
                                                    fontSize: 12,
                                                    color: Colors.black54)),
                                          ],
                                        )),
                                    dataSnapshot.data!.data!.appointmentsFollowUps![index].followUpsStatus == 'inprogress' ? Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  EasyLoading.show();
                                                  getLatAndLongitude(
                                                      "${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsAddress1}, ${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsAddress2}, ${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsCity}, ${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsState}, ${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsPinCode}")
                                                      .then((value) =>
                                                      _launchMapsUrl(
                                                          value[0].latitude,
                                                          value[0]
                                                              .longitude));
                                                },
                                                child: Icon(
                                                  Icons.location_pin,
                                                  color: Colors.blue[400],
                                                )),
                                            AutoSizeText(
                                              "Open Maps",
                                              style:
                                              GoogleFonts.abel(fontSize: 10),
                                            ),
                                            dataSnapshot
                                                .data!
                                                .data!
                                                .followUps![index]
                                                .accepted ==
                                                'no'
                                                ? GestureDetector(
                                              onTap: () {
                                                EasyLoading.showInfo(
                                                    "Accepting task");
                                                acceptTask(followup_id: dataSnapshot.data!.data!.appointmentsFollowUps![index].id);
                                              },
                                              child: Icon(
                                                Icons.check_box_outlined,
                                                color: Colors.blue[400],
                                              ),
                                            )
                                                : Container(),
                                            dataSnapshot
                                                .data!
                                                .data!
                                                .appointmentsFollowUps![index]
                                                .followUpsAccepted ==
                                                'no'
                                                ? AutoSizeText(
                                              "Accept",
                                              style: GoogleFonts.abel(
                                                  fontSize: 10),
                                            )
                                                : Container(),
                                            dataSnapshot
                                                .data!
                                                .data!
                                                .appointmentsFollowUps![index]
                                                .followUpsAccepted ==
                                                'yes'
                                                ? GestureDetector(
                                              onTap: () {
                                                rejectTask(followup_id : 1);
                                                EasyLoading.showInfo(
                                                    "Rejecting task");
                                              },
                                              child: Icon(
                                                Icons.crop_square_sharp,
                                                color: Colors.blue[400],
                                              ),
                                            )
                                                : Container(),
                                            dataSnapshot
                                                .data!
                                                .data!
                                                .appointmentsFollowUps![index]
                                                .followUpsAccepted ==
                                                'yes'
                                                ? AutoSizeText(
                                              "Reject",
                                              style: GoogleFonts.abel(
                                                  fontSize: 10),
                                            )
                                                : Container(),
                                            GestureDetector(
                                              onTap: () {
                                                _selectDate(context)
                                                    .then((value) {
                                                  rescheduleAppointment(
                                                      value,
                                                      dataSnapshot
                                                          .data!
                                                          .data!
                                                          .appointmentsFollowUps![index]
                                                          .commentsSalesId);
                                                  return value;
                                                });
                                              },
                                              child: Icon(
                                                Icons.calendar_month_sharp,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Reschedule",
                                              style:
                                              GoogleFonts.abel(fontSize: 10),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                EasyLoading.show();
                                                _makePhoneCall(
                                                    'tel:${dataSnapshot.data!.data!.appointmentsFollowUps![index].appointmentsMobile}');
                                              },
                                              child: Icon(
                                                Icons.phone,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Call",
                                              style:
                                              GoogleFonts.abel(fontSize: 10),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showCupertinoModalBottomSheet(
                                                  context: context,
                                                  builder: (context) =>
                                                      StatefulBuilder(builder:
                                                          (BuildContext context,
                                                          StateSetter
                                                          setState /*You can rename this!*/) {
                                                        return Container(
                                                          height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                              0.85,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(
                                                                15.0),
                                                            child:
                                                            SingleChildScrollView(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  AutoSizeText(
                                                                    "Add a job sheet",
                                                                    style: GoogleFonts.abel(
                                                                        fontSize: 25,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  AutoSizeText(
                                                                    "${dataSnapshot.data!.data!.appointmentsFollowUps![index].commentsComment}",
                                                                    style: GoogleFonts.abel(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                    _notesController,
                                                                    maxLines: 10,
                                                                    decoration:
                                                                    const InputDecoration(
                                                                      border: OutlineInputBorder(
                                                                          borderSide:
                                                                          BorderSide(
                                                                              color:
                                                                              Colors.teal)),
                                                                      // hintText: 'Tell us about yourself',
                                                                      helperText:
                                                                      'Mention all the efforts made for the task',
                                                                      labelText:
                                                                      'Notes',
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  DropdownButton<
                                                                      String>(
                                                                    hint:
                                                                    const AutoSizeText(
                                                                        "Status"),
                                                                    value:
                                                                    dropdownValue,
                                                                    isExpanded: true,
                                                                    icon: const Icon(Icons
                                                                        .arrow_downward),
                                                                    elevation: 16,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .teal),
                                                                    underline:
                                                                    Container(
                                                                      height: 2,
                                                                      color:
                                                                      Colors.teal,
                                                                    ),
                                                                    onChanged:
                                                                        (String?
                                                                    value) {
                                                                      // This is called when the user selects an item.
                                                                      setState(() {
                                                                        dropdownValue =
                                                                        value!;
                                                                      });
                                                                    },
                                                                    items: list.map<
                                                                        DropdownMenuItem<
                                                                            String>>((String
                                                                    value) {
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value: value,
                                                                        child: Text(
                                                                            value),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                  _photoCaptured ==
                                                                      false
                                                                      ? IconButton(
                                                                    iconSize:
                                                                    100,
                                                                    icon:
                                                                    const Icon(
                                                                      Icons
                                                                          .image,
                                                                      size: 45,
                                                                    ),
                                                                    // the method which is called
                                                                    // when button is pressed
                                                                    onPressed:
                                                                        () async {
                                                                      print(
                                                                          "camera pressed");
                                                                      // Pick an image.
                                                                      // final XFile? image =
                                                                      //     await picker.pickImage(
                                                                      //         source: ImageSource
                                                                      //             .gallery);
                                                                      // Capture a photo.
                                                                      photo = await picker
                                                                          .pickImage(
                                                                          source: ImageSource.camera)
                                                                          .then((value) {
                                                                        setState(
                                                                                () {
                                                                              _photoCaptured =
                                                                              true;
                                                                            });
                                                                        return value;
                                                                      });
                                                                    },
                                                                  )
                                                                      : Container(),
                                                                  _photoCaptured ==
                                                                      false
                                                                      ? AutoSizeText(
                                                                    "Add image",
                                                                    style: GoogleFonts.abel(
                                                                        fontSize:
                                                                        15,
                                                                        fontWeight:
                                                                        FontWeight.w500),
                                                                  )
                                                                      : Container(),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  _photoCaptured
                                                                      ? Stack(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                        const BorderRadius.all(Radius.circular(25)),
                                                                        child: Image.file(
                                                                            File(photo!.path)),
                                                                      ),
                                                                    ],
                                                                  )
                                                                      : Container(),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  !_videoCaptured ? IconButton(
                                                                    iconSize: 100,
                                                                    icon: const Icon(
                                                                      Icons
                                                                          .video_camera_back_outlined,
                                                                      size: 45,
                                                                    ),
                                                                    // the method which is called
                                                                    // when button is pressed
                                                                    onPressed: () {
                                                                      setState(
                                                                            () async {
                                                                          // Capture a video.
                                                                          cameraVideo = await picker
                                                                              .pickVideo(
                                                                              source: ImageSource
                                                                                  .camera)
                                                                              .then(
                                                                                  (value) {
                                                                                setState(
                                                                                        () {
                                                                                      _controller = VideoPlayerController.file(File(value!
                                                                                          .path))
                                                                                        ..initialize()
                                                                                            .then((_) {
                                                                                          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                                                                                          setState(() {
                                                                                            _videoCaptured = true;
                                                                                            _controller.play();
                                                                                          });
                                                                                        });
                                                                                    });
                                                                                return value;
                                                                              });
                                                                        },
                                                                      );
                                                                    },
                                                                  ) : Container(),
                                                                  !_videoCaptured ? AutoSizeText(
                                                                    "Add video",
                                                                    style: GoogleFonts.abel(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                  ) : Container(),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  _videoCaptured &&
                                                                      _controller
                                                                          .value
                                                                          .isInitialized
                                                                      ? AspectRatio(
                                                                    aspectRatio:
                                                                    _controller
                                                                        .value
                                                                        .aspectRatio,
                                                                    child: VideoPlayer(
                                                                        _controller),
                                                                  )
                                                                      : Container(),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 30,
                                                                  ),
                                                                  SizedBox(
                                                                    width: MediaQuery.of(
                                                                        context)
                                                                        .size
                                                                        .width *
                                                                        0.75,
                                                                    height: 40.0,
                                                                    child:
                                                                    ElevatedButton
                                                                        .icon(
                                                                      icon:
                                                                      const Icon(
                                                                        Icons.save,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      label: Text(
                                                                        "Save",
                                                                        style: GoogleFonts
                                                                            .aBeeZee(
                                                                            color:
                                                                            Colors.white),
                                                                      ),
                                                                      onPressed: () async {
                                                                        EasyLoading
                                                                            .show();
                                                                        print(photo
                                                                            ?.path);
                                                                        print(cameraVideo
                                                                            ?.path);
                                                                        print(
                                                                            _notesController
                                                                                .text);
                                                                        print(
                                                                            dropdownValue);
                                                                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                        var user = json.decode(prefs.getString('user')!) as Map;
                                                                        print("user");
                                                                        print(user);
                                                                        _saveJobSheet(
                                                                            job_id: dataSnapshot.data!.data!.appointmentsFollowUps![index].commentsJobId,
                                                                            comment_id: dataSnapshot.data!.data!.appointmentsFollowUps![index].followUpsCommentId,
                                                                            comment_notes: _notesController.text,
                                                                            status: dropdownValue.toLowerCase(),
                                                                            user_id: user['id'],
                                                                            photo: photo,
                                                                            video: cameraVideo
                                                                        );
                                                                        EasyLoading
                                                                            .dismiss();

                                                                        Navigator.of(context).pop();
                                                                        _notesController.text = "";
                                                                      },
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                        Colors
                                                                            .green,
                                                                        shape:
                                                                        RoundedRectangleBorder(
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              32.0),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                );
                                              },
                                              child: Icon(
                                                Icons.note_add_outlined,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Add Note",
                                              style:
                                              GoogleFonts.abel(fontSize: 10),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                EasyLoading.showToast("Feature coming soon, meanwhile you can add it by logging in our web version",
                                                );
                                              },
                                              child: Icon(
                                                Icons.currency_pound,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Add Invoice",
                                              style:
                                              GoogleFonts.abel(fontSize: 10),
                                            ),
                                          ],
                                        )) : Container()
                                  ],
                                ),
                              )),
                        ));
                        // return  Card(
                        //   child: SizedBox(
                        //       height: 250.0,
                        //       width: 350,
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(15.0),
                        //         child: Row(
                        //           children: [
                        //             Expanded(flex:4,
                        //                 child: Column(
                        //                   mainAxisAlignment: MainAxisAlignment.start,
                        //                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                   children: [
                        //                     Text("${dataSnapshot.data!.data!.followUps![index].salesClientFname}", style: GoogleFonts.aBeeZee(fontSize: 22, color: Colors.black54, fontWeight: FontWeight.w900)),
                        //                     Text("#443/Q Hayward University", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("Gate Number 67, Howard Campus", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("London", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("Bridgestone", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("900100", style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     const SizedBox(
                        //                       height: 20,
                        //                     ),
                        //                     Text("Issue .............................",
                        //                         style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     Text("Issue description .............................",
                        //                         style: GoogleFonts.aBeeZee(color: Colors.black54)),
                        //                     const SizedBox(height: 30,),
                        //                     Text("10 May 2023 - 10:20",
                        //                         style: GoogleFonts.changa(fontSize: 12, color: Colors.black54)),
                        //                   ],
                        //                 )),
                        //             Expanded(flex: 1,
                        //                 child: Column(
                        //                   children: [
                        //                     Icon(Icons.location_pin, color: Colors.blue[400],),
                        //                     AutoSizeText("Open Maps", style: GoogleFonts.abel(fontSize: 10),),
                        //                     Icon(Icons.check_box_outlined, color: Colors.blue[400],),
                        //                     AutoSizeText("Accept", style: GoogleFonts.abel(fontSize: 10),),
                        //                     Icon(Icons.crop_square_sharp, color: Colors.blue[400],),
                        //                     AutoSizeText("Reject", style: GoogleFonts.abel(fontSize: 10),),
                        //                     Icon(Icons.calendar_month_sharp, color: Colors.blue[400],),
                        //                     AutoSizeText("Reschedule", style: GoogleFonts.abel(fontSize: 10),),
                        //                   ],
                        //                 ))
                        //
                        //
                        //           ],
                        //         ),
                        //       )),
                        // );
                      }
                    } else {
                      children = const <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Awaiting result...'),
                        ),
                      ];
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
