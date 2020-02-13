//
//  Car.swift
//  Carangas
//
//  Created by perfil on 12/02/20.
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import Foundation

class Car: Codable {
    var _id: String?
    var brand:String = ""
    var name:String = ""
    var price:Int = 0
    var gasType:Int = 0
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
    
}


