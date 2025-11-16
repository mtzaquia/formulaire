//
//  Address.swift
//  Sample
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation
import Formulaire

@Observable @Formulaire
final class Address {
    var addressLine1: String
    var addressLine2: String
    var city: String
    var zipCode: String

    init(addressLine1: String, addressLine2: String, city: String, zipCode: String) {
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.zipCode = zipCode
    }

    func validate() {
        if addressLine1.isEmpty {
            addError("Address line 1 is required", for: \.addressLine1)
        }
    }
}
