//
//  WeatherSelectorView.swift
//  ejercicioJSON
//
//  Created by Juan López Marín on 19/7/25.
//


// MARK: Todos los Prints de consola
//
// 🌐 URL generada: Muestra la URL de la API generada con el código de provincia.
// 🛰️ JSON respuesta 1: Muestra la respuesta JSON inicial de la API (nivel 1).
// 🔗 URL de datos: Muestra la URL que contiene los datos meteorológicos detallados.
// 🧾 Tipo de contenido: Indica el tipo MIME recibido desde la URL de datos.
// 📦 Bytes crudos recibidos: Muestra los bytes crudos que llegaron desde la URL de datos.
// 📦 Texto recibido: Imprime el contenido recibido como texto (intentando UTF-8).
// 📦 Datos crudos JSON desde URL 'datos': Imprime los datos del JSON en forma de texto.
// 📦 JSON respuesta 2: Muestra el JSON completo recibido desde la URL 'datos'.
// 📦 JSON bruto decodificado: Imprime el objeto Swift resultante del parseo, si es exitoso.
// ✅ Predicción mostrada correctamente.: Confirmación de que se ha interpretado y mostrado la predicción.
// ❌ URL inválida: Se generó una URL incorrecta para la segunda petición.
// ❌ Error decodificando el JSON inicial.: Fallo al interpretar la respuesta JSON inicial.
// ❌ Error interpretando el JSON final: Se produjo un error al interpretar el JSON de la predicción.

import SwiftUI

struct AEMETRespuesta: Decodable {
    let descripcion: String
    let estado: Int
    let datos: String
    let metadatos: String
}

struct Provincia: Identifiable, Hashable {    let id = UUID()
    let nombre: String
    let comunidad: String
    let codigo: String
}

struct WeatherSelectorView: View {
    @State private var provinciasPorComunidad: [String: [Provincia]] = [:]
    @State private var provinciaSeleccionada: Provincia?
    @State private var resultadoTiempo: String = ""
    @State private var comunidadSeleccionada: String? = nil

