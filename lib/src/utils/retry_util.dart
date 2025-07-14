/// Utility for implementing retry logic with exponential backoff.
library;

import 'dart:io';
import 'dart:math';
import 'package:logging/logging.dart';

/// A utility class for implementing retry logic with exponential backoff.
class RetryUtil {
  static final Logger _logger = Logger('RetryUtil');

  /// Executes a function with retry logic and exponential backoff.
  ///
  /// [operation] - The async operation to retry
  /// [maxRetries] - Maximum number of retry attempts (default: 3)
  /// [baseDelay] - Base delay between retries in milliseconds (default: 1000)
  /// [maxDelay] - Maximum delay between retries in milliseconds (default: 30000)
  /// [retryIf] - Optional condition to determine if operation should be retried
  static Future<T> withRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    int baseDelay = 1000,
    int maxDelay = 30000,
    bool Function(Exception)? retryIf,
  }) async {
    int attempt = 0;
    Exception? lastException;

    while (attempt <= maxRetries) {
      try {
        return await operation();
      } on Exception catch (e) {
        lastException = e;

        // Check if we should retry this exception
        if (retryIf != null && !retryIf(e)) {
          rethrow;
        }

        // Don't retry on the last attempt
        if (attempt >= maxRetries) {
          rethrow;
        }

        // Calculate delay with exponential backoff and jitter
        final delay = _calculateDelay(attempt, baseDelay, maxDelay);

        _logger.warning(
          '🔄 Retry attempt ${attempt + 1}/$maxRetries after ${delay}ms delay. Error: ${e.toString()}',
        );

        await Future<void>.delayed(Duration(milliseconds: delay));
        attempt++;
      }
    }

    // This should never be reached, but included for completeness
    throw lastException ?? Exception('Retry operation failed');
  }

  /// Calculates delay with exponential backoff and jitter.
  static int _calculateDelay(int attempt, int baseDelay, int maxDelay) {
    // Exponential backoff: baseDelay * 2^attempt
    final exponentialDelay = baseDelay * pow(2, attempt).toInt();

    // Add jitter (±25% random variation)
    final random = Random();
    final jitter = exponentialDelay * 0.25 * (random.nextDouble() - 0.5);

    // Apply jitter and cap at maxDelay
    final finalDelay = (exponentialDelay + jitter).round();

    return finalDelay.clamp(baseDelay, maxDelay);
  }

  /// Predefined retry conditions for common scenarios.
  static const RetryConditions conditions = RetryConditions._();
}

/// Common retry conditions for different types of operations.
class RetryConditions {
  const RetryConditions._();

  /// Retry on network-related exceptions.
  bool network(Exception e) {
    return e is SocketException ||
        e is HttpException ||
        e.toString().toLowerCase().contains('network');
  }

  /// Retry on temporary server errors (5xx HTTP status codes).
  bool serverError(Exception e) {
    if (e is HttpException) {
      final message = e.message.toLowerCase();
      return message.contains('500') ||
          message.contains('502') ||
          message.contains('503') ||
          message.contains('504');
    }
    return false;
  }

  /// Retry on timeout-related errors.
  bool timeout(Exception e) {
    final message = e.toString().toLowerCase();
    return message.contains('timeout') || message.contains('timed out');
  }

  /// Retry on rate limiting errors.
  bool rateLimit(Exception e) {
    if (e is HttpException) {
      return e.message.contains('429') ||
          e.message.toLowerCase().contains('rate limit');
    }
    return false;
  }

  /// Combine multiple retry conditions with OR logic.
  bool Function(Exception) or(List<bool Function(Exception)> conditions) {
    return (Exception e) {
      return conditions.any((condition) => condition(e));
    };
  }

  /// Combine multiple retry conditions with AND logic.
  bool Function(Exception) and(List<bool Function(Exception)> conditions) {
    return (Exception e) {
      return conditions.every((condition) => condition(e));
    };
  }
}
