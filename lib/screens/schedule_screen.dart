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

  // Controllers for the booking form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
          labelStyle: TextStyle(fontSize: 16),
        ),
        backgroundColor: Color(0xFFf8f9fa), // Light background for the AppBar
        elevation: 4,
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
                  '${appointment['name']}',
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
                        'Doctor: ${appointment['doctorName']}\n',
                        // 'Problem: ${appointment['problem']}',
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
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
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
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          final timeSlot = '${index + 9}:00 AM';
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimeSlot = timeSlot;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: _selectedTimeSlot == timeSlot ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                timeSlot,
                style: TextStyle(
                  color: _selectedTimeSlot == timeSlot ? Colors.white : Colors.black,
                  fontSize: 16,
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
      builder: (context) => AlertDialog(
        title: Text('Book Appointment'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_ageController, 'Age'),
              _buildTextField(_genderController, 'Gender'),
              _buildTextField(_problemController, 'Problem'),
              _buildTextField(_descriptionController, 'Description'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitAppointment();
            },
            child: Text('Submit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _submitAppointment() {
    final name = _nameController.text;
    final age = _ageController.text;
    final gender = _genderController.text;
    final problem = _problemController.text;
    final description = _descriptionController.text;

    FirebaseFirestore.instance.collection('appointments').add({
      'name': name,
      'age': age,
      'gender': gender,
      'date': _selectedDay.toIso8601String(),
      'timeSlot': _selectedTimeSlot,
      'doctorId': _selectedDoctorId,
      'doctorName': _selectedDoctorName,
      'problem': problem,
      'description': description,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully')),
      );
      setState(() {
        _nameController.clear();
        _ageController.clear();
        _genderController.clear();
        _problemController.clear();
        _descriptionController.clear();
        _selectedDay = DateTime.now();
        _selectedTimeSlot = null;
        _selectedDoctorId = null;
        _selectedDoctorName = null;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book appointment: $error')),
      );
    });
  }

  void _showSelectDoctorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select a doctor first')),
    );
  }
}
