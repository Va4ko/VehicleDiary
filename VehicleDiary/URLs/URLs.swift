//
//  URLs.swift
//  VehicleDiary
//
//  Created by Vachko on 15.10.20.
//

import Foundation

// MARK: - URLs for vehicle list and logos download

let urlBase = "https://vehiclediary.000webhostapp.com/logos/"
var urlEnd = ""
let vehiclesMakeUrl = "https://vehiclediary.000webhostapp.com/VehicleModels.json"

typealias DownloadComplete = () -> ()
