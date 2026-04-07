import 'dart:async';

/// Jenis event yang dapat men-trigger refresh dashboard
enum AppEvent {
  productCreated,
  productUpdated,
  productDeleted,
  transactionCreated,
}

/// Singleton event bus untuk komunikasi antar-BLoC tanpa coupling langsung.
class AppEventBus {
  AppEventBus._internal();
  static final AppEventBus instance = AppEventBus._internal();

  final _controller = StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get stream => _controller.stream;

  /// Publish event ke semua subscriber.
  void fire(AppEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void dispose() => _controller.close();
}
