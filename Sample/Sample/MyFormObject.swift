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
    var licensePlate: String
    var address: Address

    var computedProperty: String { "Can't be used because it's computed" }
    let readOnlyProperty: String = "Can't be used because it's `let`"

    init(
        name: String,
        age: Int,
        hasCar: Bool,
        licensePlate: String,
        address: Address
    ) {
        self.name = name
        self.age = age
        self.hasCar = hasCar
        self.licensePlate = licensePlate
        self.address = address
    }

    func validate() {
        if name.isEmpty {
            addError("Name is required", for: \.name)
        }

        if hasCar, licensePlate.isEmpty {
            addError("Needs license plate", for: \.licensePlate)
        }

        validate(\.address)

//        if address.addressLine1.isEmpty {
//            addError("Address line 1 is required", for: \.address.addressLine1)
//        }
    }
}
