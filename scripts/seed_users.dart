// Script temporal para crear usuarios de prueba en Firestore
// Ejecutar con: dart run scripts/seed_users.dart
// NOTA: Este script no funciona directo, necesitamos crearlo desde la web o Firebase Console

// Crear estos 2 documentos en Firestore > coleccion "users":

// Documento 1 (Admin):
// {
//   "email": "alexisquionez21@gmail.com",
//   "name": "Alexis Admin",
//   "role": "admin",
//   "companyId": null,
//   "venueId": null,
//   "isActive": true,
//   "date_birthday": "",
//   "photo_profile_url": "",
//   "created_at": <timestamp>,
//   "updated_at": <timestamp>
// }

// Documento 2 (Cajero):
// {
//   "email": "cajero001@yopmail.com",
//   "name": "Cajero Test",
//   "role": "cashier",
//   "companyId": null,
//   "venueId": null,
//   "isActive": true,
//   "date_birthday": "",
//   "photo_profile_url": "",
//   "created_at": <timestamp>,
//   "updated_at": <timestamp>
// }
