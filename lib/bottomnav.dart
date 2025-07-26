import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectflutter/Booking/bookingpage.dart';
import 'package:projectflutter/Wishlist/favoritepage.dart';
import 'package:projectflutter/home.dart';
import 'package:projectflutter/Explore/search.dart';

class Btn extends StatefulWidget {
  const Btn({super.key});

  @override
  State<Btn> createState() => _BtnState();
}

class _BtnState extends State<Btn> {
  int selectedIndex = 0;

  final List pages = [
    Fst(),
    Ser(),
    Fag(),
    Book(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.search_outlined,
    Icons.favorite_border,
    Icons.event,
  ];

  final List<String> _labels = ['Home', 'Search', 'Favourite', 'Bookings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            bool isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onItemTapped(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.tealAccent.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? _getActiveIcon(_icons[index]) : _icons[index],
                      color: isSelected ? Colors.teal : Colors.grey[600],
                      size: 26,
                    ),
                    SizedBox(height: 4),
                    Text(
                      _labels[index],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? Colors.teal : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }


  IconData _getActiveIcon(IconData icon) {
    switch (icon) {
      case Icons.home_outlined:
        return Icons.home;
      case Icons.search_outlined:
        return Icons.search;
      case Icons.favorite_border:
        return Icons.favorite;
      case Icons.event:
        return Icons.event_note;
      default:
        return icon;
    }
  }
}
