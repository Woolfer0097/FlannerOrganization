import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'HabbitsScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Theme/Theme.dart';


class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add_habit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.title),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_title;
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.description_empty),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_description;
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.end_date),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                },
                validator: (value) {
                  if (_endDate == null) {
                    return AppLocalizations.of(context)!.please_select_an_end_date;
                  }
                  return null;
                },
                onSaved: (value) {
                  // No need to save as _endDate is already set
                },
                controller: TextEditingController(
                  text: _endDate != null
                      ? _endDate!.toLocal().toString().split(' ')[0]
                      : '',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    Habit newHabit = Habit(
                      title: _title,
                      description: _description,
                      startDate: DateTime.now(),
                      endDate: _endDate!,
                      dates: {},
                    );
                    Provider.of<HabitProvider>(context, listen: false)
                        .addHabit(newHabit);
                    Navigator.pop(context);
                  }
                },
                child: Text(AppLocalizations.of(context)!.add_habit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
