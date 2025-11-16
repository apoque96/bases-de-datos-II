db = db.getSiblingDB('pollo_sanjuanero');

//Schema validation para rutas_entrega
db.createCollection("rutas_entrega", {
    validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "fecha", "conductor", "vehiculo", "coordenadas", "estado"],
      properties: {
        _id: { bsonType: "string" },
        fecha: { bsonType: "string" },
        conductor: { bsonType: "string" },
        vehiculo: { bsonType: "string" },
        coordenadas: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["lat", "lon", "hora"],
            properties: {
              lat: { bsonType: "double" },
              lon: { bsonType: "double" },
              hora: { bsonType: "string" }
            }
          }
        },
        estado: { enum: ["pendiente", "en_proceso", "completada", "cancelada"] }
      }
    }
  }
});

//Schema Validation para comentarios_clientes
db.createCollection("comentarios_clientes", {
    validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "cliente_id", "fecha", "comentario", "calificacion"],
      properties: {
        _id: { bsonType: "string" },
        cliente_id: { bsonType: "string" },
        fecha: { bsonType: "string" },
        comentario: { bsonType: "string" },
        calificacion: { bsonType: "int", minimum: 1, maximum: 5 }
      }
    }
  }
});

//Schema Validation para historial_fallas
db.createCollection("historial_fallas",{
    validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "fecha_reporte", "area", "descripcion", "resuelto"],
      properties: {
        _id: { bsonType: "string" },
        fecha_reporte: { bsonType: "string" },
        area: { bsonType: "string" },
        descripcion: { bsonType: "string" },
        resuelto: { bsonType: "bool" }
      }
    }
  }
});