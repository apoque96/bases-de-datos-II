db = db.getSiblingDB('pollo_sanjuanero');

db.rutas_entrega.insertMany([
{
    "_id": "RUTA001",
    "fecha": "2025-10-30",
    "conductor": "Juan Pérez",
    "vehiculo": "Placas P123ABC",
    "coordenadas": [
      {"lat": 14.6349, "lon": -90.5069, "hora": "08:00"},
      {"lat": 14.6350, "lon": -90.5075, "hora": "08:30"}
    ],
    "estado": "completada"
  },
  {
    "_id": "RUTA002",
    "fecha": "2025-11-01",
    "conductor": "María García",
    "vehiculo": "Placas P456DEF",
    "coordenadas": [
      {"lat": 14.6320, "lon": -90.5090, "hora": "09:00"},
      {"lat": 14.6335, "lon": -90.5100, "hora": "09:45"}
    ],
    "estado": "en_proceso"
  }
]);

db.comentarios_clientes.insertMany([
{
    "_id": "COM001",
    "cliente_id": "CL001",
    "fecha": "2025-10-29",
    "comentario": "Excelente servicio, muy puntuales",
    "calificacion": 5
  },
  {
    "_id": "COM002",
    "cliente_id": "CL002",
    "fecha": "2025-10-30",
    "comentario": "Producto en buen estado pero con retraso",
    "calificacion": 3
  }
]);

db.historial_fallas.insertMany([
    {
    "_id": "FALLA001",
    "fecha_reporte": "2025-10-28",
    "area": "Transporte",
    "descripcion": "Falla en sistema de refrigeración del vehículo P123ABC",
    "resuelto": true
  },
  {
    "_id": "FALLA002",
    "fecha_reporte": "2025-10-31",
    "area": "Sistema",
    "descripcion": "Error en aplicación móvil de seguimiento",
    "resuelto": false
  }
]);