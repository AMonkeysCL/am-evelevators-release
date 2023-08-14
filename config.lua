

---[Hecho por AMonkeysCL]---
---[Archivo Original: MadHouse's]---
---[Modificación a ESX]---


Config = {}

Config.UseTableSort = false
Config.ShowBlips = true
Config.DebugPoly = false
Config.UseTarget = false --- ... (Habilitalo si está en tu servidor) ...
Config.Elevators = {
    ['pillbox_hospital_elevator'] = {
        authorized = {"police", "ambulance"}, --- ((NOMBRE DE LA FACCIÓN AUTORIZADA A USAR EL ELEVADOR))
        blip = {
            label = "Pillbox Hospital Elevator", --- ((NOMBRE DEL ELEVADOR))
            show = false, --- MOSTRAR EL BLIP PERSONALIZADO
            coords = vector3(341.05, -580.84, 28.8), --- [COORDENADAS DEL ELEVADOR]
            sprite = 728,     ---]
            colour = 44,      ---] BLIP IDENTIFICABLE DEL ELEVADOR
            scale = 0.8,      ---]
        },
        floors = {
            [1] = {
                name = "Estacionamiento", --- ((NOMBRE DEL PISO, POR EJEMPLO: LOBBY, GIMNASIO, HELIPUERTO, ETC.)) ---
                coords = vector3(341.05, -580.84, 28.8), --- [COORDENADAS DE CADA PISO]
                heading = 86.6, --- [ORIENTACIÓN AL MOMENTO DE SPAWNEAR]
                tpVehicle = false, --- [SI QUIERES HACER UN ASCENSOR PARA VEHÍCULOS HABILITALO]
            },
            [2] = {
                name = "Lobby",
                coords = vector3(332.0970, -595.5458, 43.2841),
                heading = 68.44,
                tpVehicle = false,
            },
            [3] = {
                name = "Tejado",
                coords = vector3(339.7, -584.19, 74.16),
                heading = 242.64,
                tpVehicle = false,
            },
        }
    },
    -- ... Puedes añadir más puntos de elevadores con sus correspondientes pisos, recordar que son ilimitados ...
    ['diamond_casino'] = {
        authorized = {"public"},
        blip = {
            label = "Diamond Casino Lift",
            show = false,
            coords = vector3(960.5756, 43.4318, 71.7007),
            sprite = 728,
            colour = 44,
            scale = 0.8,
        },
        floors = {
            [1] = {
                name = "Basement",
                coords = vector3(960.5756, 43.4318, 71.7007),
                heading = 284.6085,
                tpVehicle = false,
            },
            [2] = {
                name = "Ground Floor",
                coords = vector3(964.9559, 58.6617, 112.5531),
                heading = 80.0243,
                tpVehicle = false,
            },
            [3] = {
                name = "Third Floor",
                coords = vector3(971.8812, 51.9888, 120.2407),
                heading = 327.7185,
                tpVehicle = false,
            },
        }
    },
}
