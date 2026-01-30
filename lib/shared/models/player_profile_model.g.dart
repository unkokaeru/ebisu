// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlayerProfileCollection on Isar {
  IsarCollection<PlayerProfile> get playerProfiles => this.collection();
}

const PlayerProfileSchema = CollectionSchema(
  name: r'PlayerProfile',
  id: -7715882953709164590,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentStreak': PropertySchema(
      id: 1,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'lastActiveDate': PropertySchema(
      id: 2,
      name: r'lastActiveDate',
      type: IsarType.dateTime,
    ),
    r'longestStreak': PropertySchema(
      id: 3,
      name: r'longestStreak',
      type: IsarType.long,
    ),
    r'playerName': PropertySchema(
      id: 4,
      name: r'playerName',
      type: IsarType.string,
    ),
    r'totalExperiencePoints': PropertySchema(
      id: 5,
      name: r'totalExperiencePoints',
      type: IsarType.long,
    ),
    r'totalRoutinesCompleted': PropertySchema(
      id: 6,
      name: r'totalRoutinesCompleted',
      type: IsarType.long,
    ),
    r'totalTasksCompleted': PropertySchema(
      id: 7,
      name: r'totalTasksCompleted',
      type: IsarType.long,
    ),
    r'urgentImportantTasksCompleted': PropertySchema(
      id: 8,
      name: r'urgentImportantTasksCompleted',
      type: IsarType.long,
    )
  },
  estimateSize: _playerProfileEstimateSize,
  serialize: _playerProfileSerialize,
  deserialize: _playerProfileDeserialize,
  deserializeProp: _playerProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _playerProfileGetId,
  getLinks: _playerProfileGetLinks,
  attach: _playerProfileAttach,
  version: '3.1.0+1',
);

int _playerProfileEstimateSize(
  PlayerProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.playerName.length * 3;
  return bytesCount;
}

void _playerProfileSerialize(
  PlayerProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.currentStreak);
  writer.writeDateTime(offsets[2], object.lastActiveDate);
  writer.writeLong(offsets[3], object.longestStreak);
  writer.writeString(offsets[4], object.playerName);
  writer.writeLong(offsets[5], object.totalExperiencePoints);
  writer.writeLong(offsets[6], object.totalRoutinesCompleted);
  writer.writeLong(offsets[7], object.totalTasksCompleted);
  writer.writeLong(offsets[8], object.urgentImportantTasksCompleted);
}

PlayerProfile _playerProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlayerProfile();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.currentStreak = reader.readLong(offsets[1]);
  object.id = id;
  object.lastActiveDate = reader.readDateTime(offsets[2]);
  object.longestStreak = reader.readLong(offsets[3]);
  object.playerName = reader.readString(offsets[4]);
  object.totalExperiencePoints = reader.readLong(offsets[5]);
  object.totalRoutinesCompleted = reader.readLong(offsets[6]);
  object.totalTasksCompleted = reader.readLong(offsets[7]);
  object.urgentImportantTasksCompleted = reader.readLong(offsets[8]);
  return object;
}

