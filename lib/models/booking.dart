class Booking {
  String serviceId;
  String serviceName;
  int price;
  String userId;
  String userName;
  String userPhone;
  DateTime date;
  String time;
  String status;

  Booking({
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.date,
    required this.time,
    this.status = "Pending",
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'price': price,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'date': date,
      'time': time,
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      serviceId: map['serviceId'],
      serviceName: map['serviceName'],
      price: map['price'],
      userId: map['userId'],
      userName: map['userName'],
      userPhone: map['userPhone'],
      date: (map['date'] as DateTime),
      time: map['time'],
      status: map['status'] ?? "Pending",
    );
  }
}
