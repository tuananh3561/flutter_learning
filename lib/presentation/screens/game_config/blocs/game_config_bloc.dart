import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// ===== Events =====
abstract class GameConfigEvent extends Equatable {
  const GameConfigEvent();

  @override
  List<Object?> get props => [];
}

class LoadGameConfig extends GameConfigEvent {
  final String? configFilePath;

  const LoadGameConfig({this.configFilePath});

  @override
  List<Object?> get props => [configFilePath];
}

class UpdateGameConfig extends GameConfigEvent {
  final Map<String, dynamic> newConfigData;

  const UpdateGameConfig(this.newConfigData);

  @override
  List<Object> get props => [newConfigData];
}

class MoveComponent extends GameConfigEvent {
  final String section;
  final String? subsection;
  final String positionKey;
  final Map<String, dynamic> newPosition;

  const MoveComponent({
    required this.section,
    this.subsection,
    required this.positionKey,
    required this.newPosition,
  });

  @override
  List<Object?> get props => [section, subsection, positionKey, newPosition];
}

class ForcePreviewUpdate extends GameConfigEvent {}

class SaveGameConfig extends GameConfigEvent {}

// ===== States =====
abstract class GameConfigState extends Equatable {
  const GameConfigState();

  @override
  List<Object?> get props => [];
}

class GameConfigInitial extends GameConfigState {}

class GameConfigLoading extends GameConfigState {}

class GameConfigLoaded extends GameConfigState {
  final Map<String, dynamic> configData;
  final bool previewUpdated;

  const GameConfigLoaded(this.configData, {this.previewUpdated = false});

  GameConfigLoaded copyWith({
    Map<String, dynamic>? configData,
    bool? previewUpdated,
  }) {
    return GameConfigLoaded(
      configData ?? this.configData,
      previewUpdated: previewUpdated ?? this.previewUpdated,
    );
  }

  @override
  List<Object> get props => [configData, previewUpdated];
}

class GameConfigError extends GameConfigState {
  final String message;
  final StackTrace? stackTrace;

  const GameConfigError(this.message, {this.stackTrace});

  @override
  List<Object?> get props => [message, stackTrace];
}

class ComponentMoved extends GameConfigState {
  final Map<String, dynamic> configData;
  final String section;
  final String? subsection;
  final Map<String, dynamic> newPosition;

  const ComponentMoved({
    required this.configData,
    required this.section,
    this.subsection,
    required this.newPosition,
  });

  @override
  List<Object?> get props => [configData, section, subsection, newPosition];
}

class GameConfigSaved extends GameConfigState {}

// ===== BLoC =====
class GameConfigBloc extends Bloc<GameConfigEvent, GameConfigState> {
  GameConfigBloc() : super(GameConfigInitial()) {
    on<LoadGameConfig>(_onLoadGameConfig);
    on<UpdateGameConfig>(_onUpdateGameConfig);
    on<MoveComponent>(_onMoveComponent);
    on<ForcePreviewUpdate>(_onForcePreviewUpdate);
    on<SaveGameConfig>(_onSaveGameConfig);
  }

  FutureOr<void> _onLoadGameConfig(
      LoadGameConfig event, Emitter<GameConfigState> emit) async {
    emit(GameConfigLoading());
    try {
      final String configPath =
          event.configFilePath ?? 'assets/Multiple Choice/game_config.json';
      final String jsonString = await rootBundle.loadString(configPath);
      final Map<String, dynamic> configData = json.decode(jsonString);

      emit(GameConfigLoaded(configData));
    } catch (e, stackTrace) {
      debugPrint('Error loading game config: $e\n$stackTrace');
      emit(GameConfigError('Lỗi khi tải cấu hình: ${e.toString()}',
          stackTrace: stackTrace));
    }
  }

  FutureOr<void> _onUpdateGameConfig(
      UpdateGameConfig event, Emitter<GameConfigState> emit) {
    try {
      if (state is GameConfigLoaded) {
        emit(GameConfigLoaded(event.newConfigData, previewUpdated: true));
      }
    } catch (e, stackTrace) {
      debugPrint('Error updating game config: $e\n$stackTrace');
      emit(GameConfigError('Lỗi khi cập nhật cấu hình: ${e.toString()}',
          stackTrace: stackTrace));
    }
  }

