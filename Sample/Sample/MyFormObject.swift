//
//  MyFormObject.swift
//  Sample
//
//  Created by Mauricio Tremea Zaquia on 16/11/2025.
//

import Foundation
import Formulaire

@Observable @Formulaire
final class MyFormObject: Formulaire {
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

    func validate(checker: FormulaireChecker<Fields>) {
        if name.isEmpty {
            checker.addError(POSIXError(.EAFNOSUPPORT), field: .name)
            checker.focus(on: .name)
        }

        if !hasCar {
            checker.addError(POSIXError(.EAFNOSUPPORT), field: .hasCar)
        }

        //        address.validate(checker: checker.nested(for: \.address))
    }
}
