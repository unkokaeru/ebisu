// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_organization_log_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyOrganizationLogCollection on Isar {
  IsarCollection<DailyOrganizationLog> get dailyOrganizationLogs =>
      this.collection();
}

const DailyOrganizationLogSchema = CollectionSchema(
  name: r'DailyOrganizationLog',
  id: -4529707891012928053,
  properties: {
    r'categoryId': PropertySchema(
      id: 0,
      name: r'categoryId',
      type: IsarType.long,
    ),
    r'completedLevel': PropertySchema(
      id: 1,
      name: r'completedLevel',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'isCarriedOver': PropertySchema(
      id: 3,
      name: r'isCarriedOver',
      type: IsarType.bool,
    )
  },
  estimateSize: _dailyOrganizationLogEstimateSize,
  serialize: _dailyOrganizationLogSerialize,
  deserialize: _dailyOrganizationLogDeserialize,
  deserializeProp: _dailyOrganizationLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'categoryId': IndexSchema(
      id: -8798048739239305339,
      name: r'categoryId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoryId',
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
  getId: _dailyOrganizationLogGetId,
  getLinks: _dailyOrganizationLogGetLinks,
  attach: _dailyOrganizationLogAttach,
  version: '3.1.0+1',
);

int _dailyOrganizationLogEstimateSize(
  DailyOrganizationLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dailyOrganizationLogSerialize(
  DailyOrganizationLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.categoryId);
  writer.writeLong(offsets[1], object.completedLevel);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeBool(offsets[3], object.isCarriedOver);
}

DailyOrganizationLog _dailyOrganizationLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyOrganizationLog();
  object.categoryId = reader.readLong(offsets[0]);
  object.completedLevel = reader.readLong(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.id = id;
  object.isCarriedOver = reader.readBool(offsets[3]);
  return object;
}

P _dailyOrganizationLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyOrganizationLogGetId(DailyOrganizationLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyOrganizationLogGetLinks(
    DailyOrganizationLog object) {
  return [];
}

void _dailyOrganizationLogAttach(
    IsarCollection<dynamic> col, Id id, DailyOrganizationLog object) {
  object.id = id;
}

extension DailyOrganizationLogQueryWhereSort
    on QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QWhere> {
  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhere>
      anyCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'categoryId'),
      );
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhere>
      anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyOrganizationLogQueryWhere
    on QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QWhereClause> {
  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      categoryIdEqualTo(int categoryId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'categoryId',
        value: [categoryId],
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      categoryIdNotEqualTo(int categoryId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [],
              upper: [categoryId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [categoryId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [categoryId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'categoryId',
              lower: [],
              upper: [categoryId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      categoryIdGreaterThan(
    int categoryId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [categoryId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      categoryIdLessThan(
    int categoryId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [],
        upper: [categoryId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      categoryIdBetween(
    int lowerCategoryId,
    int upperCategoryId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'categoryId',
        lower: [lowerCategoryId],
        includeLower: includeLower,
        upper: [upperCategoryId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterWhereClause>
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

extension DailyOrganizationLogQueryFilter on QueryBuilder<DailyOrganizationLog,
    DailyOrganizationLog, QFilterCondition> {
  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> categoryIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> categoryIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> categoryIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryId',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> categoryIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> completedLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> completedLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> completedLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> completedLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> dateBetween(
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog,
      QAfterFilterCondition> isCarriedOverEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCarriedOver',
        value: value,
      ));
    });
  }
}

extension DailyOrganizationLogQueryObject on QueryBuilder<DailyOrganizationLog,
    DailyOrganizationLog, QFilterCondition> {}

extension DailyOrganizationLogQueryLinks on QueryBuilder<DailyOrganizationLog,
    DailyOrganizationLog, QFilterCondition> {}

extension DailyOrganizationLogQuerySortBy
    on QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QSortBy> {
  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      sortByCompletedLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedLevel', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      sortByCompletedLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedLevel', Sort.desc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      sortByIsCarriedOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCarriedOver', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      sortByIsCarriedOverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCarriedOver', Sort.desc);
    });
  }
}

extension DailyOrganizationLogQuerySortThenBy
    on QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QSortThenBy> {
  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByCompletedLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedLevel', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByCompletedLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedLevel', Sort.desc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByIsCarriedOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCarriedOver', Sort.asc);
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QAfterSortBy>
      thenByIsCarriedOverDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCarriedOver', Sort.desc);
    });
  }
}

extension DailyOrganizationLogQueryWhereDistinct
    on QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QDistinct> {
  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QDistinct>
      distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QDistinct>
      distinctByCompletedLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedLevel');
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyOrganizationLog, DailyOrganizationLog, QDistinct>
      distinctByIsCarriedOver() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCarriedOver');
    });
  }
}

extension DailyOrganizationLogQueryProperty on QueryBuilder<
    DailyOrganizationLog, DailyOrganizationLog, QQueryProperty> {
  QueryBuilder<DailyOrganizationLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyOrganizationLog, int, QQueryOperations>
      categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<DailyOrganizationLog, int, QQueryOperations>
      completedLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedLevel');
    });
  }

  QueryBuilder<DailyOrganizationLog, DateTime, QQueryOperations>
      dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyOrganizationLog, bool, QQueryOperations>
      isCarriedOverProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCarriedOver');
    });
  }
}
