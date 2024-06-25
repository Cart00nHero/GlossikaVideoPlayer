//
//  CallApi.swift
//  VideoPlayerPrj
//
//  Created by YuCheng on 2024/6/24.
//

import Foundation
import Theatre

class CallApi: Routine {
    private let jsonHandler: JsonHandlerProtocol
    
    init(_ attach: Scenario, jsonHandler: JsonHandlerProtocol = JsonHandler()) {
        self.jsonHandler = jsonHandler
        super.init(attach)
    }
    
    private func actLoadVideoCategories(port: Teleport<[VideoCategory]>) {
        guard let jsonData = jsonHandler.loadGeoJSONFromFile() else { return }
        do {
            let media: MediaData = try MediaData(jsonUTF8Data: jsonData)
            port.portal = media.categories
        } catch {
            port.portal = []
            print(error.localizedDescription)
        }
    }
}
extension CallApi: CallApiProtocol {
    func loadVideoCategories() -> [VideoCategory] {
        let tel: Teleport<[VideoCategory]> = Teleport([])
        act { [weak self] in
            self?.actLoadVideoCategories(port: tel)
        }
        return tel.portal
    }
}

protocol CallApiProtocol {
    func loadVideoCategories() -> [VideoCategory]
}
