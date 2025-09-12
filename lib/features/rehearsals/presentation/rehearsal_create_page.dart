import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:rehearsal_app/core/design_system/app_colors.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/features/dashboard/widgets/dash_background.dart';
import 'package:rehearsal_app/core/providers/repository_providers.dart';
import 'package:rehearsal_app/features/user/controller/user_provider.dart';
import 'package:rehearsal_app/domain/models/project.dart';
import 'package:rehearsal_app/domain/models/project_member.dart';
import 'package:rehearsal_app/domain/models/availability.dart';
import 'package:rehearsal_app/core/utils/localization_helper.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/l10n/app.dart';
import 'dart:convert';

class TimeSlot {
  final TimeOfDay start;
  final TimeOfDay end;
  final bool isOptimal;

  const TimeSlot({
    required this.start,
    required this.end,
    this.isOptimal = false,
  });

  String format(BuildContext context) {
    return '${start.format(context)} - ${end.format(context)}';
  }
  
  @override
  String toString() {
    // For cases without context, use 24-hour format
    return '${_formatTimeOfDay(start)} - ${_formatTimeOfDay(end)}';
  }
  
  static String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class RehearsalCreatePage extends ConsumerStatefulWidget {
  const RehearsalCreatePage({super.key, this.selectedDate});

  final DateTime? selectedDate;

  @override
  ConsumerState<RehearsalCreatePage> createState() =>
      _RehearsalCreatePageState();
}

class _RehearsalCreatePageState extends ConsumerState<RehearsalCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _placeController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(
    hour: TimeOfDay.now().hour + 2,
  );

  bool _isLoading = false;
  String? _error;

  List<Project> _projects = [];
  Project? _selectedProject;

