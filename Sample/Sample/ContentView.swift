//
//  ContentView.swift
//  Sample
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Formulaire
import SwiftUI

@Formulaire @Observable
final class MyFormObject {
    var name: String
    var age: Int
    var hasCar: Bool

    var addressLine1: String
    var addressLine2: String
    var city: String
    var zipCode: String

    init(
        name: String,
        age: Int,
        hasCar: Bool,
        addressLine1: String,
        addressLine2: String,
        city: String,
        zipCode: String
    ) {
        self.name = name
        self.age = age
        self.hasCar = hasCar
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.zipCode = zipCode
    }

    func validate(checker: FormulaireChecker<MyFormObject>) {
        if name.isEmpty {
            checker.addError(POSIXError(.EAFNOSUPPORT), field: .name)
            checker.focus(on: .name)
        }

        if !hasCar {
            checker.addError(POSIXError(.EAFNOSUPPORT), field: .hasCar)
        }
    }
}

struct ContentView: View {
    @State var object = MyFormObject(
        name: "",
        age: 0,
        hasCar: false,
        addressLine1: "",
        addressLine2: "",
        city: "",
        zipCode: ""
    )

    var body: some View {
        FormulaireView(editing: $object) { form in
            Section {
                form.textField(for: \.name, label: "Name")

                form.toggle(for: \.hasCar, label: "Has car?")
                
                form.customControl(for: \.hasCar, focusable: false) { control in
                    HStack {
                        Toggle(isOn: control.binding) {
                            Text("YEAH!")
                        }

                        Text(control.error?.localizedDescription ?? "NO ERROR!")
                            .foregroundStyle(control.error == nil ? .black : .red)
                    }
                }

                form.stepper(for: \.age, label: "Age")
            }

            Section {
                form.textField(for: \.addressLine1, label: "Address line 1")
                form.textField(for: \.addressLine2, label: "Address line 2")
                form.textField(for: \.city, label: "City")
                form.textField(for: \.zipCode, label: "ZIP")
            }

            Section {
                form.submitButton("Submit", onSubmit: { print("SUCCESS!") })
            }
        }
    }
}
