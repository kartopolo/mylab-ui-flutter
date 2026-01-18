import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final ApiService _api = ApiService();
  bool _loading = true;
  List<dynamic> _rows = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => _loading = true);
    try {
      final resp = await _api.post('/v1/crud/pasien/select', {'page': 1, 'per_page': 100});
      final data = (resp['data'] as List?) ?? [];
      setState(() {
        _rows = data;
      });
    } catch (e) {
      setState(() {
        _rows = [];
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [IconButton(onPressed: _loadPatients, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _rows.isEmpty
              ? const Center(child: Text('No patients found'))
              : ListView.separated(
                  itemCount: _rows.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, idx) {
                    final row = _rows[idx] as Map<String, dynamic>;
                    final name = row['nama_ps'] ?? row['name'] ?? row['nama'] ?? '—';
                    final id = row['kd_ps'] ?? row['id'] ?? '';
                    return ListTile(
                      title: Text(name.toString()),
                      subtitle: Text(id.toString()),
                      onTap: () {
                        // TODO: navigate to patient detail
                      },
                    );
                  },
                ),
    );
  }
}
