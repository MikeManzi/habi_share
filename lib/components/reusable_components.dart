import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

// Custom AppBar Component
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onClosePressed;
  final bool showBackButton;
  final bool showCloseButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.onClosePressed,
    this.showBackButton = true,
    this.showCloseButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              )
              : null,
      actions: [
        if (showCloseButton)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black54),
            onPressed: onClosePressed ?? () => Navigator.of(context).pop(),
          ),
      ],
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Logo Component
class HabiShareLogo extends StatelessWidget {
  final double iconSize;
  final double textSize;

  const HabiShareLogo({Key? key, this.iconSize = 24, this.textSize = 18})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: const BoxDecoration(
            color: AppColors.primaryPurple,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.home, color: Colors.white, size: iconSize * 0.67),
        ),
        const SizedBox(width: 8),
        Text(
          'HabiShare',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryPurple,
          ),
        ),
      ],
    );
  }
}

// Custom Button Component
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final bool isEnabled;
  final double height;
  final double borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor = AppColors.primaryPurple,
    this.textColor = Colors.white,
    this.isOutlined = false,
    this.isEnabled = true,
    this.height = 48,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : backgroundColor,
          foregroundColor: isOutlined ? backgroundColor : textColor,
          elevation: 0,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side:
                isOutlined
                    ? BorderSide(color: backgroundColor, width: 1)
                    : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color:
                isEnabled
                    ? (isOutlined ? backgroundColor : textColor)
                    : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

// Time Slot Component
class TimeSlot extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isEnabled;

  const TimeSlot({
    Key? key,
    required this.time,
    required this.isSelected,
    required this.onTap,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 48,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isEnabled
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              color: isEnabled ? Colors.white : Colors.white.withOpacity(0.4),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// Calendar Day Component
class CalendarDay extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isCurrentMonth;
  final bool isToday;
  final VoidCallback? onTap;

  const CalendarDay({
    Key? key,
    required this.day,
    required this.isSelected,
    required this.isCurrentMonth,
    this.isToday = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isCurrentMonth) {
      return Container();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border:
              isToday && !isSelected
                  ? Border.all(color: Colors.white.withOpacity(0.5), width: 1)
                  : null,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              color: isSelected ? const Color(0xFF8B4A6B) : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// Loading Component
class LoadingSpinner extends StatelessWidget {
  final Color color;
  final double size;

  const LoadingSpinner({
    Key? key,
    this.color = AppColors.primaryPurple,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: 2,
      ),
    );
  }
}

// Success Icon Component
class SuccessIcon extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const SuccessIcon({
    Key? key,
    this.size = 80,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.primaryPurple,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(Icons.check, color: iconColor, size: size * 0.5),
    );
  }
}

// Card Container Component
class CardContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const CardContainer({
    Key? key,
    required this.child,
    this.backgroundColor = AppColors.primaryPurple,
    this.borderRadius = 16,
    this.margin = const EdgeInsets.all(16),
    this.padding = const EdgeInsets.all(20),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}

// Section Title Component
class SectionTitle extends StatelessWidget {
  final String title;
  final Color textColor;
  final double fontSize;

  const SectionTitle({
    Key? key,
    required this.title,
    this.textColor = Colors.white,
    this.fontSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// Calendar Header Component
class CalendarHeader extends StatelessWidget {
  final DateTime currentMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const CalendarHeader({
    Key? key,
    required this.currentMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: const Icon(Icons.chevron_left, color: Colors.white),
        ),
        Text(
          '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: const Icon(Icons.chevron_right, color: Colors.white),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month - 1];
  }
}

// Week Days Header Component
class WeekDaysHeader extends StatelessWidget {
  const WeekDaysHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

// Appointment Details Component
class AppointmentDetails extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedTime;

  const AppointmentDetails({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Time: $selectedTime',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Empty State Component
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;

  const EmptyState({
    Key? key,
    required this.message,
    this.icon = Icons.event_busy,
    this.iconColor = Colors.white54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 48, color: iconColor),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Custom TextField Component
class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? suffixText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  const CustomTextField({
    Key? key,
    this.hintText,
    this.labelText,
    this.suffixText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        suffixText: suffixText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryPurple),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

// Custom Dropdown Component
class CustomDropdown<T> extends StatelessWidget {
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const CustomDropdown({
    Key? key,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryPurple),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}

// Custom Checkbox Component
class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final Function(bool?) onChanged;

  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          fillColor: MaterialStateProperty.resolveWith<Color>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white; // White background when checked
            }
            return Colors.transparent; // Transparent when unchecked
          }),
          checkColor: const Color(0xFF8A2851), // Burgundy checkmark
          side: const BorderSide(color: Colors.white, width: 2), // White border
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// Upload Button Component
class UploadButton extends StatelessWidget {
  final String text;
  final String? subtitle;
  final VoidCallback onPressed;
  final IconData? icon;

  const UploadButton({
    Key? key,
    required this.text,
    this.subtitle,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primaryPurple),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? Icons.upload_file, color: AppColors.primaryPurple),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(color: AppColors.primaryPurple),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
