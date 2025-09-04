import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'availability_controller.dart';
import 'availability_state.dart';

final availabilityControllerProvider = NotifierProvider<AvailabilityController,
    AvailabilityState>(AvailabilityController.new);
