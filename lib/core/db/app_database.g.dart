// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtc = GeneratedColumn<int>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastWriterMeta = const VerificationMeta(
    'lastWriter',
  );
  @override
  late final GeneratedColumn<String> lastWriter = GeneratedColumn<String>(
    'last_writer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tzMeta = const VerificationMeta('tz');
  @override
  late final GeneratedColumn<String> tz = GeneratedColumn<String>(
    'tz',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    tz,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_writer')) {
      context.handle(
        _lastWriterMeta,
        lastWriter.isAcceptableOrUnknown(data['last_writer']!, _lastWriterMeta),
      );
    } else if (isInserting) {
      context.missing(_lastWriterMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('tz')) {
      context.handle(_tzMeta, tz.isAcceptableOrUnknown(data['tz']!, _tzMeta));
    } else if (isInserting) {
      context.missing(_tzMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      lastWriter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_writer'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      tz: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tz'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
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
  final String? metadata;
  const User({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    this.name,
    this.avatarUrl,
    required this.tz,
    this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc);
    }
    map['last_writer'] = Variable<String>(lastWriter);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['tz'] = Variable<String>(tz);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
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
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      metadata: serializer.fromJson<String?>(json['metadata']),
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
      'metadata': serializer.toJson<String?>(metadata),
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
    Value<String?> metadata = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    lastWriter: lastWriter ?? this.lastWriter,
    name: name.present ? name.value : this.name,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    tz: tz ?? this.tz,
    metadata: metadata.present ? metadata.value : this.metadata,
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
      lastWriter: data.lastWriter.present
          ? data.lastWriter.value
          : this.lastWriter,
      name: data.name.present ? data.name.value : this.name,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      tz: data.tz.present ? data.tz.value : this.tz,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
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
          ..write('tz: $tz, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    name,
    avatarUrl,
    tz,
    metadata,
  );
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
          other.tz == this.tz &&
          other.metadata == this.metadata);
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
  final Value<String?> metadata;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.lastWriter = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.tz = const Value.absent(),
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required int createdAtUtc,
    required int updatedAtUtc,
    this.deletedAtUtc = const Value.absent(),
    required String lastWriter,
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    required String tz,
    this.metadata = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc),
       lastWriter = Value(lastWriter),
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
    Expression<String>? metadata,
    Expression<int>? rowid,
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
      if (metadata != null) 'metadata': metadata,
      if (rowid != null) 'rowid': rowid,
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
    Value<String?>? metadata,
    Value<int>? rowid,
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
      metadata: metadata ?? this.metadata,
      rowid: rowid ?? this.rowid,
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
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc.value);
    }
    if (lastWriter.present) {
      map['last_writer'] = Variable<String>(lastWriter.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (tz.present) {
      map['tz'] = Variable<String>(tz.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
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
          ..write('tz: $tz, ')
          ..write('metadata: $metadata, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TroupesTable extends Troupes with TableInfo<$TroupesTable, Troupe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TroupesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtc = GeneratedColumn<int>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastWriterMeta = const VerificationMeta(
    'lastWriter',
  );
  @override
  late final GeneratedColumn<String> lastWriter = GeneratedColumn<String>(
    'last_writer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inviteCodeMeta = const VerificationMeta(
    'inviteCode',
  );
  @override
  late final GeneratedColumn<String> inviteCode = GeneratedColumn<String>(
    'invite_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    name,
    inviteCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'troupes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Troupe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_writer')) {
      context.handle(
        _lastWriterMeta,
        lastWriter.isAcceptableOrUnknown(data['last_writer']!, _lastWriterMeta),
      );
    } else if (isInserting) {
      context.missing(_lastWriterMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('invite_code')) {
      context.handle(
        _inviteCodeMeta,
        inviteCode.isAcceptableOrUnknown(data['invite_code']!, _inviteCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_inviteCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Troupe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Troupe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      lastWriter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_writer'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      inviteCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invite_code'],
      )!,
    );
  }

  @override
  $TroupesTable createAlias(String alias) {
    return $TroupesTable(attachedDatabase, alias);
  }
}

class Troupe extends DataClass implements Insertable<Troupe> {
  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String name;
  final String inviteCode;
  const Troupe({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    required this.name,
    required this.inviteCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc);
    }
    map['last_writer'] = Variable<String>(lastWriter);
    map['name'] = Variable<String>(name);
    map['invite_code'] = Variable<String>(inviteCode);
    return map;
  }

  TroupesCompanion toCompanion(bool nullToAbsent) {
    return TroupesCompanion(
      id: Value(id),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      lastWriter: Value(lastWriter),
      name: Value(name),
      inviteCode: Value(inviteCode),
    );
  }

  factory Troupe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Troupe(
      id: serializer.fromJson<String>(json['id']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<int>(json['updatedAtUtc']),
      deletedAtUtc: serializer.fromJson<int?>(json['deletedAtUtc']),
      lastWriter: serializer.fromJson<String>(json['lastWriter']),
      name: serializer.fromJson<String>(json['name']),
      inviteCode: serializer.fromJson<String>(json['inviteCode']),
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
      'name': serializer.toJson<String>(name),
      'inviteCode': serializer.toJson<String>(inviteCode),
    };
  }

  Troupe copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    Value<int?> deletedAtUtc = const Value.absent(),
    String? lastWriter,
    String? name,
    String? inviteCode,
  }) => Troupe(
    id: id ?? this.id,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    lastWriter: lastWriter ?? this.lastWriter,
    name: name ?? this.name,
    inviteCode: inviteCode ?? this.inviteCode,
  );
  Troupe copyWithCompanion(TroupesCompanion data) {
    return Troupe(
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
      lastWriter: data.lastWriter.present
          ? data.lastWriter.value
          : this.lastWriter,
      name: data.name.present ? data.name.value : this.name,
      inviteCode: data.inviteCode.present
          ? data.inviteCode.value
          : this.inviteCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Troupe(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('name: $name, ')
          ..write('inviteCode: $inviteCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    name,
    inviteCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Troupe &&
          other.id == this.id &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.lastWriter == this.lastWriter &&
          other.name == this.name &&
          other.inviteCode == this.inviteCode);
}

class TroupesCompanion extends UpdateCompanion<Troupe> {
  final Value<String> id;
  final Value<int> createdAtUtc;
  final Value<int> updatedAtUtc;
  final Value<int?> deletedAtUtc;
  final Value<String> lastWriter;
  final Value<String> name;
  final Value<String> inviteCode;
  final Value<int> rowid;
  const TroupesCompanion({
    this.id = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.lastWriter = const Value.absent(),
    this.name = const Value.absent(),
    this.inviteCode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TroupesCompanion.insert({
    required String id,
    required int createdAtUtc,
    required int updatedAtUtc,
    this.deletedAtUtc = const Value.absent(),
    required String lastWriter,
    required String name,
    required String inviteCode,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc),
       lastWriter = Value(lastWriter),
       name = Value(name),
       inviteCode = Value(inviteCode);
  static Insertable<Troupe> custom({
    Expression<String>? id,
    Expression<int>? createdAtUtc,
    Expression<int>? updatedAtUtc,
    Expression<int>? deletedAtUtc,
    Expression<String>? lastWriter,
    Expression<String>? name,
    Expression<String>? inviteCode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (lastWriter != null) 'last_writer': lastWriter,
      if (name != null) 'name': name,
      if (inviteCode != null) 'invite_code': inviteCode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TroupesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAtUtc,
    Value<int>? updatedAtUtc,
    Value<int?>? deletedAtUtc,
    Value<String>? lastWriter,
    Value<String>? name,
    Value<String>? inviteCode,
    Value<int>? rowid,
  }) {
    return TroupesCompanion(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      rowid: rowid ?? this.rowid,
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
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc.value);
    }
    if (lastWriter.present) {
      map['last_writer'] = Variable<String>(lastWriter.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (inviteCode.present) {
      map['invite_code'] = Variable<String>(inviteCode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TroupesCompanion(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('name: $name, ')
          ..write('inviteCode: $inviteCode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TroupeMembersTable extends TroupeMembers
    with TableInfo<$TroupeMembersTable, TroupeMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TroupeMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtc = GeneratedColumn<int>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastWriterMeta = const VerificationMeta(
    'lastWriter',
  );
  @override
  late final GeneratedColumn<String> lastWriter = GeneratedColumn<String>(
    'last_writer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _troupeIdMeta = const VerificationMeta(
    'troupeId',
  );
  @override
  late final GeneratedColumn<String> troupeId = GeneratedColumn<String>(
    'troupe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
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
    troupeId,
    userId,
    role,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'troupe_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<TroupeMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_writer')) {
      context.handle(
        _lastWriterMeta,
        lastWriter.isAcceptableOrUnknown(data['last_writer']!, _lastWriterMeta),
      );
    } else if (isInserting) {
      context.missing(_lastWriterMeta);
    }
    if (data.containsKey('troupe_id')) {
      context.handle(
        _troupeIdMeta,
        troupeId.isAcceptableOrUnknown(data['troupe_id']!, _troupeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_troupeIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TroupeMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TroupeMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      lastWriter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_writer'],
      )!,
      troupeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}troupe_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
    );
  }

  @override
  $TroupeMembersTable createAlias(String alias) {
    return $TroupeMembersTable(attachedDatabase, alias);
  }
}

class TroupeMember extends DataClass implements Insertable<TroupeMember> {
  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String troupeId;
  final String userId;
  final String role;
  const TroupeMember({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    required this.troupeId,
    required this.userId,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc);
    }
    map['last_writer'] = Variable<String>(lastWriter);
    map['troupe_id'] = Variable<String>(troupeId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    return map;
  }

  TroupeMembersCompanion toCompanion(bool nullToAbsent) {
    return TroupeMembersCompanion(
      id: Value(id),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      lastWriter: Value(lastWriter),
      troupeId: Value(troupeId),
      userId: Value(userId),
      role: Value(role),
    );
  }

  factory TroupeMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TroupeMember(
      id: serializer.fromJson<String>(json['id']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<int>(json['updatedAtUtc']),
      deletedAtUtc: serializer.fromJson<int?>(json['deletedAtUtc']),
      lastWriter: serializer.fromJson<String>(json['lastWriter']),
      troupeId: serializer.fromJson<String>(json['troupeId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
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
      'troupeId': serializer.toJson<String>(troupeId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
    };
  }

  TroupeMember copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    Value<int?> deletedAtUtc = const Value.absent(),
    String? lastWriter,
    String? troupeId,
    String? userId,
    String? role,
  }) => TroupeMember(
    id: id ?? this.id,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    lastWriter: lastWriter ?? this.lastWriter,
    troupeId: troupeId ?? this.troupeId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
  );
  TroupeMember copyWithCompanion(TroupeMembersCompanion data) {
    return TroupeMember(
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
      lastWriter: data.lastWriter.present
          ? data.lastWriter.value
          : this.lastWriter,
      troupeId: data.troupeId.present ? data.troupeId.value : this.troupeId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TroupeMember(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('troupeId: $troupeId, ')
          ..write('userId: $userId, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    troupeId,
    userId,
    role,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TroupeMember &&
          other.id == this.id &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.lastWriter == this.lastWriter &&
          other.troupeId == this.troupeId &&
          other.userId == this.userId &&
          other.role == this.role);
}

class TroupeMembersCompanion extends UpdateCompanion<TroupeMember> {
  final Value<String> id;
  final Value<int> createdAtUtc;
  final Value<int> updatedAtUtc;
  final Value<int?> deletedAtUtc;
  final Value<String> lastWriter;
  final Value<String> troupeId;
  final Value<String> userId;
  final Value<String> role;
  final Value<int> rowid;
  const TroupeMembersCompanion({
    this.id = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.lastWriter = const Value.absent(),
    this.troupeId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TroupeMembersCompanion.insert({
    required String id,
    required int createdAtUtc,
    required int updatedAtUtc,
    this.deletedAtUtc = const Value.absent(),
    required String lastWriter,
    required String troupeId,
    required String userId,
    required String role,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc),
       lastWriter = Value(lastWriter),
       troupeId = Value(troupeId),
       userId = Value(userId),
       role = Value(role);
  static Insertable<TroupeMember> custom({
    Expression<String>? id,
    Expression<int>? createdAtUtc,
    Expression<int>? updatedAtUtc,
    Expression<int>? deletedAtUtc,
    Expression<String>? lastWriter,
    Expression<String>? troupeId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (lastWriter != null) 'last_writer': lastWriter,
      if (troupeId != null) 'troupe_id': troupeId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TroupeMembersCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAtUtc,
    Value<int>? updatedAtUtc,
    Value<int?>? deletedAtUtc,
    Value<String>? lastWriter,
    Value<String>? troupeId,
    Value<String>? userId,
    Value<String>? role,
    Value<int>? rowid,
  }) {
    return TroupeMembersCompanion(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      troupeId: troupeId ?? this.troupeId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
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
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc.value);
    }
    if (lastWriter.present) {
      map['last_writer'] = Variable<String>(lastWriter.value);
    }
    if (troupeId.present) {
      map['troupe_id'] = Variable<String>(troupeId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TroupeMembersCompanion(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('troupeId: $troupeId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RehearsalsTable extends Rehearsals
    with TableInfo<$RehearsalsTable, Rehearsal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RehearsalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtc = GeneratedColumn<int>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastWriterMeta = const VerificationMeta(
    'lastWriter',
  );
  @override
  late final GeneratedColumn<String> lastWriter = GeneratedColumn<String>(
    'last_writer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _troupeIdMeta = const VerificationMeta(
    'troupeId',
  );
  @override
  late final GeneratedColumn<String> troupeId = GeneratedColumn<String>(
    'troupe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startsAtUtcMeta = const VerificationMeta(
    'startsAtUtc',
  );
  @override
  late final GeneratedColumn<int> startsAtUtc = GeneratedColumn<int>(
    'starts_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endsAtUtcMeta = const VerificationMeta(
    'endsAtUtc',
  );
  @override
  late final GeneratedColumn<int> endsAtUtc = GeneratedColumn<int>(
    'ends_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    troupeId,
    startsAtUtc,
    endsAtUtc,
    place,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rehearsals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rehearsal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_writer')) {
      context.handle(
        _lastWriterMeta,
        lastWriter.isAcceptableOrUnknown(data['last_writer']!, _lastWriterMeta),
      );
    } else if (isInserting) {
      context.missing(_lastWriterMeta);
    }
    if (data.containsKey('troupe_id')) {
      context.handle(
        _troupeIdMeta,
        troupeId.isAcceptableOrUnknown(data['troupe_id']!, _troupeIdMeta),
      );
    }
    if (data.containsKey('starts_at_utc')) {
      context.handle(
        _startsAtUtcMeta,
        startsAtUtc.isAcceptableOrUnknown(
          data['starts_at_utc']!,
          _startsAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startsAtUtcMeta);
    }
    if (data.containsKey('ends_at_utc')) {
      context.handle(
        _endsAtUtcMeta,
        endsAtUtc.isAcceptableOrUnknown(data['ends_at_utc']!, _endsAtUtcMeta),
      );
    } else if (isInserting) {
      context.missing(_endsAtUtcMeta);
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rehearsal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rehearsal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      lastWriter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_writer'],
      )!,
      troupeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}troupe_id'],
      ),
      startsAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}starts_at_utc'],
      )!,
      endsAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ends_at_utc'],
      )!,
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $RehearsalsTable createAlias(String alias) {
    return $RehearsalsTable(attachedDatabase, alias);
  }
}

class Rehearsal extends DataClass implements Insertable<Rehearsal> {
  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String? troupeId;
  final int startsAtUtc;
  final int endsAtUtc;
  final String? place;
  final String? note;
  const Rehearsal({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    this.troupeId,
    required this.startsAtUtc,
    required this.endsAtUtc,
    this.place,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc);
    }
    map['last_writer'] = Variable<String>(lastWriter);
    if (!nullToAbsent || troupeId != null) {
      map['troupe_id'] = Variable<String>(troupeId);
    }
    map['starts_at_utc'] = Variable<int>(startsAtUtc);
    map['ends_at_utc'] = Variable<int>(endsAtUtc);
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  RehearsalsCompanion toCompanion(bool nullToAbsent) {
    return RehearsalsCompanion(
      id: Value(id),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      lastWriter: Value(lastWriter),
      troupeId: troupeId == null && nullToAbsent
          ? const Value.absent()
          : Value(troupeId),
      startsAtUtc: Value(startsAtUtc),
      endsAtUtc: Value(endsAtUtc),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Rehearsal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rehearsal(
      id: serializer.fromJson<String>(json['id']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<int>(json['updatedAtUtc']),
      deletedAtUtc: serializer.fromJson<int?>(json['deletedAtUtc']),
      lastWriter: serializer.fromJson<String>(json['lastWriter']),
      troupeId: serializer.fromJson<String?>(json['troupeId']),
      startsAtUtc: serializer.fromJson<int>(json['startsAtUtc']),
      endsAtUtc: serializer.fromJson<int>(json['endsAtUtc']),
      place: serializer.fromJson<String?>(json['place']),
      note: serializer.fromJson<String?>(json['note']),
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
      'troupeId': serializer.toJson<String?>(troupeId),
      'startsAtUtc': serializer.toJson<int>(startsAtUtc),
      'endsAtUtc': serializer.toJson<int>(endsAtUtc),
      'place': serializer.toJson<String?>(place),
      'note': serializer.toJson<String?>(note),
    };
  }

  Rehearsal copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    Value<int?> deletedAtUtc = const Value.absent(),
    String? lastWriter,
    Value<String?> troupeId = const Value.absent(),
    int? startsAtUtc,
    int? endsAtUtc,
    Value<String?> place = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Rehearsal(
    id: id ?? this.id,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    lastWriter: lastWriter ?? this.lastWriter,
    troupeId: troupeId.present ? troupeId.value : this.troupeId,
    startsAtUtc: startsAtUtc ?? this.startsAtUtc,
    endsAtUtc: endsAtUtc ?? this.endsAtUtc,
    place: place.present ? place.value : this.place,
    note: note.present ? note.value : this.note,
  );
  Rehearsal copyWithCompanion(RehearsalsCompanion data) {
    return Rehearsal(
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
      lastWriter: data.lastWriter.present
          ? data.lastWriter.value
          : this.lastWriter,
      troupeId: data.troupeId.present ? data.troupeId.value : this.troupeId,
      startsAtUtc: data.startsAtUtc.present
          ? data.startsAtUtc.value
          : this.startsAtUtc,
      endsAtUtc: data.endsAtUtc.present ? data.endsAtUtc.value : this.endsAtUtc,
      place: data.place.present ? data.place.value : this.place,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rehearsal(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('troupeId: $troupeId, ')
          ..write('startsAtUtc: $startsAtUtc, ')
          ..write('endsAtUtc: $endsAtUtc, ')
          ..write('place: $place, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    troupeId,
    startsAtUtc,
    endsAtUtc,
    place,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rehearsal &&
          other.id == this.id &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.lastWriter == this.lastWriter &&
          other.troupeId == this.troupeId &&
          other.startsAtUtc == this.startsAtUtc &&
          other.endsAtUtc == this.endsAtUtc &&
          other.place == this.place &&
          other.note == this.note);
}

class RehearsalsCompanion extends UpdateCompanion<Rehearsal> {
  final Value<String> id;
  final Value<int> createdAtUtc;
  final Value<int> updatedAtUtc;
  final Value<int?> deletedAtUtc;
  final Value<String> lastWriter;
  final Value<String?> troupeId;
  final Value<int> startsAtUtc;
  final Value<int> endsAtUtc;
  final Value<String?> place;
  final Value<String?> note;
  final Value<int> rowid;
  const RehearsalsCompanion({
    this.id = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.lastWriter = const Value.absent(),
    this.troupeId = const Value.absent(),
    this.startsAtUtc = const Value.absent(),
    this.endsAtUtc = const Value.absent(),
    this.place = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RehearsalsCompanion.insert({
    required String id,
    required int createdAtUtc,
    required int updatedAtUtc,
    this.deletedAtUtc = const Value.absent(),
    required String lastWriter,
    this.troupeId = const Value.absent(),
    required int startsAtUtc,
    required int endsAtUtc,
    this.place = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc),
       lastWriter = Value(lastWriter),
       startsAtUtc = Value(startsAtUtc),
       endsAtUtc = Value(endsAtUtc);
  static Insertable<Rehearsal> custom({
    Expression<String>? id,
    Expression<int>? createdAtUtc,
    Expression<int>? updatedAtUtc,
    Expression<int>? deletedAtUtc,
    Expression<String>? lastWriter,
    Expression<String>? troupeId,
    Expression<int>? startsAtUtc,
    Expression<int>? endsAtUtc,
    Expression<String>? place,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (lastWriter != null) 'last_writer': lastWriter,
      if (troupeId != null) 'troupe_id': troupeId,
      if (startsAtUtc != null) 'starts_at_utc': startsAtUtc,
      if (endsAtUtc != null) 'ends_at_utc': endsAtUtc,
      if (place != null) 'place': place,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RehearsalsCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAtUtc,
    Value<int>? updatedAtUtc,
    Value<int?>? deletedAtUtc,
    Value<String>? lastWriter,
    Value<String?>? troupeId,
    Value<int>? startsAtUtc,
    Value<int>? endsAtUtc,
    Value<String?>? place,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return RehearsalsCompanion(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      troupeId: troupeId ?? this.troupeId,
      startsAtUtc: startsAtUtc ?? this.startsAtUtc,
      endsAtUtc: endsAtUtc ?? this.endsAtUtc,
      place: place ?? this.place,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
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
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc.value);
    }
    if (lastWriter.present) {
      map['last_writer'] = Variable<String>(lastWriter.value);
    }
    if (troupeId.present) {
      map['troupe_id'] = Variable<String>(troupeId.value);
    }
    if (startsAtUtc.present) {
      map['starts_at_utc'] = Variable<int>(startsAtUtc.value);
    }
    if (endsAtUtc.present) {
      map['ends_at_utc'] = Variable<int>(endsAtUtc.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RehearsalsCompanion(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('troupeId: $troupeId, ')
          ..write('startsAtUtc: $startsAtUtc, ')
          ..write('endsAtUtc: $endsAtUtc, ')
          ..write('place: $place, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RehearsalAttendeesTable extends RehearsalAttendees
    with TableInfo<$RehearsalAttendeesTable, RehearsalAttendee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RehearsalAttendeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtc = GeneratedColumn<int>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastWriterMeta = const VerificationMeta(
    'lastWriter',
  );
  @override
  late final GeneratedColumn<String> lastWriter = GeneratedColumn<String>(
    'last_writer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rehearsalIdMeta = const VerificationMeta(
    'rehearsalId',
  );
  @override
  late final GeneratedColumn<String> rehearsalId = GeneratedColumn<String>(
    'rehearsal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rsvpMeta = const VerificationMeta('rsvp');
  @override
  late final GeneratedColumn<String> rsvp = GeneratedColumn<String>(
    'rsvp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    rehearsalId,
    userId,
    role,
    rsvp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rehearsal_attendees';
  @override
  VerificationContext validateIntegrity(
    Insertable<RehearsalAttendee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_writer')) {
      context.handle(
        _lastWriterMeta,
        lastWriter.isAcceptableOrUnknown(data['last_writer']!, _lastWriterMeta),
      );
    } else if (isInserting) {
      context.missing(_lastWriterMeta);
    }
    if (data.containsKey('rehearsal_id')) {
      context.handle(
        _rehearsalIdMeta,
        rehearsalId.isAcceptableOrUnknown(
          data['rehearsal_id']!,
          _rehearsalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rehearsalIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('rsvp')) {
      context.handle(
        _rsvpMeta,
        rsvp.isAcceptableOrUnknown(data['rsvp']!, _rsvpMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RehearsalAttendee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RehearsalAttendee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      lastWriter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_writer'],
      )!,
      rehearsalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rehearsal_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      rsvp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rsvp'],
      ),
    );
  }

  @override
  $RehearsalAttendeesTable createAlias(String alias) {
    return $RehearsalAttendeesTable(attachedDatabase, alias);
  }
}

class RehearsalAttendee extends DataClass
    implements Insertable<RehearsalAttendee> {
  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String rehearsalId;
  final String userId;
  final String role;
  final String? rsvp;
  const RehearsalAttendee({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    required this.rehearsalId,
    required this.userId,
    required this.role,
    this.rsvp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc);
    }
    map['last_writer'] = Variable<String>(lastWriter);
    map['rehearsal_id'] = Variable<String>(rehearsalId);
    map['user_id'] = Variable<String>(userId);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || rsvp != null) {
      map['rsvp'] = Variable<String>(rsvp);
    }
    return map;
  }

  RehearsalAttendeesCompanion toCompanion(bool nullToAbsent) {
    return RehearsalAttendeesCompanion(
      id: Value(id),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      lastWriter: Value(lastWriter),
      rehearsalId: Value(rehearsalId),
      userId: Value(userId),
      role: Value(role),
      rsvp: rsvp == null && nullToAbsent ? const Value.absent() : Value(rsvp),
    );
  }

  factory RehearsalAttendee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RehearsalAttendee(
      id: serializer.fromJson<String>(json['id']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<int>(json['updatedAtUtc']),
      deletedAtUtc: serializer.fromJson<int?>(json['deletedAtUtc']),
      lastWriter: serializer.fromJson<String>(json['lastWriter']),
      rehearsalId: serializer.fromJson<String>(json['rehearsalId']),
      userId: serializer.fromJson<String>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      rsvp: serializer.fromJson<String?>(json['rsvp']),
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
      'rehearsalId': serializer.toJson<String>(rehearsalId),
      'userId': serializer.toJson<String>(userId),
      'role': serializer.toJson<String>(role),
      'rsvp': serializer.toJson<String?>(rsvp),
    };
  }

  RehearsalAttendee copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    Value<int?> deletedAtUtc = const Value.absent(),
    String? lastWriter,
    String? rehearsalId,
    String? userId,
    String? role,
    Value<String?> rsvp = const Value.absent(),
  }) => RehearsalAttendee(
    id: id ?? this.id,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    lastWriter: lastWriter ?? this.lastWriter,
    rehearsalId: rehearsalId ?? this.rehearsalId,
    userId: userId ?? this.userId,
    role: role ?? this.role,
    rsvp: rsvp.present ? rsvp.value : this.rsvp,
  );
  RehearsalAttendee copyWithCompanion(RehearsalAttendeesCompanion data) {
    return RehearsalAttendee(
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
      lastWriter: data.lastWriter.present
          ? data.lastWriter.value
          : this.lastWriter,
      rehearsalId: data.rehearsalId.present
          ? data.rehearsalId.value
          : this.rehearsalId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      rsvp: data.rsvp.present ? data.rsvp.value : this.rsvp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RehearsalAttendee(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('rehearsalId: $rehearsalId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('rsvp: $rsvp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    rehearsalId,
    userId,
    role,
    rsvp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RehearsalAttendee &&
          other.id == this.id &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.lastWriter == this.lastWriter &&
          other.rehearsalId == this.rehearsalId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.rsvp == this.rsvp);
}

class RehearsalAttendeesCompanion extends UpdateCompanion<RehearsalAttendee> {
  final Value<String> id;
  final Value<int> createdAtUtc;
  final Value<int> updatedAtUtc;
  final Value<int?> deletedAtUtc;
  final Value<String> lastWriter;
  final Value<String> rehearsalId;
  final Value<String> userId;
  final Value<String> role;
  final Value<String?> rsvp;
  final Value<int> rowid;
  const RehearsalAttendeesCompanion({
    this.id = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.lastWriter = const Value.absent(),
    this.rehearsalId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.rsvp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RehearsalAttendeesCompanion.insert({
    required String id,
    required int createdAtUtc,
    required int updatedAtUtc,
    this.deletedAtUtc = const Value.absent(),
    required String lastWriter,
    required String rehearsalId,
    required String userId,
    required String role,
    this.rsvp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc),
       lastWriter = Value(lastWriter),
       rehearsalId = Value(rehearsalId),
       userId = Value(userId),
       role = Value(role);
  static Insertable<RehearsalAttendee> custom({
    Expression<String>? id,
    Expression<int>? createdAtUtc,
    Expression<int>? updatedAtUtc,
    Expression<int>? deletedAtUtc,
    Expression<String>? lastWriter,
    Expression<String>? rehearsalId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<String>? rsvp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (lastWriter != null) 'last_writer': lastWriter,
      if (rehearsalId != null) 'rehearsal_id': rehearsalId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (rsvp != null) 'rsvp': rsvp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RehearsalAttendeesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAtUtc,
    Value<int>? updatedAtUtc,
    Value<int?>? deletedAtUtc,
    Value<String>? lastWriter,
    Value<String>? rehearsalId,
    Value<String>? userId,
    Value<String>? role,
    Value<String?>? rsvp,
    Value<int>? rowid,
  }) {
    return RehearsalAttendeesCompanion(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      rehearsalId: rehearsalId ?? this.rehearsalId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      rsvp: rsvp ?? this.rsvp,
      rowid: rowid ?? this.rowid,
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
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc.value);
    }
    if (lastWriter.present) {
      map['last_writer'] = Variable<String>(lastWriter.value);
    }
    if (rehearsalId.present) {
      map['rehearsal_id'] = Variable<String>(rehearsalId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rsvp.present) {
      map['rsvp'] = Variable<String>(rsvp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RehearsalAttendeesCompanion(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('rehearsalId: $rehearsalId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('rsvp: $rsvp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AvailabilitiesTable extends Availabilities
    with TableInfo<$AvailabilitiesTable, Availability> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvailabilitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  @override
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtUtcMeta = const VerificationMeta(
    'deletedAtUtc',
  );
  @override
  late final GeneratedColumn<int> deletedAtUtc = GeneratedColumn<int>(
    'deleted_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastWriterMeta = const VerificationMeta(
    'lastWriter',
  );
  @override
  late final GeneratedColumn<String> lastWriter = GeneratedColumn<String>(
    'last_writer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateUtcMeta = const VerificationMeta(
    'dateUtc',
  );
  @override
  late final GeneratedColumn<int> dateUtc = GeneratedColumn<int>(
    'date_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalsJsonMeta = const VerificationMeta(
    'intervalsJson',
  );
  @override
  late final GeneratedColumn<String> intervalsJson = GeneratedColumn<String>(
    'intervals_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    userId,
    dateUtc,
    status,
    intervalsJson,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'availabilities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Availability> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    if (data.containsKey('deleted_at_utc')) {
      context.handle(
        _deletedAtUtcMeta,
        deletedAtUtc.isAcceptableOrUnknown(
          data['deleted_at_utc']!,
          _deletedAtUtcMeta,
        ),
      );
    }
    if (data.containsKey('last_writer')) {
      context.handle(
        _lastWriterMeta,
        lastWriter.isAcceptableOrUnknown(data['last_writer']!, _lastWriterMeta),
      );
    } else if (isInserting) {
      context.missing(_lastWriterMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('date_utc')) {
      context.handle(
        _dateUtcMeta,
        dateUtc.isAcceptableOrUnknown(data['date_utc']!, _dateUtcMeta),
      );
    } else if (isInserting) {
      context.missing(_dateUtcMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('intervals_json')) {
      context.handle(
        _intervalsJsonMeta,
        intervalsJson.isAcceptableOrUnknown(
          data['intervals_json']!,
          _intervalsJsonMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Availability map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Availability(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
      deletedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at_utc'],
      ),
      lastWriter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_writer'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      dateUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_utc'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      intervalsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}intervals_json'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $AvailabilitiesTable createAlias(String alias) {
    return $AvailabilitiesTable(attachedDatabase, alias);
  }
}

class Availability extends DataClass implements Insertable<Availability> {
  final String id;
  final int createdAtUtc;
  final int updatedAtUtc;
  final int? deletedAtUtc;
  final String lastWriter;
  final String userId;
  final int dateUtc;
  final String status;
  final String? intervalsJson;
  final String? note;
  const Availability({
    required this.id,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    this.deletedAtUtc,
    required this.lastWriter,
    required this.userId,
    required this.dateUtc,
    required this.status,
    this.intervalsJson,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    if (!nullToAbsent || deletedAtUtc != null) {
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc);
    }
    map['last_writer'] = Variable<String>(lastWriter);
    map['user_id'] = Variable<String>(userId);
    map['date_utc'] = Variable<int>(dateUtc);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || intervalsJson != null) {
      map['intervals_json'] = Variable<String>(intervalsJson);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  AvailabilitiesCompanion toCompanion(bool nullToAbsent) {
    return AvailabilitiesCompanion(
      id: Value(id),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
      deletedAtUtc: deletedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAtUtc),
      lastWriter: Value(lastWriter),
      userId: Value(userId),
      dateUtc: Value(dateUtc),
      status: Value(status),
      intervalsJson: intervalsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalsJson),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Availability.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Availability(
      id: serializer.fromJson<String>(json['id']),
      createdAtUtc: serializer.fromJson<int>(json['createdAtUtc']),
      updatedAtUtc: serializer.fromJson<int>(json['updatedAtUtc']),
      deletedAtUtc: serializer.fromJson<int?>(json['deletedAtUtc']),
      lastWriter: serializer.fromJson<String>(json['lastWriter']),
      userId: serializer.fromJson<String>(json['userId']),
      dateUtc: serializer.fromJson<int>(json['dateUtc']),
      status: serializer.fromJson<String>(json['status']),
      intervalsJson: serializer.fromJson<String?>(json['intervalsJson']),
      note: serializer.fromJson<String?>(json['note']),
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
      'userId': serializer.toJson<String>(userId),
      'dateUtc': serializer.toJson<int>(dateUtc),
      'status': serializer.toJson<String>(status),
      'intervalsJson': serializer.toJson<String?>(intervalsJson),
      'note': serializer.toJson<String?>(note),
    };
  }

  Availability copyWith({
    String? id,
    int? createdAtUtc,
    int? updatedAtUtc,
    Value<int?> deletedAtUtc = const Value.absent(),
    String? lastWriter,
    String? userId,
    int? dateUtc,
    String? status,
    Value<String?> intervalsJson = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Availability(
    id: id ?? this.id,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
    deletedAtUtc: deletedAtUtc.present ? deletedAtUtc.value : this.deletedAtUtc,
    lastWriter: lastWriter ?? this.lastWriter,
    userId: userId ?? this.userId,
    dateUtc: dateUtc ?? this.dateUtc,
    status: status ?? this.status,
    intervalsJson: intervalsJson.present
        ? intervalsJson.value
        : this.intervalsJson,
    note: note.present ? note.value : this.note,
  );
  Availability copyWithCompanion(AvailabilitiesCompanion data) {
    return Availability(
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
      lastWriter: data.lastWriter.present
          ? data.lastWriter.value
          : this.lastWriter,
      userId: data.userId.present ? data.userId.value : this.userId,
      dateUtc: data.dateUtc.present ? data.dateUtc.value : this.dateUtc,
      status: data.status.present ? data.status.value : this.status,
      intervalsJson: data.intervalsJson.present
          ? data.intervalsJson.value
          : this.intervalsJson,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Availability(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('userId: $userId, ')
          ..write('dateUtc: $dateUtc, ')
          ..write('status: $status, ')
          ..write('intervalsJson: $intervalsJson, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAtUtc,
    updatedAtUtc,
    deletedAtUtc,
    lastWriter,
    userId,
    dateUtc,
    status,
    intervalsJson,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Availability &&
          other.id == this.id &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc &&
          other.deletedAtUtc == this.deletedAtUtc &&
          other.lastWriter == this.lastWriter &&
          other.userId == this.userId &&
          other.dateUtc == this.dateUtc &&
          other.status == this.status &&
          other.intervalsJson == this.intervalsJson &&
          other.note == this.note);
}

class AvailabilitiesCompanion extends UpdateCompanion<Availability> {
  final Value<String> id;
  final Value<int> createdAtUtc;
  final Value<int> updatedAtUtc;
  final Value<int?> deletedAtUtc;
  final Value<String> lastWriter;
  final Value<String> userId;
  final Value<int> dateUtc;
  final Value<String> status;
  final Value<String?> intervalsJson;
  final Value<String?> note;
  final Value<int> rowid;
  const AvailabilitiesCompanion({
    this.id = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.deletedAtUtc = const Value.absent(),
    this.lastWriter = const Value.absent(),
    this.userId = const Value.absent(),
    this.dateUtc = const Value.absent(),
    this.status = const Value.absent(),
    this.intervalsJson = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AvailabilitiesCompanion.insert({
    required String id,
    required int createdAtUtc,
    required int updatedAtUtc,
    this.deletedAtUtc = const Value.absent(),
    required String lastWriter,
    required String userId,
    required int dateUtc,
    required String status,
    this.intervalsJson = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc),
       lastWriter = Value(lastWriter),
       userId = Value(userId),
       dateUtc = Value(dateUtc),
       status = Value(status);
  static Insertable<Availability> custom({
    Expression<String>? id,
    Expression<int>? createdAtUtc,
    Expression<int>? updatedAtUtc,
    Expression<int>? deletedAtUtc,
    Expression<String>? lastWriter,
    Expression<String>? userId,
    Expression<int>? dateUtc,
    Expression<String>? status,
    Expression<String>? intervalsJson,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (deletedAtUtc != null) 'deleted_at_utc': deletedAtUtc,
      if (lastWriter != null) 'last_writer': lastWriter,
      if (userId != null) 'user_id': userId,
      if (dateUtc != null) 'date_utc': dateUtc,
      if (status != null) 'status': status,
      if (intervalsJson != null) 'intervals_json': intervalsJson,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AvailabilitiesCompanion copyWith({
    Value<String>? id,
    Value<int>? createdAtUtc,
    Value<int>? updatedAtUtc,
    Value<int?>? deletedAtUtc,
    Value<String>? lastWriter,
    Value<String>? userId,
    Value<int>? dateUtc,
    Value<String>? status,
    Value<String?>? intervalsJson,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return AvailabilitiesCompanion(
      id: id ?? this.id,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      deletedAtUtc: deletedAtUtc ?? this.deletedAtUtc,
      lastWriter: lastWriter ?? this.lastWriter,
      userId: userId ?? this.userId,
      dateUtc: dateUtc ?? this.dateUtc,
      status: status ?? this.status,
      intervalsJson: intervalsJson ?? this.intervalsJson,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
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
      map['deleted_at_utc'] = Variable<int>(deletedAtUtc.value);
    }
    if (lastWriter.present) {
      map['last_writer'] = Variable<String>(lastWriter.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (dateUtc.present) {
      map['date_utc'] = Variable<int>(dateUtc.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (intervalsJson.present) {
      map['intervals_json'] = Variable<String>(intervalsJson.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvailabilitiesCompanion(')
          ..write('id: $id, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('deletedAtUtc: $deletedAtUtc, ')
          ..write('lastWriter: $lastWriter, ')
          ..write('userId: $userId, ')
          ..write('dateUtc: $dateUtc, ')
          ..write('status: $status, ')
          ..write('intervalsJson: $intervalsJson, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, valueJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String valueJson;
  const Setting({required this.key, required this.valueJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), valueJson: Value(valueJson));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueJson': serializer.toJson<String>(valueJson),
    };
  }

  Setting copyWith({String? key, String? valueJson}) =>
      Setting(key: key ?? this.key, valueJson: valueJson ?? this.valueJson);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.valueJson == this.valueJson);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String valueJson,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       valueJson = Value(valueJson);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? valueJson,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $TroupesTable troupes = $TroupesTable(this);
  late final $TroupeMembersTable troupeMembers = $TroupeMembersTable(this);
  late final $RehearsalsTable rehearsals = $RehearsalsTable(this);
  late final $RehearsalAttendeesTable rehearsalAttendees =
      $RehearsalAttendeesTable(this);
  late final $AvailabilitiesTable availabilities = $AvailabilitiesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    troupes,
    troupeMembers,
    rehearsals,
    rehearsalAttendees,
    availabilities,
    settings,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required int createdAtUtc,
      required int updatedAtUtc,
      Value<int?> deletedAtUtc,
      required String lastWriter,
      Value<String?> name,
      Value<String?> avatarUrl,
      required String tz,
      Value<String?> metadata,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<int> createdAtUtc,
      Value<int> updatedAtUtc,
      Value<int?> deletedAtUtc,
      Value<String> lastWriter,
      Value<String?> name,
      Value<String?> avatarUrl,
      Value<String> tz,
      Value<String?> metadata,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tz => $composableBuilder(
    column: $table.tz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tz => $composableBuilder(
    column: $table.tz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get tz =>
      $composableBuilder(column: $table.tz, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
                Value<int?> deletedAtUtc = const Value.absent(),
                Value<String> lastWriter = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> tz = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                name: name,
                avatarUrl: avatarUrl,
                tz: tz,
                metadata: metadata,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAtUtc,
                required int updatedAtUtc,
                Value<int?> deletedAtUtc = const Value.absent(),
                required String lastWriter,
                Value<String?> name = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                required String tz,
                Value<String?> metadata = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                name: name,
                avatarUrl: avatarUrl,
                tz: tz,
                metadata: metadata,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$TroupesTableCreateCompanionBuilder =
    TroupesCompanion Function({
      required String id,
      required int createdAtUtc,
      required int updatedAtUtc,
      Value<int?> deletedAtUtc,
      required String lastWriter,
      required String name,
      required String inviteCode,
      Value<int> rowid,
    });
typedef $$TroupesTableUpdateCompanionBuilder =
    TroupesCompanion Function({
      Value<String> id,
      Value<int> createdAtUtc,
      Value<int> updatedAtUtc,
      Value<int?> deletedAtUtc,
      Value<String> lastWriter,
      Value<String> name,
      Value<String> inviteCode,
      Value<int> rowid,
    });

class $$TroupesTableFilterComposer
    extends Composer<_$AppDatabase, $TroupesTable> {
  $$TroupesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TroupesTableOrderingComposer
    extends Composer<_$AppDatabase, $TroupesTable> {
  $$TroupesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TroupesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TroupesTable> {
  $$TroupesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get inviteCode => $composableBuilder(
    column: $table.inviteCode,
    builder: (column) => column,
  );
}

class $$TroupesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TroupesTable,
          Troupe,
          $$TroupesTableFilterComposer,
          $$TroupesTableOrderingComposer,
          $$TroupesTableAnnotationComposer,
          $$TroupesTableCreateCompanionBuilder,
          $$TroupesTableUpdateCompanionBuilder,
          (Troupe, BaseReferences<_$AppDatabase, $TroupesTable, Troupe>),
          Troupe,
          PrefetchHooks Function()
        > {
  $$TroupesTableTableManager(_$AppDatabase db, $TroupesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TroupesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TroupesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TroupesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
                Value<int?> deletedAtUtc = const Value.absent(),
                Value<String> lastWriter = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> inviteCode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TroupesCompanion(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                name: name,
                inviteCode: inviteCode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAtUtc,
                required int updatedAtUtc,
                Value<int?> deletedAtUtc = const Value.absent(),
                required String lastWriter,
                required String name,
                required String inviteCode,
                Value<int> rowid = const Value.absent(),
              }) => TroupesCompanion.insert(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                name: name,
                inviteCode: inviteCode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TroupesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TroupesTable,
      Troupe,
      $$TroupesTableFilterComposer,
      $$TroupesTableOrderingComposer,
      $$TroupesTableAnnotationComposer,
      $$TroupesTableCreateCompanionBuilder,
      $$TroupesTableUpdateCompanionBuilder,
      (Troupe, BaseReferences<_$AppDatabase, $TroupesTable, Troupe>),
      Troupe,
      PrefetchHooks Function()
    >;
typedef $$TroupeMembersTableCreateCompanionBuilder =
    TroupeMembersCompanion Function({
      required String id,
      required int createdAtUtc,
      required int updatedAtUtc,
      Value<int?> deletedAtUtc,
      required String lastWriter,
      required String troupeId,
      required String userId,
      required String role,
      Value<int> rowid,
    });
typedef $$TroupeMembersTableUpdateCompanionBuilder =
    TroupeMembersCompanion Function({
      Value<String> id,
      Value<int> createdAtUtc,
      Value<int> updatedAtUtc,
      Value<int?> deletedAtUtc,
      Value<String> lastWriter,
      Value<String> troupeId,
      Value<String> userId,
      Value<String> role,
      Value<int> rowid,
    });

class $$TroupeMembersTableFilterComposer
    extends Composer<_$AppDatabase, $TroupeMembersTable> {
  $$TroupeMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get troupeId => $composableBuilder(
    column: $table.troupeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TroupeMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $TroupeMembersTable> {
  $$TroupeMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get troupeId => $composableBuilder(
    column: $table.troupeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TroupeMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TroupeMembersTable> {
  $$TroupeMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get troupeId =>
      $composableBuilder(column: $table.troupeId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);
}

class $$TroupeMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TroupeMembersTable,
          TroupeMember,
          $$TroupeMembersTableFilterComposer,
          $$TroupeMembersTableOrderingComposer,
          $$TroupeMembersTableAnnotationComposer,
          $$TroupeMembersTableCreateCompanionBuilder,
          $$TroupeMembersTableUpdateCompanionBuilder,
          (
            TroupeMember,
            BaseReferences<_$AppDatabase, $TroupeMembersTable, TroupeMember>,
          ),
          TroupeMember,
          PrefetchHooks Function()
        > {
  $$TroupeMembersTableTableManager(_$AppDatabase db, $TroupeMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TroupeMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TroupeMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TroupeMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
                Value<int?> deletedAtUtc = const Value.absent(),
                Value<String> lastWriter = const Value.absent(),
                Value<String> troupeId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TroupeMembersCompanion(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                troupeId: troupeId,
                userId: userId,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAtUtc,
                required int updatedAtUtc,
                Value<int?> deletedAtUtc = const Value.absent(),
                required String lastWriter,
                required String troupeId,
                required String userId,
                required String role,
                Value<int> rowid = const Value.absent(),
              }) => TroupeMembersCompanion.insert(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                troupeId: troupeId,
                userId: userId,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TroupeMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TroupeMembersTable,
      TroupeMember,
      $$TroupeMembersTableFilterComposer,
      $$TroupeMembersTableOrderingComposer,
      $$TroupeMembersTableAnnotationComposer,
      $$TroupeMembersTableCreateCompanionBuilder,
      $$TroupeMembersTableUpdateCompanionBuilder,
      (
        TroupeMember,
        BaseReferences<_$AppDatabase, $TroupeMembersTable, TroupeMember>,
      ),
      TroupeMember,
      PrefetchHooks Function()
    >;
typedef $$RehearsalsTableCreateCompanionBuilder =
    RehearsalsCompanion Function({
      required String id,
      required int createdAtUtc,
      required int updatedAtUtc,
      Value<int?> deletedAtUtc,
      required String lastWriter,
      Value<String?> troupeId,
      required int startsAtUtc,
      required int endsAtUtc,
      Value<String?> place,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$RehearsalsTableUpdateCompanionBuilder =
    RehearsalsCompanion Function({
      Value<String> id,
      Value<int> createdAtUtc,
      Value<int> updatedAtUtc,
      Value<int?> deletedAtUtc,
      Value<String> lastWriter,
      Value<String?> troupeId,
      Value<int> startsAtUtc,
      Value<int> endsAtUtc,
      Value<String?> place,
      Value<String?> note,
      Value<int> rowid,
    });

class $$RehearsalsTableFilterComposer
    extends Composer<_$AppDatabase, $RehearsalsTable> {
  $$RehearsalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get troupeId => $composableBuilder(
    column: $table.troupeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startsAtUtc => $composableBuilder(
    column: $table.startsAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endsAtUtc => $composableBuilder(
    column: $table.endsAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RehearsalsTableOrderingComposer
    extends Composer<_$AppDatabase, $RehearsalsTable> {
  $$RehearsalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get troupeId => $composableBuilder(
    column: $table.troupeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startsAtUtc => $composableBuilder(
    column: $table.startsAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endsAtUtc => $composableBuilder(
    column: $table.endsAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RehearsalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RehearsalsTable> {
  $$RehearsalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get troupeId =>
      $composableBuilder(column: $table.troupeId, builder: (column) => column);

  GeneratedColumn<int> get startsAtUtc => $composableBuilder(
    column: $table.startsAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endsAtUtc =>
      $composableBuilder(column: $table.endsAtUtc, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$RehearsalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RehearsalsTable,
          Rehearsal,
          $$RehearsalsTableFilterComposer,
          $$RehearsalsTableOrderingComposer,
          $$RehearsalsTableAnnotationComposer,
          $$RehearsalsTableCreateCompanionBuilder,
          $$RehearsalsTableUpdateCompanionBuilder,
          (
            Rehearsal,
            BaseReferences<_$AppDatabase, $RehearsalsTable, Rehearsal>,
          ),
          Rehearsal,
          PrefetchHooks Function()
        > {
  $$RehearsalsTableTableManager(_$AppDatabase db, $RehearsalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RehearsalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RehearsalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RehearsalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
                Value<int?> deletedAtUtc = const Value.absent(),
                Value<String> lastWriter = const Value.absent(),
                Value<String?> troupeId = const Value.absent(),
                Value<int> startsAtUtc = const Value.absent(),
                Value<int> endsAtUtc = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RehearsalsCompanion(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                troupeId: troupeId,
                startsAtUtc: startsAtUtc,
                endsAtUtc: endsAtUtc,
                place: place,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAtUtc,
                required int updatedAtUtc,
                Value<int?> deletedAtUtc = const Value.absent(),
                required String lastWriter,
                Value<String?> troupeId = const Value.absent(),
                required int startsAtUtc,
                required int endsAtUtc,
                Value<String?> place = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RehearsalsCompanion.insert(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                troupeId: troupeId,
                startsAtUtc: startsAtUtc,
                endsAtUtc: endsAtUtc,
                place: place,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RehearsalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RehearsalsTable,
      Rehearsal,
      $$RehearsalsTableFilterComposer,
      $$RehearsalsTableOrderingComposer,
      $$RehearsalsTableAnnotationComposer,
      $$RehearsalsTableCreateCompanionBuilder,
      $$RehearsalsTableUpdateCompanionBuilder,
      (Rehearsal, BaseReferences<_$AppDatabase, $RehearsalsTable, Rehearsal>),
      Rehearsal,
      PrefetchHooks Function()
    >;
typedef $$RehearsalAttendeesTableCreateCompanionBuilder =
    RehearsalAttendeesCompanion Function({
      required String id,
      required int createdAtUtc,
      required int updatedAtUtc,
      Value<int?> deletedAtUtc,
      required String lastWriter,
      required String rehearsalId,
      required String userId,
      required String role,
      Value<String?> rsvp,
      Value<int> rowid,
    });
typedef $$RehearsalAttendeesTableUpdateCompanionBuilder =
    RehearsalAttendeesCompanion Function({
      Value<String> id,
      Value<int> createdAtUtc,
      Value<int> updatedAtUtc,
      Value<int?> deletedAtUtc,
      Value<String> lastWriter,
      Value<String> rehearsalId,
      Value<String> userId,
      Value<String> role,
      Value<String?> rsvp,
      Value<int> rowid,
    });

class $$RehearsalAttendeesTableFilterComposer
    extends Composer<_$AppDatabase, $RehearsalAttendeesTable> {
  $$RehearsalAttendeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rehearsalId => $composableBuilder(
    column: $table.rehearsalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rsvp => $composableBuilder(
    column: $table.rsvp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RehearsalAttendeesTableOrderingComposer
    extends Composer<_$AppDatabase, $RehearsalAttendeesTable> {
  $$RehearsalAttendeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rehearsalId => $composableBuilder(
    column: $table.rehearsalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rsvp => $composableBuilder(
    column: $table.rsvp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RehearsalAttendeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RehearsalAttendeesTable> {
  $$RehearsalAttendeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rehearsalId => $composableBuilder(
    column: $table.rehearsalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get rsvp =>
      $composableBuilder(column: $table.rsvp, builder: (column) => column);
}

class $$RehearsalAttendeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RehearsalAttendeesTable,
          RehearsalAttendee,
          $$RehearsalAttendeesTableFilterComposer,
          $$RehearsalAttendeesTableOrderingComposer,
          $$RehearsalAttendeesTableAnnotationComposer,
          $$RehearsalAttendeesTableCreateCompanionBuilder,
          $$RehearsalAttendeesTableUpdateCompanionBuilder,
          (
            RehearsalAttendee,
            BaseReferences<
              _$AppDatabase,
              $RehearsalAttendeesTable,
              RehearsalAttendee
            >,
          ),
          RehearsalAttendee,
          PrefetchHooks Function()
        > {
  $$RehearsalAttendeesTableTableManager(
    _$AppDatabase db,
    $RehearsalAttendeesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RehearsalAttendeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RehearsalAttendeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RehearsalAttendeesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
                Value<int?> deletedAtUtc = const Value.absent(),
                Value<String> lastWriter = const Value.absent(),
                Value<String> rehearsalId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> rsvp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RehearsalAttendeesCompanion(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                rehearsalId: rehearsalId,
                userId: userId,
                role: role,
                rsvp: rsvp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAtUtc,
                required int updatedAtUtc,
                Value<int?> deletedAtUtc = const Value.absent(),
                required String lastWriter,
                required String rehearsalId,
                required String userId,
                required String role,
                Value<String?> rsvp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RehearsalAttendeesCompanion.insert(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                rehearsalId: rehearsalId,
                userId: userId,
                role: role,
                rsvp: rsvp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RehearsalAttendeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RehearsalAttendeesTable,
      RehearsalAttendee,
      $$RehearsalAttendeesTableFilterComposer,
      $$RehearsalAttendeesTableOrderingComposer,
      $$RehearsalAttendeesTableAnnotationComposer,
      $$RehearsalAttendeesTableCreateCompanionBuilder,
      $$RehearsalAttendeesTableUpdateCompanionBuilder,
      (
        RehearsalAttendee,
        BaseReferences<
          _$AppDatabase,
          $RehearsalAttendeesTable,
          RehearsalAttendee
        >,
      ),
      RehearsalAttendee,
      PrefetchHooks Function()
    >;
typedef $$AvailabilitiesTableCreateCompanionBuilder =
    AvailabilitiesCompanion Function({
      required String id,
      required int createdAtUtc,
      required int updatedAtUtc,
      Value<int?> deletedAtUtc,
      required String lastWriter,
      required String userId,
      required int dateUtc,
      required String status,
      Value<String?> intervalsJson,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$AvailabilitiesTableUpdateCompanionBuilder =
    AvailabilitiesCompanion Function({
      Value<String> id,
      Value<int> createdAtUtc,
      Value<int> updatedAtUtc,
      Value<int?> deletedAtUtc,
      Value<String> lastWriter,
      Value<String> userId,
      Value<int> dateUtc,
      Value<String> status,
      Value<String?> intervalsJson,
      Value<String?> note,
      Value<int> rowid,
    });

class $$AvailabilitiesTableFilterComposer
    extends Composer<_$AppDatabase, $AvailabilitiesTable> {
  $$AvailabilitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateUtc => $composableBuilder(
    column: $table.dateUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get intervalsJson => $composableBuilder(
    column: $table.intervalsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AvailabilitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $AvailabilitiesTable> {
  $$AvailabilitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateUtc => $composableBuilder(
    column: $table.dateUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intervalsJson => $composableBuilder(
    column: $table.intervalsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AvailabilitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AvailabilitiesTable> {
  $$AvailabilitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAtUtc => $composableBuilder(
    column: $table.deletedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastWriter => $composableBuilder(
    column: $table.lastWriter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get dateUtc =>
      $composableBuilder(column: $table.dateUtc, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get intervalsJson => $composableBuilder(
    column: $table.intervalsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$AvailabilitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AvailabilitiesTable,
          Availability,
          $$AvailabilitiesTableFilterComposer,
          $$AvailabilitiesTableOrderingComposer,
          $$AvailabilitiesTableAnnotationComposer,
          $$AvailabilitiesTableCreateCompanionBuilder,
          $$AvailabilitiesTableUpdateCompanionBuilder,
          (
            Availability,
            BaseReferences<_$AppDatabase, $AvailabilitiesTable, Availability>,
          ),
          Availability,
          PrefetchHooks Function()
        > {
  $$AvailabilitiesTableTableManager(
    _$AppDatabase db,
    $AvailabilitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AvailabilitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AvailabilitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AvailabilitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
                Value<int?> deletedAtUtc = const Value.absent(),
                Value<String> lastWriter = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> dateUtc = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> intervalsJson = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilitiesCompanion(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                userId: userId,
                dateUtc: dateUtc,
                status: status,
                intervalsJson: intervalsJson,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int createdAtUtc,
                required int updatedAtUtc,
                Value<int?> deletedAtUtc = const Value.absent(),
                required String lastWriter,
                required String userId,
                required int dateUtc,
                required String status,
                Value<String?> intervalsJson = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AvailabilitiesCompanion.insert(
                id: id,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                deletedAtUtc: deletedAtUtc,
                lastWriter: lastWriter,
                userId: userId,
                dateUtc: dateUtc,
                status: status,
                intervalsJson: intervalsJson,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AvailabilitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AvailabilitiesTable,
      Availability,
      $$AvailabilitiesTableFilterComposer,
      $$AvailabilitiesTableOrderingComposer,
      $$AvailabilitiesTableAnnotationComposer,
      $$AvailabilitiesTableCreateCompanionBuilder,
      $$AvailabilitiesTableUpdateCompanionBuilder,
      (
        Availability,
        BaseReferences<_$AppDatabase, $AvailabilitiesTable, Availability>,
      ),
      Availability,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String valueJson,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> valueJson,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> valueJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                key: key,
                valueJson: valueJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String valueJson,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                valueJson: valueJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$TroupesTableTableManager get troupes =>
      $$TroupesTableTableManager(_db, _db.troupes);
  $$TroupeMembersTableTableManager get troupeMembers =>
      $$TroupeMembersTableTableManager(_db, _db.troupeMembers);
  $$RehearsalsTableTableManager get rehearsals =>
      $$RehearsalsTableTableManager(_db, _db.rehearsals);
  $$RehearsalAttendeesTableTableManager get rehearsalAttendees =>
      $$RehearsalAttendeesTableTableManager(_db, _db.rehearsalAttendees);
  $$AvailabilitiesTableTableManager get availabilities =>
      $$AvailabilitiesTableTableManager(_db, _db.availabilities);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
