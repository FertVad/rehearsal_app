import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';
import 'package:rehearsal_app/core/design_system/app_typography.dart';
import 'package:rehearsal_app/core/design_system/glass_system.dart';
import 'package:rehearsal_app/core/design_system/haptics.dart';
import 'package:rehearsal_app/l10n/app.dart';
import 'package:timezone/timezone.dart' as tz;

import '../controller/availability_provider.dart';
import '../controller/availability_state.dart';

class DayBottomSheet extends ConsumerStatefulWidget {
  const DayBottomSheet({super.key, required this.dayLocal});

  final DateTime dayLocal;

  @override
  ConsumerState<DayBottomSheet> createState() => _DayBottomSheetState();
}

class _DayBottomSheetState extends ConsumerState<DayBottomSheet> {
  AvailabilityStatus _status = AvailabilityStatus.free;
  final _intervals = <({TimeOfDay start, TimeOfDay end})>[];

  void _addInterval() {
    if (_intervals.length >= 6) return;
    Haptics.light();
    setState(() {
      _intervals.add((
        start: const TimeOfDay(hour: 10, minute: 0),
        end: const TimeOfDay(hour: 11, minute: 0),
      ));
    });
  }

  Future<void> _pickStart(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _intervals[index].start,
    );
    if (picked != null) {
      setState(() {
        final cur = _intervals[index];
        _intervals[index] = (start: picked, end: cur.end);
      });
    }
  }

  Future<void> _pickEnd(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _intervals[index].end,
    );
    if (picked != null) {
      setState(() {
        final cur = _intervals[index];
        _intervals[index] = (start: cur.start, end: picked);
      });
    }
  }

  void _removeInterval(int index) {
    Haptics.light();
    setState(() {
      _intervals.removeAt(index);
    });
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('availability_snackbar_error'),
        content: Text(context.l10n.availabilityError),
      ),
    );
  }

  Future<void> _save() async {
    final controller = ref.read(availabilityControllerProvider.notifier);
    if (_status == AvailabilityStatus.partial) {
      if (_intervals.isEmpty) {
        if (!mounted) return;
        _showError();
        return;
      }
      // Use the local timezone by getting it from the timezone package
      // On web, this will default to the browser's timezone
      String localTimezoneName = 'UTC'; // default fallback
      try {
        localTimezoneName = tz.local.name;
      } catch (e) {
        // Try to determine timezone from offset if tz.local fails
        final now = DateTime.now();
        final offset = now.timeZoneOffset;

        // Map common offsets to IANA timezone names
        // This is a simplified mapping for the most common cases
        if (offset.inHours == 2 || offset.inHours == 3) {
          // Israel timezone (UTC+2/+3 depending on DST)
          localTimezoneName = 'Asia/Jerusalem';
        } else if (offset.inHours >= -8 && offset.inHours <= -5) {
          // US timezones
          localTimezoneName = 'America/New_York';
        } else if (offset.inHours >= 1 && offset.inHours <= 2) {
          // European timezones
          localTimezoneName = 'Europe/Berlin';
        } else {
          localTimezoneName = 'UTC';
        }
      }

      await controller.setIntervals(
        dayLocal: widget.dayLocal,
        intervalsLocal: _intervals,
        tz: localTimezoneName,
      );
      if (!mounted) return;
    } else {
      await controller.setStatus(dayLocal: widget.dayLocal, status: _status);
      if (!mounted) return;
    }
    final error = ref.read(availabilityControllerProvider).error;
    if (error != null) {
      if (!mounted) return;
      _showError();
    } else {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        top: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.daySheetChangeAvailability,
            style: AppTypography.titleSm,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GlassChip(
                key: const Key('status_free'),
                label: context.l10n.availabilityStatusFree,
                selected: _status == AvailabilityStatus.free,
                onTap: () {
                  setState(() => _status = AvailabilityStatus.free);
                  Haptics.selection();
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              GlassChip(
                key: const Key('status_busy'),
                label: context.l10n.availabilityStatusBusy,
                selected: _status == AvailabilityStatus.busy,
                onTap: () {
                  setState(() => _status = AvailabilityStatus.busy);
                  Haptics.selection();
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              GlassChip(
                key: const Key('status_partial'),
                label: context.l10n.availabilityStatusPartial,
                selected: _status == AvailabilityStatus.partial,
                onTap: () {
                  setState(() => _status = AvailabilityStatus.partial);
                  Haptics.selection();
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_status == AvailabilityStatus.partial) ...[
            ElevatedButton(
              key: const Key('add_interval'),
              onPressed: () {
                Haptics.light();
                _addInterval();
              },
              child: Text(
                context.l10n.availabilityAddInterval,
                style: AppTypography.label,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < _intervals.length; i++)
              Row(
                children: [
                  TextButton(
                    key: Key('start_$i'),
                    onPressed: () {
                      Haptics.selection();
                      _pickStart(i);
                    },
                    child: Text(
                      _intervals[i].start.format(context),
                      style: AppTypography.label,
                    ),
                  ),
                  TextButton(
                    key: Key('end_$i'),
                    onPressed: () {
                      Haptics.selection();
                      _pickEnd(i);
                    },
                    child: Text(
                      _intervals[i].end.format(context),
                      style: AppTypography.label,
                    ),
                  ),
                  IconButton(
                    key: Key('remove_$i'),
                    onPressed: () {
                      Haptics.light();
                      _removeInterval(i);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                key: const Key('cancel_btn'),
                onPressed: () {
                  Haptics.light();
                  Navigator.of(context).pop();
                },
                child: Text(
                  context.l10n.availabilityCancel,
                  style: AppTypography.label,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                key: const Key('save_btn'),
                onPressed: () {
                  Haptics.light();
                  _save();
                },
                child: Text(
                  context.l10n.availabilitySave,
                  style: AppTypography.label,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
