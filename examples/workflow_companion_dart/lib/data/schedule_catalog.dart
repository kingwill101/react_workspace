import '../models/schedule.dart';

/// A named cron expression shown in the schedule editor.
final class CronPreset {
  /// Creates a preset.
  const CronPreset(this.label, this.expression);

  /// Human-readable name.
  final String label;

  /// Five-field cron expression.
  final String expression;
}

/// Common expressions offered by the reference schedule editor.
const cronPresets = <CronPreset>[
  CronPreset('Every minute', '* * * * *'),
  CronPreset('Every 5 minutes', '*/5 * * * *'),
  CronPreset('Every 15 minutes', '*/15 * * * *'),
  CronPreset('Every hour', '0 * * * *'),
  CronPreset('Every day at midnight', '0 0 * * *'),
  CronPreset('Every day at 9 AM', '0 9 * * *'),
  CronPreset('Every Monday at 9 AM', '0 9 * * 1'),
  CronPreset('First of every month', '0 0 1 * *'),
];

/// Time zones available to cron schedules in the demo.
const scheduleTimezones = <String>[
  'UTC',
  'America/New_York',
  'America/Los_Angeles',
  'America/Chicago',
  'America/Denver',
  'Europe/London',
  'Europe/Paris',
  'Europe/Berlin',
  'Asia/Tokyo',
  'Asia/Shanghai',
  'Asia/Singapore',
  'Australia/Sydney',
  'Pacific/Auckland',
];

/// Display metadata for a solar event selector.
final class SolarEventOption {
  /// Creates a solar event option.
  const SolarEventOption(this.event, this.label, this.description);

  /// Event value.
  final SolarEvent event;

  /// Human-readable label.
  final String label;

  /// Explanation shown below the selector.
  final String description;
}

/// Solar events supported by the schedule editor.
const solarEventOptions = <SolarEventOption>[
  SolarEventOption(
    SolarEvent.sunrise,
    'Sunrise',
    'When the sun rises above the horizon',
  ),
  SolarEventOption(
    SolarEvent.sunset,
    'Sunset',
    'When the sun sets below the horizon',
  ),
  SolarEventOption(
    SolarEvent.dawnAstronomical,
    'Astronomical dawn',
    'Sun is 18 degrees below the horizon',
  ),
  SolarEventOption(
    SolarEvent.dawnCivil,
    'Civil dawn',
    'Sun is 6 degrees below the horizon',
  ),
  SolarEventOption(
    SolarEvent.dawnNautical,
    'Nautical dawn',
    'Sun is 12 degrees below the horizon',
  ),
  SolarEventOption(
    SolarEvent.duskAstronomical,
    'Astronomical dusk',
    'Sun is 18 degrees below the horizon',
  ),
  SolarEventOption(
    SolarEvent.duskCivil,
    'Civil dusk',
    'Sun is 6 degrees below the horizon',
  ),
  SolarEventOption(
    SolarEvent.duskNautical,
    'Nautical dusk',
    'Sun is 12 degrees below the horizon',
  ),
  SolarEventOption(
    SolarEvent.solarNoon,
    'Solar noon',
    'When the sun reaches its highest point',
  ),
];
