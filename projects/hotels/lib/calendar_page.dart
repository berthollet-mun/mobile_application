import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotels/main.dart';
import 'package:table_calendar/table_calendar.dart';

const dGreen = Color(0xFF54D3C2);

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2015),
                lastDay: DateTime(2030),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                rangeSelectionMode: _rangeSelectionMode,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: d_green),
                  rightChevronIcon: Icon(Icons.chevron_right, color: d_green),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.nunito(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  weekendStyle: GoogleFonts.nunito(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  todayDecoration: BoxDecoration(
                    color: d_green.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  rangeHighlightColor: dGreen.withOpacity(0.3),
                  rangeStartDecoration: BoxDecoration(
                    color: dGreen,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: dGreen,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.black54),
                  defaultTextStyle: TextStyle(color: Colors.black87),
                ),
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    _rangeStart = start;
                    _rangeEnd = end;
                    _focusedDay = focusedDay;
                    _rangeSelectionMode = RangeSelectionMode.toggledOn;
                  });
                },

                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            SizedBox(height: 20),

            if (_rangeStart != null && _rangeEnd != null)
              Text(
                "Sélection : ${_rangeStart!.day}/${_rangeStart!.month} - ${_rangeEnd!.day}/${_rangeEnd!.month}",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: dGreen,
                ),
              ),
          ],
        ),
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
        'calendar',
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontWeight: FontWeight.w800,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
