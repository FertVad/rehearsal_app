// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);

  static const VerificationMeta _idMeta = const VerificationMeta('id');
  static const VerificationMeta _createdAtUtcMeta =
      const VerificationMeta('createdAtUtc');
  static const VerificationMeta _updatedAtUtcMeta =
      const VerificationMeta('updatedAtUtc');
  static const VerificationMeta _deletedAtUtcMeta =
      const VerificationMeta('deletedAtUtc');
  static const VerificationMeta _lastWriterMeta =
      const VerificationMeta('lastWriter');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  static const VerificationMeta _tzMeta = const VerificationMeta('tz');

  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<int> deletedAtUtc = GeneratedColumn<int>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumn<String> lastWriter = GeneratedColumn<String>(
    'last_writer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumn<String> tz = GeneratedColumn<String>(
    'tz',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );

  @override
  List<GeneratedColumn> get $columns => [
        id,
        createdAtUtc,
        updatedAtUtc,
        deletedAtUtc,
        lastWriter,
        name,
        avatarUrl,
        tz
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';

  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(
          _idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
          _createdAtUtcMeta,
          createdAtUtc.isAcceptableOrUnknown(
              data['created_at_utc']!, _createdAtUtcMeta));
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
          _updatedAtUtcMeta,
          updatedAtUtc.isAcceptableOrUnknown(
              data['updated_at_utc']!, _updatedAtUtcMeta));
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
          _deletedAtUtcMeta,
          deletedAtUtc.isAcceptableOrUnknown(
              data['deleted_at_utc']!, _deletedAtUtcMeta));
    }
    if (data.containsKey('last_writer')) {
      context.handle(
          _lastWriterMeta,
          lastWriter.isAcceptableOrUnknown(
              data['last_writer']!, _lastWriterMeta));
    } else if (isInserting) {
      context.missing(_lastWriterMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
          _avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(
              data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('tz')) {
      context.handle(_tzMeta, tz.isAcceptableOrUnknown(data['tz']!, _tzMeta));
    } else if (isInserting) {
      context.missing(_tzMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}created_at_utc'])!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}updated_at_utc'])!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}deleted_at_utc']),
      lastWriter: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_writer'])!,
      name: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}name']),
      avatarUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      tz: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tz'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String? name;
  final String? avatarUrl;
  final String tz;
  const User({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    this.name,
    this.avatarUrl,
    required this.tz,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<int?>(deletedAtUtc);
    }
    map['last_writer'] = Variable<String>(lastWriter);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String?>(name);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String?>(avatarUrl);
    }
    map['tz'] = Variable<String>(tz);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      lastWriter: Value(lastWriter),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      tz: Value(tz),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<int>(json['updatedAtUtc']),
      deletedAtUtc: serializer.fromJson<int?>(json['deletedAtUtc']),
      lastWriter: serializer.fromJson<String>(json['lastWriter']),
      name: serializer.fromJson<String?>(json['name']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      tz: serializer.fromJson<String>(json['tz']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAtUtc': serializer.toJson<int>(createdAtUtc),
      'updatedAtUtc': serializer.toJson<int>(updatedAtUtc),
      'deletedAtUtc': serializer.toJson<int?>(deletedAtUtc),
      'lastWriter': serializer.toJson<String>(lastWriter),
      'name': serializer.toJson<String?>(name),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'tz': serializer.toJson<String>(tz),
    };
  }

  User copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    Value<int?> deletedAtUtc = const Value.absent(),
    String? lastWriter,
    Value<String?> name = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    String? tz,
  }) =>
      User(
        id: id ?? this.id,
        createdAtUtc: createdAtUtc ?? this.createdAtUtc,
        updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
        deletedAtUtc:
            deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
        lastWriter: lastWriter ?? this.lastWriter,
        name: name.present ? name.value : this.name,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        tz: tz ?? this.tz,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
      deletedAtUtc: data.deletedAtUtc.present
          ? data.deletedAtUtc.value
          : this.deletedAtUtc,
      lastWriter:
          data.lastWriter.present ? data.lastWriter.value : this.lastWriter,
      name: data.name.present ? data.name.value : this.name,
      avatarUrl:
          data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      tz: data.tz.present ? data.tz.value : this.tz,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('tz: $tz')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAtUtc, updatedAtUtc, deletedAtUtc,
      lastWriter, name, avatarUrl, tz);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.lastWriter == this.lastWriter &&
          other.name == this.name &&
          other.avatarUrl == this.avatarUrl &&
          other.tz == this.tz);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<int> createdAtUtc;
  final Value<int> updatedAtUtc;
  final Value<int?> deletedAtUtc;
  final Value<String> lastWriter;
  final Value<String?> name;
  final Value<String?> avatarUrl;
  final Value<String> tz;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.lastWriter = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.tz = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required int createdAtUtc,
    required int updatedAtUtc,
    Value<int?> deletedAtUtc = const Value.absent(),
    required String lastWriter,
    Value<String?> name = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    required String tz,
  })  : id = Value(id),
        createdAtUtc = Value(createdAtUtc),
        updatedAtUtc = Value(updatedAtUtc),
        deletedAtUtc = deletedAtUtc,
        lastWriter = Value(lastWriter),
        name = name,
        avatarUrl = avatarUrl,
        tz = Value(tz);

  static Insertable<User> custom({
    Expression<String>? id,
    Expression<int>? createdAtUtc,
    Expression<int>? updatedAtUtc,
    Expression<int>? deletedAtUtc,
    Expression<String>? lastWriter,
    Expression<String>? name,
    Expression<String>? avatarUrl,
    Expression<String>? tz,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (lastWriter != null) 'last_writer': lastWriter,
      if (name != null) 'name': name,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (tz != null) 'tz': tz,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAtUtc,
    Value<int>? updatedAtUtc,
    Value<int?>? deletedAtUtc,
    Value<String>? lastWriter,
    Value<String?>? name,
    Value<String?>? avatarUrl,
    Value<String>? tz,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tz: tz ?? this.tz,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<int>(updatedAtUtc.value);
    }
    if (deletedAtUtc.present) {
      map['deleted_at_utc'] = Variable<int?>(deletedAtUtc.value);
    }
    if (lastWriter.present) {
      map['last_writer'] = Variable<String>(lastWriter.value);
    }
    if (name.present) {
      map['name'] = Variable<String?>(name.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String?>(avatarUrl.value);
    }
    if (tz.present) {
      map['tz'] = Variable<String>(tz.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('tz: $tz')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => [users];
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users];
}
