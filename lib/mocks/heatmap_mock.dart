import 'dart:convert';

String mockedRiskGeoJson(){
    return jsonEncode({
  "type": "FeatureCollection",
  "features": [{
      "type": "Feature",
      "properties": { "risk": 10 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0612574, -10.9684319]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 1 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0731, -10.9472]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 2 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0725, -10.9465]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 3 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0718, -10.9459]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 5 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0705, -10.9448]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 4 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0691, -10.9432]
      }
    },

    // =========================
    // 🔥 PERTO DA UNIT (Aracaju)
    // Universidade Tiradentes
    // =========================
    {
      "type": "Feature",
      "properties": { "risk": 3 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0694, -10.9143]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 4 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0689, -10.9148]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 5 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0701, -10.9152]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 2 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0690, -10.9137]
      }
    },
    {
      "type": "Feature",
      "properties": { "risk": 3 },
      "geometry": {
        "type": "Point",
        "coordinates": [-37.0685, -10.9156]
      }
    },{
  "type": "Feature",
  "properties": { "risk": 3 },
  "geometry": {
    "type": "Point",
    "coordinates": [-37.0669, -10.9208]
  }
},
{
  "type": "Feature",
  "properties": { "risk": 4 },
  "geometry": {
    "type": "Point",
    "coordinates": [-37.0674, -10.9199]
  }
},
{
  "type": "Feature",
  "properties": { "risk": 2 },
  "geometry": {
    "type": "Point",
    "coordinates": [-37.0658, -10.9215]
  }
},
{
  "type": "Feature",
  "properties": { "risk": 5 },
  "geometry": {
    "type": "Point",
    "coordinates": [-37.0682, -10.9187]
  }
},
{
  "type": "Feature",
  "properties": { "risk": 3 },
  "geometry": {
    "type": "Point",
    "coordinates": [-37.0662, -10.9221]
  }
}
  ]
});
}