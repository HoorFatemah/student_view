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
  late CalendarController _calendarController;
  CalendarView _calendarView = CalendarView.day;

  List<DateTime> _startTimes = [
    DateTime(2023, 5, 12, 9, 0, 0),
    DateTime(2023, 5, 12, 11, 0, 0),
    DateTime(2023, 5, 12, 13, 0, 0),
    DateTime(2023, 5, 12, 15, 0, 0),
  ];

  List<DateTime> _endTimes = [
    DateTime(2023, 5, 12, 11, 0, 0),
    DateTime(2023, 5, 12, 13, 0, 0),
    DateTime(2023, 5, 12, 15, 0, 0),
    DateTime(2023, 5, 12, 17, 0, 0),
  ];

  List<String> _courses = [
    'Artificial Intelligence',
    'Data structure and algorithm',
    'Data Science',
    'Database',
  ];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    for (int i = 0; i < _startTimes.length; i++) {
      meetings.add(Meeting(
        _courses[i],
        _startTimes[i],
        _endTimes[i],
        Color.fromARGB(255, i * 50, 255 - i * 50, 0),
        false,
      ));
    }
    return meetings;
  }

  void _onPopupMenuItemSelected(CalendarView value) {
    setState(() {
      _calendarView = value;
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
      body: SfCalendar(
        view: _calendarView,
        controller: _calendarController,
        dataSource: MeetingDataSource(_getDataSource()),
        initialDisplayDate: DateTime.now(),
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
