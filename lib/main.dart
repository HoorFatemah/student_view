import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SfCalendar _calendar;
  CalendarView _calendarView = CalendarView.day;

  @override
  void initState() {
    super.initState();
    _calendar = SfCalendar(
      view: _calendarView,
      showCurrentTimeIndicator: true,
      dataSource: MeetingDataSource(_getDataSource()),
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting('Makeup class of AI', startTime, endTime,
        Color.fromARGB(255, 15, 130, 134), false));
    return meetings;
  }

  void _onPopupMenuItemSelected(CalendarView view) {
    setState(() {
      _calendarView = view;
      _calendar = SfCalendar(
        view: _calendarView,
        showCurrentTimeIndicator: true,
        dataSource: MeetingDataSource(_getDataSource()),
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          PopupMenuButton<CalendarView>(
            onSelected: _onPopupMenuItemSelected,
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<CalendarView>>[
              PopupMenuItem<CalendarView>(
                value: CalendarView.week,
                child: const Text('Week View'),
              ),
              PopupMenuItem<CalendarView>(
                value: CalendarView.day,
                child: const Text('Day View'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: _calendar,
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
