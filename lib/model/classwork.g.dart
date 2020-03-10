// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classwork.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassworkAdapter extends TypeAdapter<Classwork> {
  @override
  final typeId = 1;

  @override
  Classwork read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Classwork()
      ..isEveryWeekShow = fields[1] as bool
      ..subject = fields[2] as String
      ..teacher = fields[3] as String
      ..place = fields[4] as String
      ..startDate = fields[5] as DateTime
      ..finishDate = fields[6] as DateTime
      ..colorValue = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, Classwork obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isEveryWeekShow)
      ..writeByte(2)
      ..write(obj.subject)
      ..writeByte(3)
      ..write(obj.teacher)
      ..writeByte(4)
      ..write(obj.place)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.finishDate)
      ..writeByte(7)
      ..write(obj.colorValue);
  }
}
