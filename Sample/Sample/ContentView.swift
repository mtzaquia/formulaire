//
//  ContentView.swift
//  Sample
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Formulaire
import SwiftUI

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

    func validate(checker: FormulaireChecker<MyFormObject>) {
        if name.isEmpty {
            checker.addError(POSIXError(.EAFNOSUPPORT), field: .name)
            checker.focus(on: .name)
        }

        if !hasCar {
            checker.addError(POSIXError(.EAFNOSUPPORT), field: .hasCar)
        }

        address.validate(checker: checker.nested(for: \.address))
    }
}

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
}

struct ContentView: View {
    @State var object = MyFormObject(
        name: "",
        age: 0,
        hasCar: false,
        address: .init(
            addressLine1: "",
            addressLine2: "",
            city: "",
            zipCode: ""
        )
    )

    var body: some View {
        FormulaireView(editing: $object) { form in
            Section {
                form.textField(for: \.name, label: "Name")

                form.toggle(for: \.hasCar, label: "Has car?")

                form.control(for: \.hasCar, focusable: false) { builder in
                    HStack {
                        Toggle(isOn: builder.$value) {
                            Text("YEAH!")
                        }

                        Text(builder.error?.localizedDescription ?? "NO ERROR!")
                            .foregroundStyle(builder.error == nil ? .black : .red)
                    }
                }

                form.stepper(for: \.age, label: "Age")
            }

            Section {
                Text("Yola")
            }

            Section {
                Text("Yole")
            }

            Section {
                Text("Yoli")
            }

            Section {
                Text("Yoli")
            }

            Section {
                Text("Yolu")
            }

            Section {
                form.textField(for: \.address.addressLine1, label: "Address line 1")
                form.textField(for: \.address.addressLine2, label: "Address line 2")
                form.textField(for: \.address.city, label: "City")
                form.textField(for: \.address.zipCode, label: "ZIP")
            }

            Section {
                form.submitButton("Submit", onSubmit: { print("SUCCESS!") })
            }
        }
    }
}
