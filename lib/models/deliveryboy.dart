// To parse this JSON data, do
//
//     final deliveryBoy = deliveryBoyFromJson(jsonString);

import 'dart:convert';

DeliveryBoy deliveryBoyFromJson(String str) => DeliveryBoy.fromJson(json.decode(str));

class DeliveryBoy {
    DeliveryBoy({
        this.name,
        this.id,
        this.phone,
        this.count,
    });

    String name;
    String id;
    String phone;
    String count;

    factory DeliveryBoy.fromJson(Map<String, dynamic> json) => DeliveryBoy(
        name: json["name"],
        id: json["id"],
        phone: json["phone"],
        count: json["count"],
    );
}
