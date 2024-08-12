import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/base_model.dart';

extension QueryExtension<T extends BaseModel> on Query<T> {
  Query<T> whereCreatedAfter(DateTime date) {
    return where('createdAt', isGreaterThan: date);
  }

  Query<T> whereCreatedBefore(DateTime date) {
    return where('createdAt', isLessThan: date);
  }

  Query<T> whereUpdatedAfter(DateTime date) {
    return where('updatedAt', isGreaterThan: date);
  }

  Query<T> whereUpdatedBefore(DateTime date) {
    return where('updatedAt', isLessThan: date);
  }

  Query<T> orderByCreatedAt({bool descending = false}) {
    return orderBy('createdAt', descending: descending);
  }

  Query<T> orderByUpdatedAt({bool descending = false}) {
    return orderBy('updatedAt', descending: descending);
  }

  Query<T> orderById({bool descending = false}) {
    return orderBy('id', descending: descending);
  }
}
