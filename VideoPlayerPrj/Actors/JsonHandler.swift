//
//  JsonHandler.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/20.
//

import Foundation
import Theatre

final class JsonHandler: Actor {
    private func actLoadGeoJSONFromFile(_ port: Teleport<Data?>) {
        if let url = Bundle.main.url(forResource: "MockJosn", withExtension: "geojson") {
            port.portal = try? Data(contentsOf: url)
        } else {
            print("GeoJSON file not found")
            port.portal = nil
        }
    }
}
extension JsonHandler: JsonHandlerProtocol {
    func loadGeoJSONFromFile() -> Data? {
        let teleport: Teleport<Data?> = Teleport(nil)
        act { [weak self] in
            self?.actLoadGeoJSONFromFile(teleport)
        }
        return teleport.portal
    }
}

protocol JsonHandlerProtocol {
    func loadGeoJSONFromFile() -> Data?
}
