import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/calendar_components.dart';

class ImprovedDayCell extends StatelessWidget {
  const ImprovedDayCell({
    super.key,
    required this.date,
    required this.isCurrentMonth,
    this.isToday = false,
    this.isSelected = false,
    this.hasEvents = false,
    this.eventCount = 0,
    this.availabilityStatus,
    this.onTap,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasEvents;
  final int eventCount;
  final AvailabilityStatus? availabilityStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Day ${date.day}',
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        child: Container(
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: _getBorder(),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
          ),
          child: Stack(
            children: [
              // Day number
              Center(
                child: Text(
                  '${date.day}',
                  style: _getTextStyle(),
                ),
              ),
              
              // Event indicator
              if (hasEvents)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.accentHotPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              
              // Availability status
              if (availabilityStatus != null)
                Positioned(
                  bottom: 4,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: StatusIndicator(status: availabilityStatus!),
                  ),
                ),
              
              // Today indicator
              if (isToday)
                Positioned(
                  bottom: 2,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return AppColors.primaryPurple.withValues(alpha: 0.2);
    }
    if (isToday) {
      return AppColors.primaryPurple.withValues(alpha: 0.1);
    }
    return Colors.transparent;
  }

  Border? _getBorder() {
    if (isSelected) {
      return Border.all(
        color: AppColors.primaryPurple,
        width: 2,
      );
    }
    if (isToday) {
      return Border.all(
        color: AppColors.primaryPurple.withValues(alpha: 0.5),
        width: 1,
      );
    }
    return null;
  }

  TextStyle _getTextStyle() {
    Color textColor;
    if (!isCurrentMonth) {
      textColor = AppColors.textTertiary;
    } else if (isSelected) {
      textColor = AppColors.primaryPurple;
    } else {
      textColor = AppColors.textPrimary;
    }

    return AppTypography.calendarDay.copyWith(
      color: textColor,
      fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
    );
  }
}
