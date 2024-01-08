import 'ProductQuantity.dart';
class Invoice {
  final int customerId;
  final List<ProductQuantity> products;

  Invoice({required this.customerId, required this.products});
}