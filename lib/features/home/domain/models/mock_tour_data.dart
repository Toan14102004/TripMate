import '../models/tour_model.dart';

final List<TourModel> mockPackages = [
  TourModel(
    tourId: 1,
    title: 'Apanemo Resort',
    image: 'assets/images/apanemo.png',
    destination: 'East Evritania',
    rating: 4.9,
    reviewCount: 1200,
    price: 90,
  ),
  TourModel(
    tourId: 2,
    title: 'Laguna Resort',
    image: 'assets/images/laguna.png',
    destination: 'Santorini',
    rating: 4.7,
    reviewCount: 900,
    price: 90,
  ),
];

final List<TourModel> mockPopularPackages = [
  TourModel(
    tourId: 3,
    title: 'The Blue House',
    subtitle: '2 days 3 night full package',
    image: 'assets/images/blue_house.png',
    rating: 4.8,
    isBookmarked: false,
  ),
  TourModel(
    tourId: 4,
    title: 'Apanemo Resort',
    subtitle: '3 days 2 night full package',
    image: 'assets/images/apanemo.png',
    rating: 4.9,
    isBookmarked: true,
  ),
];

final List<TourModel> mockTopPackages = [
  TourModel(
    tourId: 5,
    title: 'Imperial Luxury Hotel',
    image: 'assets/images/luxury_hotel.png',
    destination: 'Queensland',
    rating: 4.9,
    reviewCount: 7200,
    price: 120,
  ),
  TourModel(
    tourId: 6,
    title: 'Walkabout Beach Hotel',
    image: 'assets/images/walkabout.png',
    destination: 'New Zealand',
    rating: 4.8,
    reviewCount: 6400,
    price: 100,
  ),
  TourModel(
    tourId: 7,
    title: 'Antlers Hilton Resort',
    image: 'assets/images/hilton.png',
    destination: 'Singapore',
    rating: 4.6,
    reviewCount: 3900,
    price: 100,
  ),
];