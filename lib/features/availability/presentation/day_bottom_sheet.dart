import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    setState(() {
      _intervals.removeAt(index);
    });
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: const Key('availability_snackbar_error'),
        content: const Text('Error'),
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
      await controller.setIntervals(
        dayLocal: widget.dayLocal,
        intervalsLocal: _intervals,
        tz: tz.local.name,
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
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                key: const Key('status_free'),
                label: const Text('Free'),
                selected: _status == AvailabilityStatus.free,
                onSelected: (_) => setState(() {
                  _status = AvailabilityStatus.free;
                }),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                key: const Key('status_busy'),
                label: const Text('Busy'),
                selected: _status == AvailabilityStatus.busy,
                onSelected: (_) => setState(() {
                  _status = AvailabilityStatus.busy;
                }),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                key: const Key('status_partial'),
                label: const Text('Partial'),
                selected: _status == AvailabilityStatus.partial,
                onSelected: (_) => setState(() {
                  _status = AvailabilityStatus.partial;
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_status == AvailabilityStatus.partial) ...[
            ElevatedButton(
              key: const Key('add_interval'),
              onPressed: _addInterval,
              child: const Text('Add interval'),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _intervals.length; i++)
              Row(
                children: [
                  TextButton(
                    key: Key('start_$i'),
                    onPressed: () => _pickStart(i),
                    child: Text(_intervals[i].start.format(context)),
                  ),
                  TextButton(
                    key: Key('end_$i'),
                    onPressed: () => _pickEnd(i),
                    child: Text(_intervals[i].end.format(context)),
                  ),
                  IconButton(
                    key: Key('remove_$i'),
                    onPressed: () => _removeInterval(i),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                key: const Key('cancel_btn'),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                key: const Key('save_btn'),
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
