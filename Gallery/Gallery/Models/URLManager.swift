//
//  URLManager.swift
//  Gallery
//
//  Created by Валентина Лінчук on 01/09/2023.
//

import Foundation

class URLManager {
    static func getImagesNames() -> [String] {
        guard let arrayOfData = UserDefaults.standard.array(forKey: "savedImagesNames"),
                let result = arrayOfData as? [String] else { return [] }
        return result
        
       
    }
    
    static func addImageName(_ name: String) {
        let currentNames = getImagesNames()
        UserDefaults.standard.set(currentNames + [name], forKey: "savedImagesNames")
    }
    
    static func deleteAll() {
        UserDefaults.standard.removeObject(forKey: "savedImagesNames")
    }
    

}
