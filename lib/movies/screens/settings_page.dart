import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/screens/widgets/app_scaffold.dart';
import 'package:my_movie_search/utilities/app_logger.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:my_movie_search/utilities/settings.dart';

/// Settings page
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static MaterialPage<Object?> goRoute(BuildContext _, GoRouterState _) =>
      const MaterialPage(restorationId: 'SettingsPage', child: SettingsPage());

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// State for the SettingsPage
class _SettingsPageState extends State<SettingsPage> {
  /// The URL of the betterstack logging server.
  static const _logsUrl =
      'https://telemetry.betterstack.com/team/t550725/tail?s=2476806';

  final _formKey = GlobalKey<FormState>();

  bool _offline = false;
  bool _enableLogging = false;
  bool _cloudLogging = false;
  bool _forceHideKeyboard = false;
  LogLevel _logLevel = LogLevel.info;

  late final TextEditingController _serverController;
  late final TextEditingController _portController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  late final TextEditingController _googleUrlController;
  late final TextEditingController _googleKeyController;
  late final TextEditingController _omdbKeyController;
  late final TextEditingController _tmdbKeyController;
  late final TextEditingController _tvdbKeyController;
  late final TextEditingController _loggingKeyController;

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
    _enableLogging = settings.enableLogging;
    _cloudLogging = settings.cloudLogging;
    _forceHideKeyboard = settings.forceHideKeyboard;
    _logLevel = settings.logLevel;

    _serverController = TextEditingController(
      text: settings.localValue(SettingKey.magnetServer),
    );
    _portController = TextEditingController(
      text: settings.localValue(SettingKey.magnetPort),
    );
    _usernameController = TextEditingController(
      text: settings.localValue(SettingKey.magnetUsername),
    );
    _passwordController = TextEditingController(
      text: settings.localValue(SettingKey.magnetPassword),
    );

    _googleUrlController = TextEditingController(
      text: settings.localValue(SettingKey.googleUrl),
    );
    _googleKeyController = TextEditingController(
      text: settings.localValue(SettingKey.googleKey),
    );
    _omdbKeyController = TextEditingController(
      text: settings.localValue(SettingKey.omdbKey),
    );
    _tmdbKeyController = TextEditingController(
      text: settings.localValue(SettingKey.tmdbKey),
    );
    _tvdbKeyController = TextEditingController(
      text: settings.localValue(SettingKey.tvdbKey),
    );
    _loggingKeyController = TextEditingController(
      text: settings.localValue(SettingKey.loggingKey),
    );

    _meiliUrlController = TextEditingController(
      text: settings.localValue(SettingKey.meiliUrl),
    );
    _meiliSearchKeyController = TextEditingController(
      text: settings.localValue(SettingKey.meiliSearchKey),
    );
    _meiliAdminKeyController = TextEditingController(
      text: settings.localValue(SettingKey.meiliAdminKey),
    );

    _seVmKeyController = TextEditingController(
      text: settings.localValue(SettingKey.seVirtualMachineKey),
    );
    _firebaseSecretsLocationController = TextEditingController(
      text: settings.localValue(SettingKey.firebaseSecretsLocation),
    );
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
    _loggingKeyController.dispose();

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
        ..cloudLogging = _cloudLogging
        ..forceHideKeyboard = _forceHideKeyboard
        ..logLevel = _logLevel;

      final SettingsCollection localValues = {};
      localValues[SettingKey.magnetServer] = _serverController.text;
      localValues[SettingKey.magnetPort] = _portController.text;
      localValues[SettingKey.magnetUsername] = _usernameController.text;
      localValues[SettingKey.magnetPassword] = _passwordController.text;
      localValues[SettingKey.googleUrl] = _googleUrlController.text;
      localValues[SettingKey.googleKey] = _googleKeyController.text;
      localValues[SettingKey.omdbKey] = _omdbKeyController.text;
      localValues[SettingKey.tmdbKey] = _tmdbKeyController.text;
      localValues[SettingKey.tvdbKey] = _tvdbKeyController.text;
      localValues[SettingKey.loggingKey] = _loggingKeyController.text;
      localValues[SettingKey.meiliUrl] = _meiliUrlController.text;
      localValues[SettingKey.meiliSearchKey] = _meiliSearchKeyController.text;
      localValues[SettingKey.meiliAdminKey] = _meiliAdminKeyController.text;
      localValues[SettingKey.seVirtualMachineKey] = _seVmKeyController.text;
      localValues[SettingKey.firebaseSecretsLocation] =
          _firebaseSecretsLocationController.text;

      settings.saveToLocal(localValues);

      // Update the logger dynamically
      AppLogger.instance.init(
        enabled: _enableLogging,
        level: _logLevel,
        surpressCloud: !_cloudLogging,
      );

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
      await _saveSettings();
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
              featureToggleCard(),
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
          if (_enableLogging) ...[
            SwitchListTile(
              title: const Text('Cloud Logging'),
              subtitle: const Text('Send logs to betterstack.com'),
              value: _cloudLogging,
              onChanged: (val) {
                setState(() {
                  _cloudLogging = val;
                });
              },
            ),
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

          // cloud logs can be viewed at:
          // https://telemetry.betterstack.com/team/t550725/tail?s=2476806
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => MMSNav(context).viewWebPage(_logsUrl),
            child: const Text('View Cloud Logs'),
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
          const SizedBox(height: 16),
          TextFormField(
            controller: _loggingKeyController,
            decoration: const InputDecoration(
              labelText: 'Betterstack Logging Key',
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

  Card featureToggleCard() => Card(
    margin: const EdgeInsets.only(bottom: 24),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Feature Toggles'),
          SwitchListTile(
            title: const Text('Force hide keyboard'),
            subtitle: const Text('Hide keyboard when not in use'),
            value: _forceHideKeyboard,
            onChanged: (val) {
              setState(() {
                _forceHideKeyboard = val;
              });
            },
          ),
        ],
      ),
    ),
  );
}