  FutureOr<void> _onMoveComponent(
      MoveComponent event, Emitter<GameConfigState> emit) {
    try {
      if (state is GameConfigLoaded) {
        final currentState = state as GameConfigLoaded;
        final updatedConfig = _updateComponentPosition(
          Map<String, dynamic>.from(currentState.configData),
          event.section,
          event.subsection,
          event.positionKey,
          event.newPosition,
        );

        emit(ComponentMoved(
          configData: updatedConfig,
          section: event.section,
          subsection: event.subsection,
          newPosition: event.newPosition,
        ));

        // Emit loaded state with updated config
        emit(GameConfigLoaded(updatedConfig, previewUpdated: true));
      }
    } catch (e, stackTrace) {
      debugPrint('Error moving component: $e\n$stackTrace');
      emit(GameConfigError('Lỗi khi di chuyển phần tử: ${e.toString()}',
          stackTrace: stackTrace));
    }
  }

  Map<String, dynamic> _updateComponentPosition(
    Map<String, dynamic> configData,
    String section,
    String? subsection,
    String positionKey,
    Map<String, dynamic> newPosition,
  ) {
    // Tạo bản sao của dữ liệu hiện tại để cập nhật
    final updatedData = Map<String, dynamic>.from(configData);
    var sectionData = updatedData[section];

    // Xử lý các trường hợp khác nhau dựa vào cấu trúc dữ liệu
    if (subsection == null) {
      // Trường hợp đơn giản: section/positionKey
      sectionData[positionKey] = newPosition;
    } else if (positionKey.contains('/')) {
      // Trường hợp phức tạp hơn: section/subsection/path/to/position
      var parts = positionKey.split('/');
      var current = sectionData[subsection];

      // Điều hướng đến vị trí cần cập nhật
      for (int i = 0; i < parts.length - 1; i++) {
        var part = parts[i];

        // Nếu là index của một mảng
        if (int.tryParse(part) != null) {
          int index = int.parse(part);
          if (current is List && index < current.length) {
            current = current[index];
          } else {
            throw Exception('Đường dẫn không hợp lệ: $positionKey');
          }
        } else {
          // Nếu là key của một map
          if (current is Map) {
            if (!current.containsKey(part)) {
              current[part] = {};
            }
            current = current[part];
          } else {
            throw Exception('Đường dẫn không hợp lệ: $positionKey tại $part');
          }
        }
      }

      // Cập nhật vị trí
      var finalKey = parts.last;
      if (int.tryParse(finalKey) != null) {
        // Nếu là index của một mảng
        int index = int.parse(finalKey);
        if (current is List && index < current.length) {
          current[index] = newPosition;
        } else {
          throw Exception('Đường dẫn không hợp lệ: $positionKey');
        }
      } else {
        // Nếu là key của một map
        if (current is Map) {
          current[finalKey] = newPosition;
        } else {
          throw Exception('Đường dẫn không hợp lệ: $positionKey');
        }
      }
    } else {
      // Trường hợp section/subsection/positionKey
      sectionData[subsection][positionKey] = newPosition;
    }

    // Cập nhật lại dữ liệu với timestamp mới để đảm bảo Preview refresh
    updatedData['_lastUpdated'] = DateTime.now().millisecondsSinceEpoch;

    return updatedData;
  }

  FutureOr<void> _onForcePreviewUpdate(
      ForcePreviewUpdate event, Emitter<GameConfigState> emit) {
    try {
      if (state is GameConfigLoaded) {
        final currentState = state as GameConfigLoaded;
        final updatedConfig =
            Map<String, dynamic>.from(currentState.configData);

        // Thêm timestamp để đảm bảo rằng widget sẽ nhận ra sự thay đổi
        updatedConfig['_lastUpdated'] = DateTime.now().millisecondsSinceEpoch;

        emit(GameConfigLoaded(updatedConfig, previewUpdated: true));
      }
    } catch (e, stackTrace) {
      debugPrint('Error forcing preview update: $e\n$stackTrace');
      emit(GameConfigError('Lỗi khi cập nhật preview: ${e.toString()}',
          stackTrace: stackTrace));
    }
  }

  FutureOr<void> _onSaveGameConfig(
      SaveGameConfig event, Emitter<GameConfigState> emit) async {
    try {
      if (state is GameConfigLoaded) {
        // Ở đây sẽ là logic lưu file vào disk hoặc API
        // Trong trường hợp demo chỉ emit state đã lưu
        emit(GameConfigSaved());

        // Trả về state loaded sau khi lưu
        final currentConfig = (state as GameConfigLoaded).configData;
        emit(GameConfigLoaded(currentConfig));
      }
    } catch (e, stackTrace) {
      debugPrint('Error saving game config: $e\n$stackTrace');
      emit(GameConfigError('Lỗi khi lưu cấu hình: ${e.toString()}',
          stackTrace: stackTrace));
    }
  }
}
