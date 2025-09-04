import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/db/app_database.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';

class RehearsalEditPage extends ConsumerStatefulWidget {
  const RehearsalEditPage({
    super.key,
    required this.rehearsal,
  });

  final Rehearsal rehearsal;

  @override
  ConsumerState<RehearsalEditPage> createState() => _RehearsalEditPageState();
}

class _RehearsalEditPageState extends ConsumerState<RehearsalEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _placeController = TextEditingController();
  final _noteController = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    
    final startTime = DateTime.fromMillisecondsSinceEpoch(widget.rehearsal.startsAtUtc, isUtc: true).toLocal();
    final endTime = DateTime.fromMillisecondsSinceEpoch(widget.rehearsal.endsAtUtc, isUtc: true).toLocal();
    
    _selectedDate = DateTime(startTime.year, startTime.month, startTime.day);
    _startTime = TimeOfDay.fromDateTime(startTime);
    _endTime = TimeOfDay.fromDateTime(endTime);
    
    _placeController.text = widget.rehearsal.place ?? '';
    _noteController.text = widget.rehearsal.note ?? '';
  }

  @override
  void dispose() {
    _placeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Rehearsal'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
          ),
        ],
      ),
      body: DashBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingLG,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Time Section
                  Text(
                    'Date & Time',
                    style: AppTypography.headingMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Date Picker
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.glassLightBase,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      border: Border.all(color: AppColors.glassLightStroke),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(_formatDate(_selectedDate)),
                      subtitle: const Text('Rehearsal date'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _selectDate,
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  // Time Pickers Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.glassLightBase,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                            border: Border.all(color: AppColors.glassLightStroke),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(_startTime.format(context)),
                            subtitle: const Text('Start time'),
                            onTap: () => _selectTime(isStart: true),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.glassLightBase,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                            border: Border.all(color: AppColors.glassLightStroke),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.access_time_filled),
                            title: Text(_endTime.format(context)),
                            subtitle: const Text('End time'),
                            onTap: () => _selectTime(isStart: false),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Location
                  Text(
                    'Location',
                    style: AppTypography.headingMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _placeController,
                    decoration: const InputDecoration(
                      labelText: 'Rehearsal location',
                      hintText: 'e.g., Main studio, Room 101',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Notes
                  Text(
                    'Notes',
                    style: AppTypography.headingMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Additional notes',
                      hintText: 'Optional notes about this rehearsal...',
                      prefixIcon: Icon(Icons.note),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Error Display
                  if (_error != null)
                    Container(
                      width: double.infinity,
                      padding: AppSpacing.paddingMD,
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.statusBusy.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: AppColors.statusBusy),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              _error!,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.statusBusy,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() => _error = null),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime({required bool isStart}) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
          // Auto-adjust end time if it's before start time
          if (_endTime.hour < time.hour || 
              (_endTime.hour == time.hour && _endTime.minute <= time.minute)) {
            _endTime = TimeOfDay(hour: (time.hour + 2) % 24, minute: time.minute);
          }
        } else {
          _endTime = time;
        }
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate time range
    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final endDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    if (endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
      setState(() {
        _error = 'End time must be after start time';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final rehearsalsRepo = ref.read(rehearsalsRepositoryProvider);
      
      await rehearsalsRepo.update(
        id: widget.rehearsal.id,
        startsAtUtc: startDateTime.toUtc().millisecondsSinceEpoch,
        endsAtUtc: endDateTime.toUtc().millisecondsSinceEpoch,
        place: _placeController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to update rehearsal: $e';
        _isLoading = false;
      });
    }
  }
}