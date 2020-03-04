// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final typeId = 1;

  @override
  Task read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task()
      ..isEveryWeekShow = fields[1] as bool
      ..subject = fields[2] as String
      ..tutor = fields[3] as String
      ..place = fields[4] as String
      ..date = fields[5] as DateTime
      ..colorValue = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isEveryWeekShow)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.tutor)
      ..writeByte(4)
      ..write(obj.place)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.colorValue);
  }
}
