import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/screens/widgets/app_scaffold.dart';
import 'package:my_movie_search/utilities/app_logger.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/settings.dart';

/// Settings page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static MaterialPage<dynamic> goRoute(BuildContext _, GoRouterState _) =>
      const MaterialPage(restorationId: 'SettingsPage', child: SettingsPage());

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// State for the SettingsPage
class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  bool _offline = false;
  bool _enableLogging = false;
  LogLevel _logLevel = LogLevel.info;

  late final bool _initialOffline;
  late final bool _initialEnableLogging;
  late final LogLevel _initialLogLevel;

  late final TextEditingController _serverController;
  late final TextEditingController _portController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  late final TextEditingController _googleUrlController;
  late final TextEditingController _googleKeyController;
  late final TextEditingController _omdbKeyController;
  late final TextEditingController _tmdbKeyController;
  late final TextEditingController _tvdbKeyController;

  late final TextEditingController _meiliUrlController;
  late final TextEditingController _meiliSearchKeyController;
  late final TextEditingController _meiliAdminKeyController;

  late final TextEditingController _seVmKeyController;
  late final TextEditingController _firebaseSecretsLocationController;

  @override
  /// Initialize the settings page
  void initState() {
    super.initState();
    final settings = Settings();

    _offline = settings.offline;
    _initialOffline = _offline;

    _enableLogging = settings.enableLogging;
    _initialEnableLogging = _enableLogging;

    _logLevel = settings.logLevel;
    _initialLogLevel = _logLevel;

    _serverController = TextEditingController(text: settings.localMagnetServer);
    _portController = TextEditingController(text: settings.localMagnetPort);
    _usernameController = TextEditingController(
      text: settings.localMagnetUsername,
    );
    _passwordController = TextEditingController(
      text: settings.localMagnetPassword,
    );

    _googleUrlController = TextEditingController(text: settings.localGoogleurl);
    _googleKeyController = TextEditingController(text: settings.localGooglekey);
    _omdbKeyController = TextEditingController(text: settings.localOmdbkey);
    _tmdbKeyController = TextEditingController(text: settings.localTmdbkey);
    _tvdbKeyController = TextEditingController(text: settings.localTvdbkey);

    _meiliUrlController = TextEditingController(text: settings.localMeiliurl);
    _meiliSearchKeyController = TextEditingController(
      text: settings.localMeilisearchkey,
    );
    _meiliAdminKeyController = TextEditingController(
      text: settings.localMeiliadminkey,
    );

    _seVmKeyController = TextEditingController(text: settings.localSeVmKey);
    _firebaseSecretsLocationController = TextEditingController(
      text: settings.localFirebaseSecretsLocation,
    );
  }

  bool _hasChanges() {
    final settings = Settings();
    return _offline != _initialOffline ||
        _enableLogging != _initialEnableLogging ||
        _logLevel != _initialLogLevel ||
        _serverController.text != (settings.localMagnetServer ?? '') ||
        _portController.text != (settings.localMagnetPort ?? '') ||
        _usernameController.text != (settings.localMagnetUsername ?? '') ||
        _passwordController.text != (settings.localMagnetPassword ?? '') ||
        _googleUrlController.text !=
            (settings.localGoogleurl ?? settings.googleurl) ||
        _googleKeyController.text != (settings.localGooglekey ?? '') ||
        _omdbKeyController.text != (settings.localOmdbkey ?? '') ||
        _tmdbKeyController.text != (settings.localTmdbkey ?? '') ||
        _tvdbKeyController.text != (settings.localTvdbkey ?? '') ||
        _meiliUrlController.text !=
            (settings.localMeiliurl ?? settings.meiliurl) ||
        _meiliSearchKeyController.text !=
            (settings.localMeilisearchkey ?? '') ||
        _meiliAdminKeyController.text != (settings.localMeiliadminkey ?? '') ||
        _seVmKeyController.text != (settings.localSeVmKey ?? '') ||
        _firebaseSecretsLocationController.text !=
            (settings.localFirebaseSecretsLocation ?? '');
  }

  @override
  /// Dispose the settings page
  void dispose() {
    _serverController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    _googleUrlController.dispose();
    _googleKeyController.dispose();
    _omdbKeyController.dispose();
    _tmdbKeyController.dispose();
    _tvdbKeyController.dispose();

    _meiliUrlController.dispose();
    _meiliSearchKeyController.dispose();
    _meiliAdminKeyController.dispose();

    _seVmKeyController.dispose();
    _firebaseSecretsLocationController.dispose();
    super.dispose();
  }

  /// Save settings to local storage
  Future<void> _saveSettings() async {
    if (_formKey.currentState?.validate() ?? false) {
      final settings = Settings()
        ..offline = _offline
        ..enableLogging = _enableLogging
        ..logLevel = _logLevel
        ..localMagnetServer = _serverController.text
        ..localMagnetPort = _portController.text
        ..localMagnetUsername = _usernameController.text
        ..localMagnetPassword = _passwordController.text
        ..localGoogleurl = _googleUrlController.text
        ..localGooglekey = _googleKeyController.text
        ..localOmdbkey = _omdbKeyController.text
        ..localTmdbkey = _tmdbKeyController.text
        ..localTvdbkey = _tvdbKeyController.text
        ..localMeiliurl = _meiliUrlController.text
        ..localMeilisearchkey = _meiliSearchKeyController.text
        ..localMeiliadminkey = _meiliAdminKeyController.text
        ..localSeVmKey = _seVmKeyController.text
        ..localFirebaseSecretsLocation =
            _firebaseSecretsLocationController.text;

      await settings.saveToLocal();

      // Update the logger dynamically
      AppLogger.instance.init(enabled: _enableLogging, level: _logLevel);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Settings saved. Some changes may require an app restart.',
            ),
          ),
        );
      }
    }
  }

  /// Build a section header for the settings page
  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
  );

  @override
  /// Build the settings page
  Widget build(BuildContext context) => PopScope(
    onPopInvokedWithResult: (didPop, result) async {
      if (_hasChanges()) {
        await _saveSettings();
      }
    },
    child: AppScaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              generalCard(),
              magnetTorrentCard(),
              searchCard(),
              meilisearchCard(),
              systemSecrets(),
              const SizedBox(height: 48), // Padding at bottom
            ],
          ),
        ),
      ),
    ),
  );

  /// Build the general settings card
  Card generalCard() => Card(
    margin: const EdgeInsets.only(bottom: 24),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('General Settings'),
          SwitchListTile(
            title: const Text('Offline Mode'),
            subtitle: const Text(
              'Disable external network requests if possible',
            ),
            value: _offline,
            onChanged: (val) {
              setState(() {
                _offline = val;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Logging Settings'),
          SwitchListTile(
            title: const Text('Enable Logging'),
            value: _enableLogging,
            onChanged: (val) {
              setState(() {
                _enableLogging = val;
              });
            },
          ),
          if (_enableLogging)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                initialValue: _logLevel.name,
                decoration: const InputDecoration(
                  labelText: 'Log Level',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'trace', child: Text('Trace')),
                  DropdownMenuItem(value: 'debug', child: Text('Debug')),
                  DropdownMenuItem(value: 'info', child: Text('Info')),
                  DropdownMenuItem(value: 'warning', child: Text('Warning')),
                  DropdownMenuItem(value: 'error', child: Text('Error')),
                  DropdownMenuItem(value: 'fatal', child: Text('Fatal')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _logLevel =
                          LogLevel.values.byFullName(val) ?? LogLevel.off;
                    });
                  }
                },
              ),
            ),
        ],
      ),
    ),
  );

  /// Build the magnet / torrent settings card
  Card magnetTorrentCard() => Card(
    margin: const EdgeInsets.only(bottom: 24),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Magnet / Torrent Settings'),
          TextFormField(
            controller: _serverController,
            decoration: const InputDecoration(
              labelText: 'Server URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _portController,
            decoration: const InputDecoration(
              labelText: 'Port',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    ),
  );

  /// Build the search APIs card
  Card searchCard() => Card(
    margin: const EdgeInsets.only(bottom: 24),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Search APIs'),
          TextFormField(
            controller: _googleUrlController,
            decoration: const InputDecoration(
              labelText: 'Google Search URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _googleKeyController,
            decoration: const InputDecoration(
              labelText: 'Google Key',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _omdbKeyController,
            decoration: const InputDecoration(
              labelText: 'OMDB Key',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tmdbKeyController,
            decoration: const InputDecoration(
              labelText: 'TMDB Key',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tvdbKeyController,
            decoration: const InputDecoration(
              labelText: 'TVDB Key',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    ),
  );

  /// Build the meilisearch card
  Card meilisearchCard() => Card(
    margin: const EdgeInsets.only(bottom: 24),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Meilisearch Database'),
          TextFormField(
            controller: _meiliUrlController,
            decoration: const InputDecoration(
              labelText: 'URL',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _meiliSearchKeyController,
            decoration: const InputDecoration(
              labelText: 'Search Key',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _meiliAdminKeyController,
            decoration: const InputDecoration(
              labelText: 'Admin Key',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    ),
  );

  /// Build the system secrets card
  Card systemSecrets() => Card(
    margin: const EdgeInsets.only(bottom: 24),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('System Secrets'),
          TextFormField(
            controller: _firebaseSecretsLocationController,
            decoration: const InputDecoration(
              labelText: 'Firebase Secrets Location',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _seVmKeyController,
            decoration: const InputDecoration(
              labelText: 'SE VM Key',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    ),
  );
}
