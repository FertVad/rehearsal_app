import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/core/utils/localization_helper.dart';
import 'package:rehearsal_app/l10n/app.dart';

class RehearsalCreatePage extends ConsumerStatefulWidget {
  const RehearsalCreatePage({
    super.key,
    this.selectedDate,
  });

  final DateTime? selectedDate;

  @override
  ConsumerState<RehearsalCreatePage> createState() => _RehearsalCreatePageState();
}

class _RehearsalCreatePageState extends ConsumerState<RehearsalCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _placeController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2);
  
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
    }
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
        title: Text(context.l10n.rehearsalCreate),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveRehearsal,
            child: _isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.save),
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
                  // Date Selection
                  Text(
                    context.l10n.dateTime,
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
                      subtitle: Text(context.l10n.rehearsalDate),
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
                            subtitle: Text(context.l10n.startTime),
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
                            subtitle: Text(context.l10n.endTime),
                            onTap: () => _selectTime(isStart: false),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Location
                  Text(
                    context.l10n.location,
                    style: AppTypography.headingMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _placeController,
                    decoration: InputDecoration(
                      labelText: context.l10n.rehearsalLocation,
                      hintText: context.l10n.locationHint,
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return context.l10n.locationRequired;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Notes
                  Text(
                    context.l10n.notes,
                    style: AppTypography.headingMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: context.l10n.additionalNotes,
                      hintText: context.l10n.notesHint,
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
    return LocalizationHelper.formatDate(context, date);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
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

  Future<void> _saveRehearsal() async {
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
        _error = context.l10n.endTimeError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final rehearsalsRepo = ref.read(rehearsalsRepositoryProvider);
      final rehearsalId = 'rehearsal_${DateTime.now().millisecondsSinceEpoch}';
      
      await rehearsalsRepo.create(
        id: rehearsalId,
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
        _error = 'Failed to create rehearsal: $e';
        _isLoading = false;
      });
    }
  }
}