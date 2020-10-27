//
//  Model.swift
//  VehicleDiary
//
//  Created by Vachko on 15.10.20.
//

import UIKit

var _brands = ["-- Select vehicle brand --"]

var _brandsAndModels: [String: [String]] = [:]

var brands: [String] {
    if _brands.isEmpty {
        _brands.append("")
    }
    return _brands
}

var brandsAndModels: [String: [String]] {
    if _brandsAndModels.isEmpty {
        _brandsAndModels = ["": [""]]
    }
    return _brandsAndModels
}

func downloadVehicles() {
    if let url = URL(string: vehiclesMakeUrl) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do { let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : [String]]
                    _brandsAndModels = dict!
                    for key in brandsAndModels.keys.sorted(by: { $0 < $1 }){
                        _brands.append(key)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}


//func downloadVehicles(completion: @escaping ((_ vehicles: [String : [String]]) -> Void)) {
//    if let url = URL(string: vehiclesMakeUrl) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                do { let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String : [String]]
//
//                    let vehicles = dict!
//                    completion(vehicles)
////                    for key in brandsAndModels.keys.sorted(by: { $0 < $1 }){
////                        _brands.append(key)
////                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }.resume()
//    }
//}



func downloadLogo(completion: @escaping ((_ image: UIImage?) -> Void)) {
    if let url = URL(string: "\(urlBase)\(urlEnd).jpg") {
        URLSession.shared.dataTask(with: url) { data, response, error in
            do { let url = url
                let data = try Data(contentsOf: url)
                DispatchQueue.main.sync {
                    completion(UIImage(data: data))
                }
            } catch {
                print("Couldn't find logo for your vehicle")
            }
        }.resume()
    }
}
