import 'package:flame/components.dart';

/// A generic object pool for reusing game objects
class ObjectPool<T> {
  /// List of available (unused) objects
  final List<T> _available = [];

  /// List of in-use objects
  final List<T> _inUse = [];

  /// Factory function to create new instances
  final T Function() _factory;

  /// Optional function to reset an object before reusing it
  final void Function(T)? _reset;

  /// Optional function to dispose an object
  final void Function(T)? _dispose;

  /// Maximum size of the pool
  final int _maxSize;

  /// Constructor
  ObjectPool({
    required T Function() factory,
    void Function(T)? reset,
    void Function(T)? dispose,
    int initialSize = 0,
    int maxSize = 100,
  })  : _factory = factory,
        _reset = reset,
        _dispose = dispose,
        _maxSize = maxSize {
    // Pre-allocate initial objects
    for (int i = 0; i < initialSize; i++) {
      _available.add(_factory());
    }
  }

  /// Get an object from the pool
  T get() {
    if (_available.isEmpty) {
      // Create a new instance if none are available
      if (_inUse.length < _maxSize) {
        _available.add(_factory());
      } else {
        throw Exception('ObjectPool: maximum pool size reached');
      }
    }

    final object = _available.removeLast();
    _inUse.add(object);
    return object;
  }

  /// Return an object to the pool
  void release(T object) {
    if (_inUse.remove(object)) {
      if (_reset != null) {
        _reset!(object);
      }
      _available.add(object);
    }
  }

  /// Get the number of objects in use
  int get inUseCount => _inUse.length;

  /// Get the number of available objects
  int get availableCount => _available.length;

  /// Get the total number of objects in the pool
  int get totalCount => _inUse.length + _available.length;

  /// Clear the pool
  void clear() {
    if (_dispose != null) {
      for (final object in [..._available, ..._inUse]) {
        _dispose!(object);
      }
    }
    _available.clear();
    _inUse.clear();
  }
}

/// A component pool specifically for Flame components
class ComponentPool<T extends Component> {
  /// The underlying object pool
  final ObjectPool<T> _pool;

  /// Constructor
  ComponentPool({
    required T Function() factory,
    void Function(T)? reset,
    int initialSize = 0,
    int maxSize = 100,
  }) : _pool = ObjectPool<T>(
          factory: factory,
          reset: (component) {
            if (component.isMounted) {
              component.removeFromParent();
            }
            if (reset != null) {
              reset(component);
            }
          },
          dispose: (component) {
            if (component.isMounted) {
              component.removeFromParent();
            }
          },
          initialSize: initialSize,
          maxSize: maxSize,
        );

  /// Get a component from the pool
  T get() => _pool.get();

  /// Return a component to the pool
  void release(T component) => _pool.release(component);

  /// Get the number of components in use
  int get inUseCount => _pool.inUseCount;

  /// Get the number of available components
  int get availableCount => _pool.availableCount;

  /// Get the total number of components in the pool
  int get totalCount => _pool.totalCount;

  /// Clear the pool
  void clear() => _pool.clear();
}
