import 'package:rehearsal_app/core/supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rehearsal_app/core/utils/logger.dart';

class SupabaseDataSource {
  static final SupabaseDataSource _instance = SupabaseDataSource._internal();
  factory SupabaseDataSource() => _instance;
  SupabaseDataSource._internal();

  /// Get Supabase client instance
  SupabaseClient get client => SupabaseConfig.client;

  /// Centralized logging for database operations
  void _logOperation(String operation, String table, {String? recordId, Map<String, dynamic>? data}) {
    Logger.repository(operation, table, recordId: recordId, data: data);
  }

  /// Generic select operation with common options
  Future<List<Map<String, dynamic>>> select({
    required String table,
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
    bool excludeDeleted = true,
  }) async {
    try {
      _logOperation('SELECT', table, data: filters);
      
      dynamic query = client.from(table).select(columns);

      // Apply filters
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      // Exclude soft deleted records by default
      if (excludeDeleted) {
        query = query.isFilter('deleted_at', null);
      }

      // Apply ordering
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      return await query;
    } catch (e) {
      _logOperation('SELECT ERROR', table, data: filters);
      rethrow;
    }
  }

  /// Get single record by ID
  Future<Map<String, dynamic>?> selectById({
    required String table,
    required String id,
    String columns = '*',
    bool excludeDeleted = true,
  }) async {
    try {
      _logOperation('SELECT_BY_ID', table, recordId: id);
      
      var query = client.from(table).select(columns).eq('id', id);

      if (excludeDeleted) {
        query = query.isFilter('deleted_at', null);
      }

      return await query.maybeSingle();
    } catch (e) {
      _logOperation('SELECT_BY_ID ERROR', table, recordId: id);
      rethrow;
    }
  }

  /// Generic insert operation
  Future<Map<String, dynamic>> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      _logOperation('INSERT', table, data: data);
      
      // Add timestamps automatically
      final insertData = {
        ...data,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      return await client
          .from(table)
          .insert(insertData)
          .select()
          .single();
    } catch (e) {
      _logOperation('INSERT ERROR', table, data: data);
      rethrow;
    }
  }

  /// Generic update operation
  Future<Map<String, dynamic>?> update({
    required String table,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      _logOperation('UPDATE', table, recordId: id, data: data);
      
      // Add updated timestamp automatically
      final updateData = {
        ...data,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      return await client
          .from(table)
          .update(updateData)
          .eq('id', id)
          .select()
          .maybeSingle();
    } catch (e) {
      _logOperation('UPDATE ERROR', table, recordId: id, data: data);
      rethrow;
    }
  }

  /// Soft delete operation
  Future<void> softDelete({
    required String table,
    required String id,
  }) async {
    try {
      _logOperation('SOFT_DELETE', table, recordId: id);
      
      final now = DateTime.now().toUtc().toIso8601String();
      await client
          .from(table)
          .update({
            'deleted_at': now,
            'updated_at': now,
          })
          .eq('id', id);
    } catch (e) {
      _logOperation('SOFT_DELETE ERROR', table, recordId: id);
      rethrow;
    }
  }


  /// Upsert operation
  Future<Map<String, dynamic>> upsert({
    required String table,
    required Map<String, dynamic> data,
    String? onConflict,
  }) async {
    try {
      _logOperation('UPSERT', table, data: data);
      
      final now = DateTime.now().toUtc().toIso8601String();
      final upsertData = {
        ...data,
        'updated_at': now,
      };

      // Add created_at only if it's not already present (for updates)
      if (!data.containsKey('created_at')) {
        upsertData['created_at'] = now;
      }

      return await client
          .from(table)
          .upsert(
            upsertData,
            onConflict: onConflict,
          )
          .select()
          .single();
    } catch (e) {
      _logOperation('UPSERT ERROR', table, data: data);
      rethrow;
    }
  }

  /// Get current authenticated user
  User? get currentUser => client.auth.currentUser;

  /// Get current user ID
  String? get currentUserId => client.auth.currentUser?.id;


  /// Count records in table
  Future<int> count({
    required String table,
    Map<String, dynamic>? filters,
    bool excludeDeleted = true,
  }) async {
    try {
      _logOperation('COUNT', table, data: filters);
      
      dynamic query = client.from(table).select('id');

      // Apply filters
      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      // Exclude soft deleted records by default
      if (excludeDeleted) {
        query = query.isFilter('deleted_at', null);
      }

      final response = await query;
      return (response as List).length;
    } catch (e) {
      _logOperation('COUNT ERROR', table, data: filters);
      rethrow;
    }
  }

}