    var body: some View {
        let comunidadesOrdenadas = provinciasPorComunidad.keys.sorted()

        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Imagen centrada debajo del título de navegación
                HStack {
                    Spacer()
                    Image("logoTiempo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.vertical)
                    Spacer()
                }
                
                Menu {
                    ForEach(comunidadesOrdenadas, id: \.self) { comunidad in
                        Button(action: {
                            comunidadSeleccionada = comunidad
                            provinciaSeleccionada = nil // Resetear la provincia al cambiar comunidad
                        }) {
                            Text(comunidad)
                        }
                    }
                } label: {
                    Text(comunidadSeleccionada ?? "Selecciona comunidad")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }

                if let comunidad = comunidadSeleccionada,
                   let provincias = provinciasPorComunidad[comunidad] {
                    Picker("Provincia", selection: $provinciaSeleccionada) {
                        ForEach(provincias) { provincia in
                            Text(provincia.nombre).tag(Optional(provincia))
                        }
                    }
                    .pickerStyle(.wheel)
                }

                Button(action: {
                    fetchTiempo()
                    // MARK: - Ocultar el picker de provincias tras pulsar "Buscar"
                    comunidadSeleccionada = nil
                    provinciaSeleccionada = nil
                }) {
                    Text("Buscar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }

                if !resultadoTiempo.isEmpty {
                    ScrollView {
                        Text("⛅ Tiempo: \(resultadoTiempo)")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.top, 20)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Consulta el Tiempo")
            .onAppear {
                cargarProvincias()
            }
        }
    }

    // MARK: - Carga el diccionario de provincias agrupadas por comunidad autónoma
    private func cargarProvincias() {
        provinciasPorComunidad = [
            "Andalucía": [
                Provincia(nombre: "Almería", comunidad: "Andalucía", codigo: "04013"),
                Provincia(nombre: "Cádiz", comunidad: "Andalucía", codigo: "11012"),
                Provincia(nombre: "Córdoba", comunidad: "Andalucía", codigo: "14021"),
                Provincia(nombre: "Granada", comunidad: "Andalucía", codigo: "18087"),
                Provincia(nombre: "Huelva", comunidad: "Andalucía", codigo: "21041"),
                Provincia(nombre: "Jaén", comunidad: "Andalucía", codigo: "23050"),
                Provincia(nombre: "Málaga", comunidad: "Andalucía", codigo: "29067"),
                Provincia(nombre: "Sevilla", comunidad: "Andalucía", codigo: "41091")
            ],
            "Aragón": [
                Provincia(nombre: "Huesca", comunidad: "Aragón", codigo: "22125"),
                Provincia(nombre: "Teruel", comunidad: "Aragón", codigo: "44216"),
                Provincia(nombre: "Zaragoza", comunidad: "Aragón", codigo: "50297")
            ],
            "Asturias": [
                Provincia(nombre: "Asturias", comunidad: "Asturias", codigo: "33044")
            ],
            "Islas Baleares": [
                Provincia(nombre: "Islas Baleares", comunidad: "Islas Baleares", codigo: "07040")
            ],
            "Canarias": [
                Provincia(nombre: "Las Palmas", comunidad: "Canarias", codigo: "35016"),
                Provincia(nombre: "Santa Cruz de Tenerife", comunidad: "Canarias", codigo: "38038")
            ],
            "Cantabria": [
                Provincia(nombre: "Cantabria", comunidad: "Cantabria", codigo: "39075")
            ],
            "Castilla-La Mancha": [
                Provincia(nombre: "Albacete", comunidad: "Castilla-La Mancha", codigo: "02003"),
                Provincia(nombre: "Ciudad Real", comunidad: "Castilla-La Mancha", codigo: "13034"),
                Provincia(nombre: "Cuenca", comunidad: "Castilla-La Mancha", codigo: "16078"),
                Provincia(nombre: "Guadalajara", comunidad: "Castilla-La Mancha", codigo: "19130"),
                Provincia(nombre: "Toledo", comunidad: "Castilla-La Mancha", codigo: "45168")
            ],
            "Castilla y León": [
                Provincia(nombre: "Ávila", comunidad: "Castilla y León", codigo: "05019"),
                Provincia(nombre: "Burgos", comunidad: "Castilla y León", codigo: "09059"),
                Provincia(nombre: "León", comunidad: "Castilla y León", codigo: "24089"),
                Provincia(nombre: "Palencia", comunidad: "Castilla y León", codigo: "34120"),
                Provincia(nombre: "Salamanca", comunidad: "Castilla y León", codigo: "37274"),
                Provincia(nombre: "Segovia", comunidad: "Castilla y León", codigo: "40194"),
                Provincia(nombre: "Soria", comunidad: "Castilla y León", codigo: "42173"),
                Provincia(nombre: "Valladolid", comunidad: "Castilla y León", codigo: "47186"),
                Provincia(nombre: "Zamora", comunidad: "Castilla y León", codigo: "49275")
            ],
            "Cataluña": [
                Provincia(nombre: "Barcelona", comunidad: "Cataluña", codigo: "08019"),
                Provincia(nombre: "Girona", comunidad: "Cataluña", codigo: "17079"),
                Provincia(nombre: "Lleida", comunidad: "Cataluña", codigo: "25120"),
                Provincia(nombre: "Tarragona", comunidad: "Cataluña", codigo: "43148")
            ],
            "Extremadura": [
                Provincia(nombre: "Badajoz", comunidad: "Extremadura", codigo: "06015"),
                Provincia(nombre: "Cáceres", comunidad: "Extremadura", codigo: "10037")
            ],
            "Galicia": [
                Provincia(nombre: "A Coruña", comunidad: "Galicia", codigo: "15030"),
                Provincia(nombre: "Lugo", comunidad: "Galicia", codigo: "27028"),
                Provincia(nombre: "Ourense", comunidad: "Galicia", codigo: "32054"),
                Provincia(nombre: "Pontevedra", comunidad: "Galicia", codigo: "36038")
            ],
            "Madrid": [
                Provincia(nombre: "Madrid", comunidad: "Madrid", codigo: "28079")
            ],
            "Murcia": [
                Provincia(nombre: "Murcia", comunidad: "Murcia", codigo: "30030")
            ],
            "Navarra": [
                Provincia(nombre: "Navarra", comunidad: "Navarra", codigo: "31157")
            ],
            "País Vasco": [
                Provincia(nombre: "Álava", comunidad: "País Vasco", codigo: "01059"),
                Provincia(nombre: "Gipuzkoa", comunidad: "País Vasco", codigo: "20069"),
                Provincia(nombre: "Bizkaia", comunidad: "País Vasco", codigo: "48020")
            ],
            "La Rioja": [
                Provincia(nombre: "La Rioja", comunidad: "La Rioja", codigo: "26089")
            ],
            "Ceuta y Melilla": [
                Provincia(nombre: "Ceuta", comunidad: "Ceuta", codigo: "51001"),
                Provincia(nombre: "Melilla", comunidad: "Melilla", codigo: "52001")
            ]
        ]
    }

    // MARK: - Obtiene el tiempo meteorológico de la provincia seleccionada y procesa la respuesta de la API
    private func fetchTiempo() {
        guard let provincia = provinciaSeleccionada ?? (comunidadSeleccionada.flatMap { comunidad in
            provinciasPorComunidad[comunidad]?.sorted(by: { $0.nombre < $1.nombre }).first
        }) else {
            DispatchQueue.main.async {
                resultadoTiempo = "Selecciona una provincia válida."
            }
            return
        }

        let apiKey = Bundle.main.object(forInfoDictionaryKey: "AEMET_API_KEY") as? String ?? ""
        let endpoint = "https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/diaria/\(provincia.codigo)?api_key=\(apiKey)"
        // MARK: - Prints de depuración
        // Imprime la URL completa de la API generada con el código de provincia
        print("🌐 URL generada: \(endpoint)")

        guard let url = URL(string: endpoint) else {
            DispatchQueue.main.async {
                resultadoTiempo = "URL inválida."
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                // Imprime la respuesta JSON inicial de la API (primer nivel)
                print("🛰️ JSON respuesta 1:\n", String(data: data, encoding: .utf8) ?? "Sin datos")
                if let respuesta = try? JSONDecoder().decode(AEMETRespuesta.self, from: data) {
                    let datosUrl = respuesta.datos
                    // Imprime la URL donde están los datos meteorológicos detallados
                    print("🔗 URL de datos: \(datosUrl)")
                    if let urlDatos = URL(string: datosUrl) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            URLSession.shared.dataTask(with: urlDatos) { data2, response, _ in
                                guard let data2 = data2 else {
                                    DispatchQueue.main.async {
                                        resultadoTiempo = "Error al obtener los datos de predicción."
                                    }
                                    return
                                }

                                if let httpResponse = response as? HTTPURLResponse {
                                    // Imprime el tipo de contenido recibido en la respuesta HTTP
                                    print("🧾 Tipo de contenido:", httpResponse.allHeaderFields["Content-Type"] ?? "Desconocido")
                                }

                                // Imprime los bytes crudos recibidos de la URL de datos
                                print("📦 Bytes crudos recibidos:", data2)
                                // Imprime el texto recibido (intentando decodificar como UTF-8)
                                print("📦 Texto recibido:", String(data: data2, encoding: .utf8) ?? "No es UTF-8")
                                // Imprime los datos crudos JSON desde la URL 'datos' como texto
                                print("📦 Datos crudos JSON desde URL 'datos':\n\(String(decoding: data2, as: UTF8.self))")

                                // Imprime la respuesta JSON completa (segundo nivel)
                                print("📦 JSON respuesta 2:\n", String(data: data2, encoding: .utf8) ?? "No se pudo decodificar")
                                if let jsonBruto = try? JSONSerialization.jsonObject(with: data2, options: []) {
                                    // Imprime el JSON bruto decodificado a objeto Swift
                                    print("📦 JSON bruto decodificado:\n\(jsonBruto)")
                                } else {
                                    // Imprime si no se pudo decodificar el JSON bruto
                                    print("📦 JSON bruto decodificado: nil")
                                }
                                do {
                                    // Conversión de codificación Latin1 -> UTF-8 antes del parseo JSON
                                    let stringLatin1 = String(data: data2, encoding: .isoLatin1) ?? ""
                                    guard let dataUTF8 = stringLatin1.data(using: .utf8) else {
                                        DispatchQueue.main.async {
                                            resultadoTiempo = "Error de codificación del JSON."
                                        }
                                        return
                                    }
                                    let jsonArray = try JSONSerialization.jsonObject(with: dataUTF8, options: []) as? [[String: Any]]
                                    guard let rootObject = jsonArray?.first,
                                          let prediccion = rootObject["prediccion"] as? [String: Any],
                                          let dias = prediccion["dia"] as? [[String: Any]] else {
                                        DispatchQueue.main.async {
                                            resultadoTiempo = "No se pudo interpretar la predicción meteorológica."
                                        }
                                        return
                                    }

                                    let primeros4Dias = dias.prefix(4)
                                    let texto = primeros4Dias.enumerated().compactMap { (index, dia) -> String? in
                                        let fechaTexto = dia["fecha"] as? String ?? "Fecha no disponible"

                                        let estadoCieloArray = dia["estadoCielo"] as? [[String: Any]] ?? []
                                        let descripcionCielo = (estadoCieloArray.first { ($0["descripcion"] as? String)?.isEmpty == false }?["descripcion"] as? String) ?? "Sin datos"

                                        let temperatura = dia["temperatura"] as? [String: Any]
                                        let max = temperatura?["maxima"] as? Int ?? 0
                                        let min = temperatura?["minima"] as? Int ?? 0

                                        let probPrecipitacionArray = dia["probPrecipitacion"] as? [[String: Any]] ?? []
                                        let probPrecipitacion = (probPrecipitacionArray.first { $0["value"] != nil }?["value"] as? Int) ?? 0

                                        let humedad = dia["humedadRelativa"] as? [String: Any]
                                        let humedadMax = humedad?["maxima"] as? Int ?? 0
                                        let humedadMin = humedad?["minima"] as? Int ?? 0

                                        let vientoArray = dia["viento"] as? [[String: Any]] ?? []
                                        let viento = vientoArray.first { ($0["velocidad"] as? Int ?? 0) > 0 }
                                        let vientoDir = viento?["direccion"] as? String ?? "?"
                                        let vientoVel = viento?["velocidad"] as? Int ?? 0

                                        return """
                                        📅 Día \(index + 1) - \(fechaTexto.prefix(10))
                                        ☁️ Estado: \(descripcionCielo)
                                        🌧 Lluvia: \(probPrecipitacion)%
                                        🌡 Máx: \(max)ºC / Mín: \(min)ºC
                                        💧 Humedad: \(humedadMax)% / \(humedadMin)%
                                        💨 Viento: \(vientoDir) \(vientoVel) km/h
                                        """
                                    }.joined(separator: "\n\n")

                                    DispatchQueue.main.async {
                                        resultadoTiempo = texto
                                    }
                                    // Imprime confirmación de que la predicción fue mostrada correctamente
                                    print("✅ Predicción mostrada correctamente.")
                                } catch {
                                    // Imprime el error si falló la interpretación del JSON final
                                    print("❌ Error interpretando el JSON final: \(error)")
                                    DispatchQueue.main.async {
                                        resultadoTiempo = "No se pudieron interpretar los datos del tiempo."
                                    }
                                }
                            }.resume()
                        }
                    } else {
                        // Imprime si la URL de datos es inválida
                        print("❌ URL inválida: \(datosUrl)")
                    }
                } else {
                    // Imprime si hubo error decodificando el JSON inicial
                    print("❌ Error decodificando el JSON inicial.")
                }
            } else {
                DispatchQueue.main.async {
                    resultadoTiempo = "Error al obtener datos iniciales."
                }
                return
            }
        }.resume()
    }
}

struct PrediccionMunicipio: Codable {
    let prediccion: Prediccion?

    struct Prediccion: Codable {
        let dia: [Dia]
    }

    struct Dia: Codable {
        let estadoCielo: [EstadoCielo]
        let temperatura: Temperatura
    }

    struct Temperatura: Codable {
        let maxima: String
        let minima: String
    }

    struct EstadoCielo: Codable {
        let descripcion: String?

        enum CodingKeys: String, CodingKey {
            case descripcion = "descripcion"
        }
    }
}

#Preview {
    WeatherSelectorView()
}
