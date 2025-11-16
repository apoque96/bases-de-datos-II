db = db.getSiblingDB('pollo_sanjuanero');

// 1. Consultar rutas completadas
print("=== Rutas Completadas ===");
db.rutas_entrega.find({ estado: "completada" }).pretty();

// 2. Comentarios con calificación 5 estrellas
print("=== Comentarios 5 Estrellas ===");
db.comentarios_clientes.find({ calificacion: 5 }).pretty();

// 3. Fallas no resueltas
print("=== Fallas Pendientes ===");
db.historial_fallas.find({ resuelto: false }).pretty();

// 4. Rutas con más de 2 coordenadas (puntos de entrega)
print("=== Rutas con Múltiples Puntos ===");
db.rutas_entrega.find({
  "coordenadas.2": { $exists: true }
}).pretty();

// 5. Agregación: Promedio de calificaciones por cliente
print("=== Promedio de Calificaciones ===");
db.comentarios_clientes.aggregate([
  {
    $group: {
      _id: "$cliente_id",
      promedio_calificacion: { $avg: "$calificacion" },
      total_comentarios: { $sum: 1 }
    }
  },
  { $sort: { promedio_calificacion: -1 } }
]).toArray();