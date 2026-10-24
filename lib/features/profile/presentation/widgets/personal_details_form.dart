import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../practice/data/practice_store.dart';

class PersonalDetailsForm extends StatefulWidget {
  const PersonalDetailsForm({
    super.key,
    required this.store,
    this.isSetup = false,
  });

  final PracticeStore store;
  final bool isSetup;

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _instrument;
  late final TextEditingController _level;
  late final TextEditingController _goal;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final data = widget.store.data;
    _name = TextEditingController(text: data.displayName);
    _instrument = TextEditingController(text: data.instrument);
    _level = TextEditingController(text: data.level);
    _goal = TextEditingController(text: data.goal);
  }

  @override
  void dispose() {
    _name.dispose();
    _instrument.dispose();
    _level.dispose();
    _goal.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Please fill this in.' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.store.save({
        'displayName': _name.text.trim(),
        'instrument': _instrument.text.trim(),
        'level': _level.text.trim(),
        'goal': _goal.text.trim(),
      });
      if (mounted && !widget.isSetup) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your details have been saved.')),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not save your details. Try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppColors.watch(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Your name',
              hintText: 'What should we call you?',
            ),
            validator: _required,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _instrument,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Instrument',
              hintText: 'E.g. trumpet, trombone, euphonium',
            ),
            validator: _required,
          ),
          const SizedBox(height: 10),
          Text(
            'Suggestions',
            style: TextStyle(color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final instrument in const [
                'Trumpet',
                'Trombone',
                'French horn',
                'Tuba',
                'Euphonium',
                'Cornet',
              ])
                ActionChip(
                  label: Text(instrument),
                  onPressed: () =>
                      setState(() => _instrument.text = instrument),
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _level,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Your level',
              hintText: 'Describe your experience',
            ),
            validator: _required,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final level in const [
                'Beginner',
                'Intermediate',
                'Advanced',
                'Professional',
              ])
                ActionChip(
                  label: Text(level),
                  onPressed: () => setState(() => _level.text = level),
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _goal,
            textCapitalization: TextCapitalization.sentences,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Your practice goal',
              hintText: 'What would you like to improve?',
              alignLabelWithHint: true,
            ),
            validator: _required,
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: AppColors.destructive)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(
                _saving
                    ? 'Saving…'
                    : widget.isSetup
                    ? 'Save and start practicing'
                    : 'Save my details',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
