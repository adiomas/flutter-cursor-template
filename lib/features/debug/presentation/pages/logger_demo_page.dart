import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../common/domain/app_environment.dart';
import '../../../../common/utils/logger/app_logger.dart';
import '../../../../theme/app_colors.dart';

/// Demo page for testing the logging system
/// Only visible in dev/staging environments
class LoggerDemoPage extends HookConsumerWidget {
  static const routeName = '/logger-demo';

  const LoggerDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = AppLogger.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Logger Demo'),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_outline,
                              color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Shake to Open Console',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Shake your device 1-2 times to open the developer console and see the logs!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Environment Info
              _buildInfoSection(
                'Current Environment',
                EnvInfo.environment.name.toUpperCase(),
                Icons.settings,
              ),

              const SizedBox(height: 24),

              // Log Level Buttons
              Text(
                'Test Different Log Levels',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              _buildLogButton(
                context,
                'TRACE',
                '🔍 Trace Log',
                Colors.grey,
                () {
                  logger
                      .trace('This is a trace log - very detailed information');
                },
              ),

              _buildLogButton(
                context,
                'DEBUG',
                '🐛 Debug Log',
                Colors.blue,
                () {
                  logger.debug('This is a debug log - debugging information');
                },
              ),

              _buildLogButton(
                context,
                'INFO',
                '💡 Info Log',
                Colors.green,
                () {
                  logger.info('✅ This is an info log - general information');
                },
              ),

              _buildLogButton(
                context,
                'WARNING',
                '⚠️ Warning Log',
                Colors.orange,
                () {
                  logger.warning(
                      '⚠️ This is a warning log - something needs attention');
                },
              ),

              _buildLogButton(
                context,
                'ERROR',
                '❌ Error Log',
                Colors.red,
                () {
                  logger.error(
                    'This is an error log - something went wrong',
                    error: 'Example error message',
                  );
                },
              ),

              _buildLogButton(
                context,
                'FATAL',
                '💀 Fatal Log',
                Colors.red.shade900,
                () {
                  logger.fatal(
                    'This is a fatal log - critical failure',
                    error: 'Critical error occurred',
                    stackTrace: StackTrace.current,
                  );
                },
              ),

              const SizedBox(height: 24),

              // Real-World Scenarios
              Text(
                'Real-World Scenarios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              _buildScenarioButton(
                context,
                '🌐 Simulate API Call',
                Icons.cloud,
                () async {
                  logger.debug('🌐 Starting API call...');
                  await Future.delayed(const Duration(seconds: 1));
                  logger.info('✅ API call completed successfully');
                },
              ),

              _buildScenarioButton(
                context,
                '❌ Simulate API Error',
                Icons.error_outline,
                () async {
                  logger.debug('🌐 Starting API call...');
                  await Future.delayed(const Duration(milliseconds: 500));
                  logger.error(
                    'Failed to fetch data from API',
                    error: 'Network timeout after 30s',
                    stackTrace: StackTrace.current,
                  );
                },
              ),

              _buildScenarioButton(
                context,
                '🧭 Simulate Navigation',
                Icons.navigation,
                () {
                  logger.debug('🧭 Navigating to profile page');
                  logger.debug('Current route: /home');
                  logger.debug('New route: /profile');
                },
              ),

              _buildScenarioButton(
                context,
                '👤 Simulate User Action',
                Icons.person,
                () {
                  logger.info('👤 User tapped login button');
                  logger.debug('Showing login modal');
                  logger.debug('Validating form fields');
                  logger.info('✅ User logged in successfully');
                },
              ),

              _buildScenarioButton(
                context,
                '📊 Generate Multiple Logs',
                Icons.analytics,
                () async {
                  for (int i = 1; i <= 10; i++) {
                    logger.debug('Processing item $i of 10');
                    await Future.delayed(const Duration(milliseconds: 100));
                  }
                  logger.info('✅ Processed 10 items successfully');
                },
              ),

              const SizedBox(height: 24),

              // Clear Logs
              ElevatedButton.icon(
                onPressed: () async {
                  await logger.clearLogs();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logs cleared'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Clear All Logs'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogButton(
    BuildContext context,
    String label,
    String buttonText,
    Color color,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label log created! Shake to view.'),
              backgroundColor: color,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildScenarioButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: () {
          onPressed();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$label - Check logs!'),
              backgroundColor: Colors.blue,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Tap any button to generate logs',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '2. Shake your device 1-2 times',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '3. Developer console will open automatically',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '4. Filter, search, and inspect logs',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('• Real-time log updates', style: TextStyle(fontSize: 12)),
              Text('• Filter by log level', style: TextStyle(fontSize: 12)),
              Text('• Search logs', style: TextStyle(fontSize: 12)),
              Text('• Export logs', style: TextStyle(fontSize: 12)),
              Text('• Copy individual logs', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
