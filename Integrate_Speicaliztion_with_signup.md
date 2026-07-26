# ClinicHub Backend

## Specializations — Signup Integration (Flutter)

### Public Endpoint (no auth required)

**GET** `/api/v1/specializations/active`

Returns active specializations as a list of `{ id, arName }`. Use this to populate the specialization selection dropdown during signup.

### Response format

```json
{
  "succeeded": true,
  "statusCode": 200,
  "message": null,
  "data": [
    {
      "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
      "arName": "قلب وأوعية دموية"
    },
    {
      "id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
      "arName": "عظام"
    }
  ]
}
```

### Flutter usage

```dart
Future<List<Specialization>> fetchSpecializations() async {
  final response = await http.get(
    Uri.parse('https://your-api.com/api/v1/specializations/active'),
  );
  final body = jsonDecode(response.body);
  return (body['data'] as List)
      .map((e) => Specialization.fromJson(e))
      .toList();
}

class Specialization {
  final String id;
  final String arName;

  Specialization({required this.id, required this.arName});

  factory Specialization.fromJson(Map<String, dynamic> json) =>
      Specialization(
        id: json['id'] as String,
        arName: json['arName'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'arName': arName};
}
```

### Sending selected specialization during signup

The `id` from the selected specialization is sent in the signup request body:

```json
{
  "fullName": "...",
  "email": "...",
  "password": "...",
  "phoneNumber": "...",
  "specializationId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "userType": 1
}
```
