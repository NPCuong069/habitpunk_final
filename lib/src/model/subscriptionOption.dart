// lib/src/model/subscription_option.dart

class SubscriptionOption {
  final String duration; // Represents the length of the subscription
  final String price;    // Represents the cost of the subscription

  SubscriptionOption({
    required this.duration,
    required this.price,
  });

  // Optionally, add a factory constructor for JSON parsing if you'll fetch these from an API
  factory SubscriptionOption.fromJson(Map<String, dynamic> json) {
    return SubscriptionOption(
      duration: json['duration'],
      price: json['price'],
    );
  }
}
// Still in lib/src/model/subscription_option.dart
List<SubscriptionOption> subscriptionOptions = [
  SubscriptionOption(
    duration: '1 Month',
    price: '5.99 USD',
  ),
  SubscriptionOption(
    duration: '3 Months',
    price: '15.99 USD',
  ),
  SubscriptionOption(
    duration: '6 Months',
    price: '29.99 USD',
  ),
  SubscriptionOption(
    duration: '1 Year',
    price: '54.99 USD',
  ),
];
