// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routine_completion_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRoutineCompletionCollection on Isar {
  IsarCollection<RoutineCompletion> get routineCompletions => this.collection();
}

const RoutineCompletionSchema = CollectionSchema(
  name: r'RoutineCompletion',
  id: 920255954042310274,
  properties: {
    r'completedItemIds': PropertySchema(
      id: 0,
      name: r'completedItemIds',
      type: IsarType.longList,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'isFullyCompleted': PropertySchema(
      id: 2,
      name: r'isFullyCompleted',
      type: IsarType.bool,
    ),
    r'routineType': PropertySchema(
      id: 3,
      name: r'routineType',
      type: IsarType.long,
    )
  },
  estimateSize: _routineCompletionEstimateSize,
  serialize: _routineCompletionSerialize,
  deserialize: _routineCompletionDeserialize,
  deserializeProp: _routineCompletionDeserializeProp,
  idName: r'id',
  indexes: {
    r'routineType': IndexSchema(
      id: -7501502620241745849,
      name: r'routineType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'routineType',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _routineCompletionGetId,
  getLinks: _routineCompletionGetLinks,
  attach: _routineCompletionAttach,
  version: '3.1.0+1',
);

int _routineCompletionEstimateSize(
  RoutineCompletion object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.completedItemIds.length * 8;
  return bytesCount;
}

void _routineCompletionSerialize(
  RoutineCompletion object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.completedItemIds);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeBool(offsets[2], object.isFullyCompleted);
  writer.writeLong(offsets[3], object.routineType);
}

RoutineCompletion _routineCompletionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RoutineCompletion();
  object.completedItemIds = reader.readLongList(offsets[0]) ?? [];
  object.date = reader.readDateTime(offsets[1]);
  object.id = id;
  object.isFullyCompleted = reader.readBool(offsets[2]);
  object.routineType = reader.readLong(offsets[3]);
  return object;
}

P _routineCompletionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _routineCompletionGetId(RoutineCompletion object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _routineCompletionGetLinks(
    RoutineCompletion object) {
  return [];
}

void _routineCompletionAttach(
    IsarCollection<dynamic> col, Id id, RoutineCompletion object) {
  object.id = id;
}

extension RoutineCompletionQueryWhereSort
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QWhere> {
  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhere>
      anyRoutineType() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'routineType'),
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension RoutineCompletionQueryWhere
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QWhereClause> {
  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      routineTypeEqualTo(int routineType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'routineType',
        value: [routineType],
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      routineTypeNotEqualTo(int routineType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'routineType',
              lower: [],
              upper: [routineType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'routineType',
              lower: [routineType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'routineType',
              lower: [routineType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'routineType',
              lower: [],
              upper: [routineType],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      routineTypeGreaterThan(
    int routineType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'routineType',
        lower: [routineType],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      routineTypeLessThan(
    int routineType, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'routineType',
        lower: [],
        upper: [routineType],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      routineTypeBetween(
    int lowerRoutineType,
    int upperRoutineType, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'routineType',
        lower: [lowerRoutineType],
        includeLower: includeLower,
        upper: [upperRoutineType],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterWhereClause>
      dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RoutineCompletionQueryFilter
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QFilterCondition> {
  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedItemIds',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedItemIds',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedItemIds',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedItemIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedItemIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedItemIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedItemIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedItemIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedItemIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      completedItemIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedItemIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
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

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      isFullyCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFullyCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      routineTypeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routineType',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      routineTypeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'routineType',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      routineTypeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'routineType',
        value: value,
      ));
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterFilterCondition>
      routineTypeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'routineType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RoutineCompletionQueryObject
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QFilterCondition> {}

extension RoutineCompletionQueryLinks
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QFilterCondition> {}

extension RoutineCompletionQuerySortBy
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QSortBy> {
  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      sortByIsFullyCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullyCompleted', Sort.asc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      sortByIsFullyCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullyCompleted', Sort.desc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      sortByRoutineType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineType', Sort.asc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      sortByRoutineTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineType', Sort.desc);
    });
  }
}

extension RoutineCompletionQuerySortThenBy
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QSortThenBy> {
  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      thenByIsFullyCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullyCompleted', Sort.asc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      thenByIsFullyCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFullyCompleted', Sort.desc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      thenByRoutineType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineType', Sort.asc);
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QAfterSortBy>
      thenByRoutineTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routineType', Sort.desc);
    });
  }
}

extension RoutineCompletionQueryWhereDistinct
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QDistinct> {
  QueryBuilder<RoutineCompletion, RoutineCompletion, QDistinct>
      distinctByCompletedItemIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedItemIds');
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QDistinct>
      distinctByIsFullyCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFullyCompleted');
    });
  }

  QueryBuilder<RoutineCompletion, RoutineCompletion, QDistinct>
      distinctByRoutineType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'routineType');
    });
  }
}

extension RoutineCompletionQueryProperty
    on QueryBuilder<RoutineCompletion, RoutineCompletion, QQueryProperty> {
  QueryBuilder<RoutineCompletion, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RoutineCompletion, List<int>, QQueryOperations>
      completedItemIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedItemIds');
    });
  }

  QueryBuilder<RoutineCompletion, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<RoutineCompletion, bool, QQueryOperations>
      isFullyCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFullyCompleted');
    });
  }

  QueryBuilder<RoutineCompletion, int, QQueryOperations> routineTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routineType');
    });
  }
}
