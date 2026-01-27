import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotels/calendar_page.dart';

void main() {
  runApp(MyApp());
}

const d_green = Color(0xFF54D3C2);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotesl Booking',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Column(children: [SearchSection(), HotelSection()]),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Explore",
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.grey[800], size: 20),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.favorite_border_outlined,
            color: Colors.grey[800],
            size: 20,
          ),
          onPressed: () {},
        ),

        IconButton(
          icon: Icon(Icons.place, color: Colors.grey[800], size: 20),
          onPressed: () {},
        ),
      ],
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.all(5)),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "London",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: d_green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(Icons.search, size: 20),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose date",
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "12 Dec - 22 Dec",
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Number of Rooms",
                      style: GoogleFonts.nunito(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "1 Rom 2 Adults",
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HotelSection extends StatelessWidget {
  final List hotelList = [
    {
      'title': 'Grand Royal Hotel',
      'place': 'Wevley, London',
      'distance': 2,
      'review': 36,
      'picture': 'assets/images/img1.jpg',
      'price': '180',
    },

    {
      'title': 'Hotel Ibis',
      'place': 'Wevley, London',
      'distance': 3,
      'review': 13,
      'picture': 'assets/images/img2.jpg',
      'price': '220',
    },

    {
      'title': 'Grand Mal Hotel',
      'place': 'Wevley, London',
      'distance': 76,
      'review': 88,
      'picture': 'assets/images/img3.jpg',
      'price': '400',
    },

    {
      'title': 'Hilton',
      'place': 'Wevley, London',
      'distance': 11,
      'review': 34,
      'picture': 'assets/images/img4.jpg',
      'price': '910',
    },

    {
      'title': 'Queen Hotel',
      'place': 'Wevley, London',
      'distance': 11,
      'review': 34,
      'picture': 'assets/images/img5.jpg',
      'price': '180',
    },
  ];

  HotelSection({super.key});  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '550 hotels founds',
                  style: GoogleFonts.nunito(color: Colors.black, fontSize: 15),
                ),

                Row(
                  children: [
                    Text(
                      'Filters',
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list_outlined,
                        color: d_green,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: hotelList.map((hotel) {
              return HotelCard(hotel);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  const HotelCard(this.hotelData, {super.key});
  final Map hotelData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 270,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              image: DecorationImage(
                image: AssetImage(hotelData['picture']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  right: -15,
                  child: MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    onPressed: () {},
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: d_green,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hotelData['title'],
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '\$' + hotelData['price'],
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hotelData['place'],
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.place, color: d_green, size: 14.0),
                    Text(
                      '${hotelData['distance']}Km to city',
                      style: GoogleFonts.nunito(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Text(
                  'per night',
                  style: GoogleFonts.nunito(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 15,
            margin: EdgeInsets.fromLTRB(10, 3, 10, 0),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star_rate, color: d_green, size: 14),
                    Icon(Icons.star_rate, color: d_green, size: 14),
                    Icon(Icons.star_rate, color: d_green, size: 14),
                    Icon(Icons.star_rate, color: d_green, size: 14),
                    Icon(Icons.star_border, color: d_green, size: 14),
                  ],
                ),
                SizedBox(width: 20),
                Text(
                  '${hotelData['review']} riviews',
                  style: GoogleFonts.nunito(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
