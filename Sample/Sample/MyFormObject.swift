//
//  MyFormObject.swift
//  Sample
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation
import Formulaire

@Observable @Formulaire
final class MyFormObject {
    var name: String
    var age: Int
    var hasCar: Bool
    var address: Address

    init(
        name: String,
        age: Int,
        hasCar: Bool,
        address: Address
    ) {
        self.name = name
        self.age = age
        self.hasCar = hasCar
        self.address = address
    }

    func validate() {
        if name.isEmpty {
            addError("Name is required", for: \.name)
        }

        if !hasCar {
            addError("Needs car", for: \.hasCar)
        }

//        if address.addressLine1.isEmpty {
//            addError("Address line 1 is required", for: \.address.addressLine1)
//        }
    }
}
