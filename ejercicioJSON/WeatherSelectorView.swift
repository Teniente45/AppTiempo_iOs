//
//  WeatherSelectorView.swift
//  ejercicioJSON
//
//  Created by Juan López Marín on 19/7/25.
//

import SwiftUI

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

                Text("Selecciona Municipio")
                    .font(.title2)
                    .bold()

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
                }) {
                    Text("Buscar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }

                if !resultadoTiempo.isEmpty {
                    Text("⛅ Tiempo: \(resultadoTiempo)")
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

    private func fetchTiempo() {
        guard let provincia = provinciaSeleccionada else {
            resultadoTiempo = "Selecciona una provincia válida."
            return
        }

        // 🔐 La API Key se ha movido a Info.plist para protegerla del código fuente
        // Método usado: almacenamiento seguro mediante Info.plist (no incluirlo en control de versiones públicos)
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "AEMET_API_KEY") as? String ?? ""
        let endpoint = "https://opendata.aemet.es/opendata/api/prediccion/especifica/municipio/diaria/\(provincia.codigo)?api_key=\(apiKey)"
        print("🌐 URL generada: \(endpoint)")

        guard let url = URL(string: endpoint) else {
            resultadoTiempo = "URL inválida."
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                if let root = try? JSONDecoder().decode([String: String].self, from: data),
                   let datosUrl = root["datos"],
                   let urlDatos = URL(string: datosUrl) {
                    URLSession.shared.dataTask(with: urlDatos) { data2, _, _ in
                        guard let data2 = data2 else {
                            DispatchQueue.main.async {
                                resultadoTiempo = "Error al obtener los datos de predicción."
                            }
                            return
                        }
                        print("📦 JSON recibido:\n", String(data: data2, encoding: .utf8) ?? "No se pudo decodificar")
                        do {
                            let predicciones = try JSONDecoder().decode([PrediccionMunicipio].self, from: data2)
                            if let prediccion = predicciones.first?.prediccion?.dia.first {
                                DispatchQueue.main.async {
                                    let estado = prediccion.estadoCielo.first?.descripcion ?? "Sin datos"
                                    let maxima = prediccion.temperatura.maxima
                                    let minima = prediccion.temperatura.minima
                                    resultadoTiempo = "\(estado). Máx: \(maxima)ºC / Mín: \(minima)ºC"
                                    print("✅ Predicción mostrada correctamente.")
                                }
                            } else {
                                print("⚠️ No se encontró ninguna predicción para la provincia seleccionada.")
                                DispatchQueue.main.async {
                                    resultadoTiempo = "No hay datos disponibles para esta provincia."
                                }
                            }
                        } catch {
                            print("❌ Error decodificando JSON: \(error)")
                            DispatchQueue.main.async {
                                resultadoTiempo = "No se pudieron interpretar los datos del tiempo."
                            }
                        }
                    }.resume()
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