  List<ProjectMember> _projectMembers = [];
  final Set<String> _selectedParticipants = {};
  final Map<String, Availability?> _participantAvailability = {};
  List<TimeSlot> _recommendedSlots = [];

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
    }
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      final projectsRepo = ref.read(projectsRepositoryProvider);
      final userId = ref.read(currentUserIdProvider);

      if (userId == null) return;

      final projects = await projectsRepo.listForUser(userId);
      setState(() {
        _projects = projects;
        // Auto-select if only one project
        if (projects.length == 1) {
          _selectedProject = projects.first;
          _loadProjectMembers(projects.first.id);
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load projects: $e';
      });
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
                  // Project Selection
                  Text(
                    'Project', // context.l10n.project
                    style: AppTypography.headingMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<Project>(
                    initialValue: _selectedProject,
                    decoration: InputDecoration(
                      labelText: 'Select Project', // context.l10n.selectProject
                      hintText: _projects.isEmpty
                          ? 'No projects available' // context.l10n.noProjectsAvailable
                          : 'Select Project', // context.l10n.selectProject
                      prefixIcon: Icon(Icons.folder),
                      border: OutlineInputBorder(),
                    ),
                    items: _projects
                        .map(
                          (project) => DropdownMenuItem<Project>(
                            value: project,
                            child: Text(project.name),
                          ),
                        )
                        .toList(),
                    onChanged: _projects.isEmpty
                        ? null
                        : (Project? value) {
                            setState(() {
                              _selectedProject = value;
                              _selectedParticipants.clear();
                              _participantAvailability.clear();
                              _recommendedSlots.clear();
                            });
                            if (value != null) {
                              _loadProjectMembers(value.id);
                            }
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a project'; // context.l10n.projectRequired
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppSpacing.xl),

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
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMD,
                            ),
                            border: Border.all(
                              color: AppColors.glassLightStroke,
                            ),
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
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusMD,
                            ),
                            border: Border.all(
                              color: AppColors.glassLightStroke,
                            ),
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

                  // Participants Selection
                  if (_selectedProject != null) ...[
                    Text(
                      'Participants / Участники',
                      style: AppTypography.headingMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    if (_projectMembers.isEmpty)
                      GlassCard(
                        child: Padding(
                          padding: AppSpacing.paddingMD,
                          child: Row(
                            children: [
                              Icon(Icons.people_outline, color: AppColors.textSecondary),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Loading participants...',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        children: _projectMembers.map((member) {
                          final isSelected = _selectedParticipants.contains(member.userId);
                          final availability = _participantAvailability[member.userId];
                          
                          return GlassCard(
                            child: CheckboxListTile(
                              value: isSelected,
                              onChanged: (bool? selected) {
                                setState(() {
                                  if (selected == true) {
                                    _selectedParticipants.add(member.userId);
                                  } else {
                                    _selectedParticipants.remove(member.userId);
                                  }
                                });
                                _updateRecommendedSlots();
                              },
                              title: Text(
                                member.userFullName ?? member.userEmail ?? 'User ${member.userId.substring(0, 8)}',
                                style: AppTypography.bodyMedium,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Role: ${member.role}',
                                    style: AppTypography.bodySmall,
                                  ),
                                  if (availability != null) ...[
                                    const SizedBox(height: 4),
                                    _buildAvailabilityIndicator(availability),
                                  ] else if (isSelected) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Loading availability...',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                    if (_recommendedSlots.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Recommended Time Slots / Рекомендуемые слоты',
                        style: AppTypography.titleSm,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: _recommendedSlots.map((slot) {
                          return GlassChip(
                            label: slot.toString(),
                            selected: slot.isOptimal,
                            onTap: () {
                              setState(() {
                                _startTime = slot.start;
                                _endTime = slot.end;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Notes
                  Text(context.l10n.notes, style: AppTypography.headingMedium),
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
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMD,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.statusBusy,
                          ),
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
      setState(() {
        _selectedDate = date;
        _participantAvailability.clear();
        _recommendedSlots.clear();
      });
      // Reload availability for currently selected participants
      if (_selectedParticipants.isNotEmpty) {
        _updateRecommendedSlots();
      }
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
            _endTime = TimeOfDay(
              hour: (time.hour + 2) % 24,
              minute: time.minute,
            );
          }
        } else {
          _endTime = time;
        }
      });
    }
  }

  Future<void> _loadProjectMembers(String projectId) async {
    try {
      final membersRepo = ref.read(projectMembersRepositoryProvider);
      final members = await membersRepo.getProjectMembers(projectId);
      
      setState(() {
        _projectMembers = members;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load project members: $e';
      });
    }
  }

  Future<void> _loadAvailabilityForParticipant(String userId) async {
    if (_participantAvailability.containsKey(userId)) return;
    
    try {
      final availabilityRepo = ref.read(availabilityRepositoryProvider);
      final dateUtc = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)
          .toUtc().millisecondsSinceEpoch;
      
      final availability = await availabilityRepo.getForUserOnDateUtc(
        userId: userId,
        dateUtc00: dateUtc,
      );
      
      setState(() {
        _participantAvailability[userId] = availability;
      });
      
      _updateRecommendedSlots();
    } catch (e) {
      setState(() {
        _participantAvailability[userId] = null;
      });
    }
  }

  Widget _buildAvailabilityIndicator(Availability availability) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (availability.status) {
      case 'free':
        statusColor = AppColors.statusFree;
        statusText = 'Available';
        statusIcon = Icons.check_circle;
        break;
      case 'busy':
        statusColor = AppColors.statusBusy;
        statusText = 'Busy';
        statusIcon = Icons.cancel;
        break;
      case 'partial':
        statusColor = AppColors.statusPartial;
        statusText = 'Partially Available';
        statusIcon = Icons.access_time;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusText = 'Unknown';
        statusIcon = Icons.help_outline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(statusIcon, size: 16, color: statusColor),
        const SizedBox(width: 4),
        Text(
          statusText,
          style: AppTypography.bodySmall.copyWith(color: statusColor),
        ),
      ],
    );
  }

  void _updateRecommendedSlots() {
    if (_selectedParticipants.isEmpty) {
      setState(() {
        _recommendedSlots = [];
      });
      return;
    }

    // Load availability for selected participants
    for (final userId in _selectedParticipants) {
      _loadAvailabilityForParticipant(userId);
    }

    // Calculate recommended slots based on all participants' availability
    _calculateRecommendedSlots();
  }

  void _calculateRecommendedSlots() {
    final List<TimeSlot> slots = [];
    
    // Get all participants' availability
    final List<Availability?> participantAvailabilities = _selectedParticipants
        .map((userId) => _participantAvailability[userId])
        .toList();
    
    // If not all participants have loaded availability, return
    if (participantAvailabilities.any((av) => av == null)) {
      return;
    }
    
    // Find common free time slots
    final List<List<Map<String, int>>> allIntervals = [];
    
    for (final availability in participantAvailabilities) {
      if (availability == null) continue;
      
      List<Map<String, int>> intervals = [];
      
      if (availability.status == 'free') {
        // Full day available
        intervals.add({'start': 9 * 60, 'end': 18 * 60}); // 9 AM to 6 PM
      } else if (availability.status == 'partial' && availability.intervalsJson != null) {
        try {
          final List<dynamic> jsonIntervals = jsonDecode(availability.intervalsJson!);
          intervals = jsonIntervals.map((interval) => {
            'start': interval['start'] as int,
            'end': interval['end'] as int,
          }).toList();
        } catch (e) {
          // Skip this participant if JSON is invalid
          continue;
        }
      }
      // For 'busy' status, intervals remain empty (no available time)
      
      allIntervals.add(intervals);
    }
    
    // Find intersections of all intervals
    if (allIntervals.isNotEmpty) {
      final commonSlots = _findCommonTimeSlots(allIntervals);
      
      for (final slot in commonSlots) {
        final startMinutes = slot['start']!;
        final endMinutes = slot['end']!;
        
        // Convert minutes to TimeOfDay
        final startTime = TimeOfDay(
          hour: startMinutes ~/ 60,
          minute: startMinutes % 60,
        );
        final endTime = TimeOfDay(
          hour: endMinutes ~/ 60,
          minute: endMinutes % 60,
        );
        
        // Only add slots that are at least 1 hour long
        if (endMinutes - startMinutes >= 60) {
          final isOptimal = endMinutes - startMinutes >= 120; // 2+ hours is optimal
          slots.add(TimeSlot(
            start: startTime,
            end: endTime,
            isOptimal: isOptimal,
          ));
        }
      }
    }
    
    setState(() {
      _recommendedSlots = slots;
    });
  }

  List<Map<String, int>> _findCommonTimeSlots(List<List<Map<String, int>>> allIntervals) {
    if (allIntervals.isEmpty) return [];
    
    // Start with the first participant's intervals
    List<Map<String, int>> common = List.from(allIntervals.first);
    
    // Intersect with each subsequent participant's intervals
    for (int i = 1; i < allIntervals.length; i++) {
      common = _intersectIntervals(common, allIntervals[i]);
    }
    
    return common;
  }

  List<Map<String, int>> _intersectIntervals(
    List<Map<String, int>> intervals1,
    List<Map<String, int>> intervals2,
  ) {
    final List<Map<String, int>> result = [];
    
    for (final interval1 in intervals1) {
      for (final interval2 in intervals2) {
        final start = [interval1['start']!, interval2['start']!].reduce((a, b) => a > b ? a : b);
        final end = [interval1['end']!, interval2['end']!].reduce((a, b) => a < b ? a : b);
        
        if (start < end) {
          result.add({'start': start, 'end': end});
        }
      }
    }
    
    return result;
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

    if (endDateTime.isBefore(startDateTime) ||
        endDateTime.isAtSameMomentAs(startDateTime)) {
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
      final rehearsalId = const Uuid().v4();

      // Use selected project
      if (_selectedProject == null) {
        throw Exception('Please select a project');
      }

      final projectId = _selectedProject!.id;

      // Use createWithParticipants if there are participants, otherwise use regular create
      if (_selectedParticipants.isNotEmpty) {
        await rehearsalsRepo.createWithParticipants(
          id: rehearsalId,
          projectId: projectId,
          startsAtUtc: startDateTime.toUtc().millisecondsSinceEpoch,
          endsAtUtc: endDateTime.toUtc().millisecondsSinceEpoch,
          place: _placeController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          participantIds: _selectedParticipants.toList(),
        );
      } else {
        await rehearsalsRepo.create(
          id: rehearsalId,
          projectId: projectId,
          startsAtUtc: startDateTime.toUtc().millisecondsSinceEpoch,
          endsAtUtc: endDateTime.toUtc().millisecondsSinceEpoch,
          place: _placeController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );
      }

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
