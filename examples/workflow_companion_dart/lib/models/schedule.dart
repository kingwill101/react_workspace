/// Schedule types supported by the Workflow Companion.
enum ScheduleType { cron, solar, webhook }

/// Solar events accepted by [SolarSchedule].
enum SolarEvent {
  sunrise,
  sunset,
  dawnAstronomical,
  dawnCivil,
  dawnNautical,
  duskAstronomical,
  duskCivil,
  duskNautical,
  solarNoon,
}

/// HTTP methods available to webhook schedules.
enum ScheduleHttpMethod { get, post, put, delete }

/// Common contract for the discriminated schedule configuration records.
sealed class ScheduleConfig {
  /// Creates a schedule configuration.
  const ScheduleConfig(this.type);

  /// Configuration discriminator.
  final ScheduleType type;
}

/// A cron-based schedule.
final class CronSchedule extends ScheduleConfig {
  /// Creates a cron schedule.
  const CronSchedule({
    required this.expression,
    required this.timezone,
    this.callbackUrl,
    this.callbackMethod,
    this.callbackHeaders = const {},
  }) : super(ScheduleType.cron);

  final String expression;
  final String timezone;
  final String? callbackUrl;
  final ScheduleHttpMethod? callbackMethod;
  final Map<String, String> callbackHeaders;
}

/// A schedule relative to a solar event.
final class SolarSchedule extends ScheduleConfig {
  /// Creates a solar schedule.
  const SolarSchedule({
    required this.event,
    required this.latitude,
    required this.longitude,
    this.offset,
  }) : super(ScheduleType.solar);

  final SolarEvent event;
  final double latitude;
  final double longitude;
  final String? offset;
}

/// A schedule driven by an HTTP endpoint.
final class WebhookSchedule extends ScheduleConfig {
  /// Creates a webhook schedule.
  const WebhookSchedule({
    required this.url,
    required this.method,
    this.headers = const {},
    this.secret,
  }) : super(ScheduleType.webhook);

  final String url;
  final ScheduleHttpMethod method;
  final Map<String, String> headers;
  final String? secret;
}

/// A persisted schedule shown in the dashboard.
final class Schedule {
  /// Creates a schedule summary.
  const Schedule({
    required this.id,
    required this.name,
    required this.type,
    required this.targetName,
    required this.enabled,
    required this.nextRun,
    required this.runCount,
    this.description,
    this.targetType = 'workflow',
    this.targetId = '',
    this.config = const CronSchedule(expression: '* * * * *', timezone: 'UTC'),
    this.lastRun,
    this.failureCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final bool enabled;
  final String targetType;
  final String targetId;
  final String targetName;
  final ScheduleType type;
  final ScheduleConfig config;
  final String? lastRun;
  final String nextRun;
  final int runCount;
  final int failureCount;
  final String? createdAt;
  final String? updatedAt;
}
