import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectflutter/Booking//payment.dart';

class Tpl extends StatefulWidget {

  final String documentId;

  const Tpl({super.key, required this.documentId});

  @override
  State<Tpl> createState() => _TplState();
}

class _TplState extends State<Tpl> {
  int selectedStageIndex = -1;
  int selectedPackageIndex = -1;
  DateTime? selectedDate;

  List<Map<String, dynamic>> stageList = [];
  List<Map<String, dynamic>> packageList = [];

  @override
  void initState() {
    super.initState();
    fetchFirestoreData();
  }

  Future<void> fetchFirestoreData() async {
    final doc = await FirebaseFirestore.instance
        .collection('pass')
        .doc(widget.documentId)
        .get();

    final data = doc.data();
    if (data == null) return;

    List<Map<String, dynamic>> stages = [];
    List<Map<String, dynamic>> packages = [];

    if (data['stageImages'] != null) {
      final List stageData = data['stageImages'];
      for (var stage in stageData) {
        stages.add({
          'url': stage['url'],
          'stageName': stage['stageName'],
        });
      }
    }

    if (data['packages'] != null) {
      final List packageData = data['packages'];
      for (var pack in packageData) {
        packages.add({
          'name': pack['name'],
          'price': pack['price'],
        });
      }
    }


    setState(() {
      stageList = stages;
      packageList = packages;
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Booking", style: GoogleFonts.poppins(fontSize: 22)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Stage Designs", style: GoogleFonts.poppins(fontSize: 18)),
            SizedBox(height: 10),
            SizedBox(
              height: 140,
              child: stageList.isEmpty
                  ? Center(child: Text("No stage images"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: stageList.length,
                      itemBuilder: (context, index) {
                        final stage = stageList[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedStageIndex = index);
                          },
                          child: Container(
                            width: 200,
                            margin: EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedStageIndex == index
                                    ? Colors.teal
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(stage['url'],
                                      fit: BoxFit.cover,
                                      width: double.infinity),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    color: Colors.black54,
                                    child: Text(stage['stageName'],
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 25),
            Text("Packages", style: GoogleFonts.poppins(fontSize: 18)),
            SizedBox(height: 10),
            packageList.isEmpty
                ? Text("No package data")
                : Column(
                    children: List.generate(packageList.length, (index) {
                      final pack = packageList[index];
                      bool selected = selectedPackageIndex == index;
                      return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: selected
                                  ? Colors.teal
                                  : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title:
                              Text(pack['name'], style: GoogleFonts.poppins()),
                          subtitle: Text("Price: ${pack['price']}",
                              style: GoogleFonts.poppins(fontSize: 13)),
                          tileColor: selected ? Colors.teal.shade50 : null,
                          onTap: () =>
                              setState(() => selectedPackageIndex = index),
                        ),
                      );
                    }),
                  ),
            SizedBox(height: 25),
            Text("Select Date", style: GoogleFonts.poppins(fontSize: 18)),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.teal),
                SizedBox(width: 8),
                Text(
                  selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "No date selected",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () => selectDate(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: Text("Pick Date"),
                )
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedStageIndex == -1 ||
                      selectedPackageIndex == -1 ||
                      selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Please select stage, package, and date")),
                    );
                    return;
                  }

                  final selectedStage = stageList[selectedStageIndex];
                  final selectedPackage = packageList[selectedPackageIndex];
                  final selectedDateFormatted =
                      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title:
                          Text("Confirm Booking", style: GoogleFonts.poppins()),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Stage: ${selectedStage['stageName']}",
                              style: GoogleFonts.poppins()),
                          SizedBox(height: 5),
                          Text(
                              "Package: ${selectedPackage['name']} (₹${selectedPackage['price']})",
                              style: GoogleFonts.poppins()),
                          SizedBox(height: 5),
                          Text("Date: $selectedDateFormatted",
                              style: GoogleFonts.poppins()),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancel",
                              style: GoogleFonts.poppins(color: Colors.grey)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal),
                          child: Text("Confirm",
                              style: GoogleFonts.poppins(color: Colors.white)),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Pay(
                                  stageName: selectedStage['stageName'],
                                  stageImageUrl: selectedStage['url'],
                                  packageName: selectedPackage['name'],
                                  packagePrice: selectedPackage['price'],
                                  selectedDate: selectedDateFormatted,
                                ),
                              ),
                            );


                          },
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade800,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                child: Text("BOOK",
                    style:
                        GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
