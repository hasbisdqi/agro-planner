import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/plant_model.dart';
import '../services/db_service.dart';

class PlantFormScreen extends StatefulWidget {
  final Plant? plant;

  const PlantFormScreen({super.key, this.plant});

  @override
  State<PlantFormScreen> createState() => _PlantFormScreenState();
}

class _PlantFormScreenState extends State<PlantFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final DbService _dbService = DbService();

  late TextEditingController _nameController;
  late TextEditingController _areaController;
  late TextEditingController _plantDateController;
  late TextEditingController _harvestDateController;

  DateTime? _selectedPlantDate;
  DateTime? _selectedHarvestDate;

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final plant = widget.plant;
    _nameController = TextEditingController(text: plant?.name ?? '');
    _areaController = TextEditingController(
      text: plant != null ? plant.area.toString() : '',
    );

    if (plant != null) {
      try {
        _selectedPlantDate = DateTime.parse(plant.plantDate);
        _plantDateController = TextEditingController(
          text: _dateFormat.format(_selectedPlantDate!),
        );
      } catch (_) {
        _plantDateController = TextEditingController(text: plant.plantDate);
      }

      try {
        _selectedHarvestDate = DateTime.parse(plant.harvestDate);
        _harvestDateController = TextEditingController(
          text: _dateFormat.format(_selectedHarvestDate!),
        );
      } catch (_) {
        _harvestDateController = TextEditingController(text: plant.harvestDate);
      }
    } else {
      _selectedPlantDate = DateTime.now();
      _selectedHarvestDate = DateTime.now().add(const Duration(days: 90));
      _plantDateController = TextEditingController(
        text: _dateFormat.format(_selectedPlantDate!),
      );
      _harvestDateController = TextEditingController(
        text: _dateFormat.format(_selectedHarvestDate!),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _plantDateController.dispose();
    _harvestDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required BuildContext context,
    required bool isPlantDate,
  }) async {
    final initialDate = isPlantDate
        ? (_selectedPlantDate ?? DateTime.now())
        : (_selectedHarvestDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isPlantDate) {
          _selectedPlantDate = picked;
          _plantDateController.text = _dateFormat.format(picked);
        } else {
          _selectedHarvestDate = picked;
          _harvestDateController.text = _dateFormat.format(picked);
        }
      });
    }
  }

  Future<void> _savePlant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final name = _nameController.text.trim();
    final area = double.parse(_areaController.text.trim().replaceAll(',', '.'));
    final plantDate = (_selectedPlantDate ?? DateTime.now()).toIso8601String();
    final harvestDate =
        (_selectedHarvestDate ?? DateTime.now()).toIso8601String();

    try {
      if (widget.plant == null) {
        final newPlant = Plant(
          name: name,
          area: area,
          plantDate: plantDate,
          harvestDate: harvestDate,
        );
        await _dbService.insertPlant(newPlant);
      } else {
        final updatedPlant = widget.plant!.copyWith(
          name: name,
          area: area,
          plantDate: plantDate,
          harvestDate: harvestDate,
        );
        await _dbService.updatePlant(updatedPlant);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.plant == null
                  ? 'Plant added successfully'
                  : 'Plant updated successfully',
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save plant: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.plant != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Plant' : 'Add Plant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Plant Name / Nama Tanaman',
                  prefixIcon: Icon(Icons.eco),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter plant name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Area / Luas Lahan (m²)',
                  prefixIcon: Icon(Icons.square_foot),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter area size';
                  }
                  // Normalize comma to dot
                  final normalizedValue = value.replaceAll(',', '.');
                  final parsed = double.tryParse(normalizedValue);
                  if (parsed == null || parsed <= 0 || parsed.isNaN || parsed.isInfinite) {
                    return 'Please enter a valid positive number';
                  }
                  // Edge case limit for rational land size (e.g. 10.000 Hectares)
                  if (parsed > 100000000) {
                    return 'Luas lahan tidak wajar (>10.000 Hektar)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plantDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Plant Date / Tanggal Tanam',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                onTap: () => _pickDate(context: context, isPlantDate: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _harvestDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Harvest Date / Tanggal Panen',
                  prefixIcon: Icon(Icons.event_available),
                  border: OutlineInputBorder(),
                ),
                onTap: () => _pickDate(context: context, isPlantDate: false),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isSaving ? null : _savePlant,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isSaving
                      ? 'Saving...'
                      : (isEditing ? 'Update Plant' : 'Save Plant'),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
