import 'package:finan_master_app/features/category/domain/enums/category_type_enum.dart';
import 'package:finan_master_app/features/category/infra/data_sources/i_category_local_data_source.dart';
import 'package:finan_master_app/features/category/infra/models/category_model.dart';
import 'package:finan_master_app/shared/classes/constants.dart';
import 'package:finan_master_app/shared/infra/data_sources/constants/tables_names_constant.dart';
import 'package:finan_master_app/shared/infra/data_sources/database_local/i_database_local_batch.dart';
import 'package:finan_master_app/shared/infra/data_sources/local_data_source.dart';
import 'package:finan_master_app/shared/infra/models/model.dart';
import 'package:finan_master_app/shared/presentation/ui/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CategoryLocalDataSource extends LocalDataSource<CategoryModel> implements ICategoryLocalDataSource {
  CategoryLocalDataSource({required super.databaseLocal});

  @override
  String get tableName => categoriesTableName;

  @override
  String get orderByDefault => 'description COLLATE NOCASE';

  @override
  void createTable(IDatabaseLocalBatch batch) {
    batch.execute('''
      CREATE TABLE $tableName (
        ${baseColumnsSql()},
        description TEXT NOT NULL,
        type INTEGER NOT NULL,
        color TEXT NOT NULL,
        icon INTEGER NOT NULL
      );
    ''');

    final String createdAt = DateTime.now().toIso8601String();

    batch.execute('''
      INSERT INTO $tableName (${Model.idColumnName}, ${Model.createdAtColumnName}, description, type, color, icon)
      VALUES
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categorySalary}', ${CategoryTypeEnum.income.value}, 'FF33B047', ${Icons.monetization_on_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryInvestments}', ${CategoryTypeEnum.income.value}, 'FF109089', ${Icons.trending_up_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryCashback}', ${CategoryTypeEnum.income.value}, 'FF98A31A', ${Icons.currency_exchange_outlined.codePoint}),
        ('$categoryOthersUuidIncome', '$createdAt', '${R.strings.categoryOthers}', ${CategoryTypeEnum.income.value}, 'FF626262', ${Icons.more_outlined.codePoint});
    ''');

    batch.execute('''
      INSERT INTO $tableName (${Model.idColumnName}, ${Model.createdAtColumnName}, description, type, color, icon)
      VALUES
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryHome}', ${CategoryTypeEnum.expense.value}, 'FF005BC0', ${Icons.home_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryServices}', ${CategoryTypeEnum.expense.value}, 'FF8200E9', ${Icons.handyman_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryGifts}', ${CategoryTypeEnum.expense.value}, 'FFE80000', ${Icons.card_giftcard_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryFuel}', ${CategoryTypeEnum.expense.value}, 'FFCF7C00', ${Icons.local_gas_station_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryLeisure}', ${CategoryTypeEnum.expense.value}, 'FF1C9687', ${Icons.beach_access_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryTravel}', ${CategoryTypeEnum.expense.value}, 'FF1178D8', ${Icons.airplane_ticket_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryTransport}', ${CategoryTypeEnum.expense.value}, 'FF7A7A7A', ${Icons.directions_bus_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryClothing}', ${CategoryTypeEnum.expense.value}, 'FF40977D', ${Icons.checkroom_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryMarket}', ${CategoryTypeEnum.expense.value}, 'FFFE4848', ${Icons.shopping_cart_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryEvents}', ${CategoryTypeEnum.expense.value}, 'FFB0BF00', ${Icons.festival_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryHealth}', ${CategoryTypeEnum.expense.value}, 'FF9D4141', ${Icons.medical_services_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryRestaurant}', ${CategoryTypeEnum.expense.value}, 'FFFE4848', ${Icons.fastfood_outlined.codePoint}),
        ('${const Uuid().v1()}', '$createdAt', '${R.strings.categoryEducation}', ${CategoryTypeEnum.expense.value}, 'FF374F51', ${Icons.school_outlined.codePoint}),
        ('$categoryOthersUuidExpense', '$createdAt', '${R.strings.categoryOthers}', ${CategoryTypeEnum.expense.value}, 'FF626262', ${Icons.more_outlined.codePoint}),
        ('$categoryBillUuidExpense', '$createdAt', '${R.strings.bill}', ${CategoryTypeEnum.expense.value}, 'FF46A66C', ${Icons.credit_score_outlined.codePoint});
    ''');
  }

  @override
  CategoryModel fromMap(Map<String, dynamic> map, {String prefix = ''}) {
    final ({DateTime? createdAt, DateTime? deletedAt, String id}) base = baseFromMap(map, prefix: prefix);

    return CategoryModel(
      id: base.id,
      createdAt: base.createdAt,
      deletedAt: base.deletedAt,
      description: map['${prefix}description'],
      type: CategoryTypeEnum.getByValue(map['${prefix}type'])!,
      color: map['${prefix}color'],
      icon: map['${prefix}icon'],
    );
  }
}
