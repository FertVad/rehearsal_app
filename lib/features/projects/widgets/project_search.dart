import 'package:flutter/material.dart';
import 'package:rehearsal_app/core/design_system/app_spacing.dart';

class ProjectSearch extends StatefulWidget {
  const ProjectSearch({
    super.key,
    required this.onSearchChanged,
  });

  final Function(String) onSearchChanged;

  @override
  State<ProjectSearch> createState() => _ProjectSearchState();
}

class _ProjectSearchState extends State<ProjectSearch> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingLG,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search projects...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchChanged('');
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
          ),
        ),
        onChanged: (value) {
          widget.onSearchChanged(value);
          setState(() {});
        },
      ),
    );
  }
}

