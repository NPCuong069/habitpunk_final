// Assuming your SubscriptionOption model is something like this
class SubscriptionOption {
  final String duration;
  final String price;
  final String benefits;
  final int gemCap;
  final int mysticHourglass;

  SubscriptionOption({
    required this.duration,
    required this.price,
    required this.benefits,
    required this.gemCap,
    required this.mysticHourglass,
  });
}

// Mock list of subscription options
List<SubscriptionOption> subscriptionOptions = [
  SubscriptionOption(
    duration: '1 Month Subscription',
    price: '109.000 đ',
    benefits: '25 Gem cap',
    gemCap: 25,
    mysticHourglass: 0,
  ),
  SubscriptionOption(
    duration: '3 Months Subscription',
    price: '299.000 đ',
    benefits: '50 Gem cap + 1 Mystic Hourglass',
    gemCap: 50,
    mysticHourglass: 1,
  ),
  SubscriptionOption(
    duration: '6 Months Subscription',
    price: '549.000 đ',
    benefits: '100 Gem cap + 3 Mystic Hourglasses',
    gemCap: 100,
    mysticHourglass: 3,
  ),
  SubscriptionOption(
    duration: '12 Months Subscription',
    price: '999.000 đ',
    benefits: '200 Gem cap + 5 Mystic Hourglasses',
    gemCap: 200,
    mysticHourglass: 5,
  ),
  // You can add as many as you need following the same pattern
];
