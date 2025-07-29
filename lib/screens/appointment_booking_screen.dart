import 'package:flutter/material.dart';
import 'package:habi_share/utils/app_colors.dart';
import '../components/reusable_components.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  // Calendar state
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  // Time slot state
  String? _selectedTimeSlot;
  final List<String> _timeSlots = ['12:30', '13:00', '13:30', '14:00', '14:30', '15:00'];

  // Booking state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _selectTimeSlot(String time) {
    setState(() {
      _selectedTimeSlot = time;
    });
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + 1,
      );
    });
  }

  Future<void> _bookAppointment() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _nextPage();
  }

  void _backToListings() {
    Navigator.of(context).pop();
  }

  bool get _canProceedFromCalendar => _selectedDate != null;
  bool get _canProceedFromTimeSlot => _selectedTimeSlot != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Client book appointment',
        onBackPressed: _currentPage > 0 ? _previousPage : null,
        showBackButton: _currentPage > 0,
      ),
      body: Column(
        children: [
          // Logo
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: HabiShareLogo(),
          ),

          // Page Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Book appointment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Progress Indicator
          _buildProgressIndicator(),

          const SizedBox(height: 20),

          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCalendarPage(),
                _buildTimeSlotPage(),
                _buildConfirmationPage(),
                _buildSuccessPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: index <= _currentPage
                ? AppColors.primaryPurple
                : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildCalendarPage() {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Choose an appointment day'),
          const SizedBox(height: 20),

          // Calendar Header
          CalendarHeader(
            currentMonth: _currentMonth,
            onPreviousMonth: _previousMonth,
            onNextMonth: _nextMonth,
          ),

          const SizedBox(height: 16),

          // Week Days Header
          const WeekDaysHeader(),

          const SizedBox(height: 12),

          // Calendar Grid
          Expanded(child: _buildCalendarGrid()),

          const SizedBox(height: 20),

          // Next Button
          CustomButton(
            text: 'Next',
            onPressed: _canProceedFromCalendar ? _nextPage : null,
            isEnabled: _canProceedFromCalendar,
            backgroundColor: Colors.white,
            textColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;
    final today = DateTime.now();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 weeks
      itemBuilder: (context, index) {
        final dayNumber = index - startingWeekday + 1;
        final isCurrentMonth = dayNumber > 0 && dayNumber <= daysInMonth;

        if (!isCurrentMonth) {
          return const SizedBox();
        }

        final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
        final isSelected = _selectedDate.year == date.year &&
            _selectedDate.month == date.month &&
            _selectedDate.day == date.day;
        final isToday = today.year == date.year &&
            today.month == date.month &&
            today.day == date.day;

        return CalendarDay(
          day: dayNumber,
          isSelected: isSelected,
          isCurrentMonth: isCurrentMonth,
          isToday: isToday,
          onTap: () => _selectDate(date),
        );
      },
    );
  }

  Widget _buildTimeSlotPage() {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Choose a time-slot'),
          const SizedBox(height: 20),

          // Time slots
          Expanded(
            child: _timeSlots.isEmpty
                ? const EmptyState(
              message: 'No time slots available for selected date',
              icon: Icons.schedule,
            )
                : ListView.builder(
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                final time = _timeSlots[index];
                return TimeSlot(
                  time: time,
                  isSelected: _selectedTimeSlot == time,
                  onTap: () => _selectTimeSlot(time),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Next Button
          CustomButton(
            text: 'Next',
            onPressed: _canProceedFromTimeSlot ? _nextPage : null,
            isEnabled: _canProceedFromTimeSlot,
            backgroundColor: Colors.white,
            textColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationPage() {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Confirm your appointment'),
          const SizedBox(height: 20),

          // Appointment details
          AppointmentDetails(
            selectedDate: _selectedDate,
            selectedTime: _selectedTimeSlot ?? '',
          ),

          const SizedBox(height: 20),

          // Additional info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Please ensure you arrive 10 minutes early for your appointment. You will receive a confirmation email with detailed instructions.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),

          const Spacer(),

          // Confirm Button
          CustomButton(
            text: _isLoading ? 'Booking...' : 'Confirm Booking',
            onPressed: _isLoading ? null : _bookAppointment,
            isEnabled: !_isLoading,
            backgroundColor: Colors.white,
            textColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessPage() {
    return CardContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon
          const SuccessIcon(),

          const SizedBox(height: 24),

          const Text(
            'Your appointment has been booked successfully, details and guidelines will be sent to your email in a few.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Appointment summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Appointment Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Time: ${_selectedTimeSlot ?? ''}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Back to listings button
          CustomButton(
            text: 'Back to listings',
            onPressed: _backToListings,
            backgroundColor: Colors.white,
            textColor: AppColors.primaryPurple,
          ),
        ],
      ),
    );
  }
}