P _playerProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _playerProfileGetId(PlayerProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _playerProfileGetLinks(PlayerProfile object) {
  return [];
}

void _playerProfileAttach(
    IsarCollection<dynamic> col, Id id, PlayerProfile object) {
  object.id = id;
}

extension PlayerProfileQueryWhereSort
    on QueryBuilder<PlayerProfile, PlayerProfile, QWhere> {
  QueryBuilder<PlayerProfile, PlayerProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlayerProfileQueryWhere
    on QueryBuilder<PlayerProfile, PlayerProfile, QWhereClause> {
  QueryBuilder<PlayerProfile, PlayerProfile, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlayerProfileQueryFilter
    on QueryBuilder<PlayerProfile, PlayerProfile, QFilterCondition> {
  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      lastActiveDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastActiveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      lastActiveDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastActiveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      lastActiveDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastActiveDate',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      lastActiveDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastActiveDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      longestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      longestStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      longestStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longestStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      longestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longestStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'playerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'playerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'playerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'playerName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      playerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'playerName',
        value: '',
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalExperiencePointsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalExperiencePoints',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalExperiencePointsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalExperiencePoints',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalExperiencePointsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalExperiencePoints',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalExperiencePointsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalExperiencePoints',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalRoutinesCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalRoutinesCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalRoutinesCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalRoutinesCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalRoutinesCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalRoutinesCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalRoutinesCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalRoutinesCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalTasksCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalTasksCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalTasksCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      totalTasksCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalTasksCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      urgentImportantTasksCompletedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urgentImportantTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      urgentImportantTasksCompletedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'urgentImportantTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      urgentImportantTasksCompletedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'urgentImportantTasksCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterFilterCondition>
      urgentImportantTasksCompletedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'urgentImportantTasksCompleted',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PlayerProfileQueryObject
    on QueryBuilder<PlayerProfile, PlayerProfile, QFilterCondition> {}

extension PlayerProfileQueryLinks
    on QueryBuilder<PlayerProfile, PlayerProfile, QFilterCondition> {}

extension PlayerProfileQuerySortBy
    on QueryBuilder<PlayerProfile, PlayerProfile, QSortBy> {
  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByLastActiveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveDate', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByLastActiveDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveDate', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy> sortByPlayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByPlayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByTotalExperiencePoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExperiencePoints', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByTotalExperiencePointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExperiencePoints', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByTotalRoutinesCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRoutinesCompleted', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByTotalRoutinesCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRoutinesCompleted', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByTotalTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByTotalTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTasksCompleted', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByUrgentImportantTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urgentImportantTasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      sortByUrgentImportantTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urgentImportantTasksCompleted', Sort.desc);
    });
  }
}

extension PlayerProfileQuerySortThenBy
    on QueryBuilder<PlayerProfile, PlayerProfile, QSortThenBy> {
  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByLastActiveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveDate', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByLastActiveDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastActiveDate', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByLongestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longestStreak', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy> thenByPlayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByPlayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playerName', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByTotalExperiencePoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExperiencePoints', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByTotalExperiencePointsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExperiencePoints', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByTotalRoutinesCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRoutinesCompleted', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByTotalRoutinesCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalRoutinesCompleted', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByTotalTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByTotalTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalTasksCompleted', Sort.desc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByUrgentImportantTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urgentImportantTasksCompleted', Sort.asc);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QAfterSortBy>
      thenByUrgentImportantTasksCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urgentImportantTasksCompleted', Sort.desc);
    });
  }
}

extension PlayerProfileQueryWhereDistinct
    on QueryBuilder<PlayerProfile, PlayerProfile, QDistinct> {
  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct>
      distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct>
      distinctByLastActiveDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastActiveDate');
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct>
      distinctByLongestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longestStreak');
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct> distinctByPlayerName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct>
      distinctByTotalExperiencePoints() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalExperiencePoints');
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct>
      distinctByTotalRoutinesCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalRoutinesCompleted');
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct>
      distinctByTotalTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalTasksCompleted');
    });
  }

  QueryBuilder<PlayerProfile, PlayerProfile, QDistinct>
      distinctByUrgentImportantTasksCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'urgentImportantTasksCompleted');
    });
  }
}

extension PlayerProfileQueryProperty
    on QueryBuilder<PlayerProfile, PlayerProfile, QQueryProperty> {
  QueryBuilder<PlayerProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlayerProfile, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PlayerProfile, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<PlayerProfile, DateTime, QQueryOperations>
      lastActiveDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastActiveDate');
    });
  }

  QueryBuilder<PlayerProfile, int, QQueryOperations> longestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longestStreak');
    });
  }

  QueryBuilder<PlayerProfile, String, QQueryOperations> playerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playerName');
    });
  }

  QueryBuilder<PlayerProfile, int, QQueryOperations>
      totalExperiencePointsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalExperiencePoints');
    });
  }

  QueryBuilder<PlayerProfile, int, QQueryOperations>
      totalRoutinesCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalRoutinesCompleted');
    });
  }

  QueryBuilder<PlayerProfile, int, QQueryOperations>
      totalTasksCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalTasksCompleted');
    });
  }

  QueryBuilder<PlayerProfile, int, QQueryOperations>
      urgentImportantTasksCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'urgentImportantTasksCompleted');
    });
  }
}
