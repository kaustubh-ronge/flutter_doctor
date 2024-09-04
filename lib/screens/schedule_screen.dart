import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/navbar.dart'; // Adjust this import if needed

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool _isWeekend = false;
  bool _dateSelected = false;
  String? _selectedTimeSlot;
  String? _selectedDoctorId;
  String? _selectedDoctorName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Appointments'),
            Tab(text: 'Book'),
            Tab(text: 'Doctor List'),
          ],
          indicatorColor: Color(0xFF005EB8),
          labelColor: Color(0xFF005EB8),
          unselectedLabelColor: Colors.black54,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _appointmentsTab(),
          _bookTab(),
          _doctorListTab(),
        ],
      ),
      bottomNavigationBar: NavBar(
        toggleTheme: () {},
        selectedIndex: 2, // Ensure the Schedule tab is highlighted
      ),
    );
  }

  Widget _appointmentsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('appointments').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final appointments = snapshot.data!.docs;
        if (appointments.isEmpty) {
          return Center(child: Text('No appointments yet.'));
        }
        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            return Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                title: Text(
                  'Name: ${appointment['name']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Date: ${appointment['date']}\n'
                        'Time Slot: ${appointment['timeSlot']}\n'
                        'Doctor: ${appointment['doctorName']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                trailing: Icon(Icons.event_note, color: Color(0xFF005EB8)),
              ),
            );
          },
        );
      },
    );
  }

  Widget _bookTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 20),
          if (_isWeekend)
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Weekend is not available, please select another date',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            _buildTimeSlots(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _dateSelected && !_isWeekend && _selectedTimeSlot != null && _selectedDoctorId != null
                ? () => _showBookingForm()
                : () => _showSelectDoctorMessage(),
            child: Text('Book Appointment'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFF005EB8),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorListTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('doctorlist').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final doctors = snapshot.data!.docs;
        if (doctors.isEmpty) {
          return Center(child: Text('No doctors available.'));
        }
        return ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            final doctorId = doctor.id;
            final doctorName = doctor['name'];
            final experience = doctor['experience'];
            final specialty = doctor['specialty'];
            final ratings = doctor['ratings'];

            return Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF005EB8),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  doctorName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Experience: $experience years\n'
                        'Specialty: $specialty\n'
                        'Ratings: $ratings',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedDoctorId = doctorId;
                    _selectedDoctorName = doctorName;
                  });
                  _tabController.animateTo(1); // Switch to "Book" tab
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.now().subtract(Duration(days: 365)),
        lastDay: DateTime.now().add(Duration(days: 365)),
        calendarFormat: _format,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _dateSelected = true;
            _isWeekend = selectedDay.weekday == 6 || selectedDay.weekday == 7;
          });
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Color(0xFF005EB8),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: Colors.white),
          selectedTextStyle: TextStyle(color: Colors.white),
          defaultDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          defaultTextStyle: TextStyle(color: Colors.black),
        ),
        onFormatChanged: (format) {
          setState(() {
            _format = format;
          });
        },
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Expanded(
      child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
      childAspectRatio: 1.5,
    ),
    itemCount: 8,
    itemBuilder: (context, index) {
    final timeSlot = '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}';
    return InkWell(
    onTap: () {
    setState(() {
    _selectedTimeSlot = timeSlot;
    });
    },
    child: Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: _selectedTimeSlot == timeSlot ? Colors.green : Color(0xFF005EB8),
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
    BoxShadow(
    color: Colors.black26,
    blurRadius: 6,
    spreadRadius: 2,
    ),
    ],
    ),
    alignment: Alignment.center,
    child: Text(
    timeSlot,
    style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),

    ),
    ),
    );
    },
      ),
    );
  }

  void _showBookingForm() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Doctor: $_selectedDoctorName'),
              Text('Date: ${_selectedDay.toLocal()}'.split(' ')[0]),
              Text('Time Slot: $_selectedTimeSlot'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Logic to save the appointment in Firestore
                _saveAppointment();
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showSelectDoctorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please select a doctor and a time slot.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _saveAppointment() {
    FirebaseFirestore.instance.collection('appointments').add({
      'doctorId': _selectedDoctorId,
      'doctorName': _selectedDoctorName,
      'date': '${_selectedDay.toLocal()}'.split(' ')[0],
      'timeSlot': _selectedTimeSlot,
      'userId': 'user123', // Replace with the current user's ID
      'name': 'John Doe', // Replace with the current user's name
    });
  }
}
