//
//  ContentView.swift
//  Sample
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Formulaire
import SwiftUI

@Observable
final class MyFormObject: Formulaire {
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

    func validate(errorBuilder: ErrorBuilder<MyFormObject>) {
        if name.isEmpty {
            errorBuilder.addError(POSIXError(.EBADMSG), keyPath: \.name)
            errorBuilder.focus(on: \.name)
        }
    }
}

struct ContentView: View {
    @State var myObject: MyFormObject = .init(
        name: "",
        age: 0,
        hasCar: false,
        addressLine1: "",
        addressLine2: "",
        city: "",
        zipCode: ""
    )

    var body: some View {
        FormulaireView(editing: $myObject) { form in
            form.textField(for: \.name, label: "Name")
            form.toggle(for: \.hasCar, label: "Has car?")
            form.stepper(for: \.age, label: "Age", range: 0...10)

            Section {
                form.textField(for: \.addressLine1, label: "Address line 1")
                form.textField(for: \.addressLine2, label: "Address line 2")
                form.textField(for: \.city, label: "City")
                form.textField(for: \.zipCode, label: "ZIP code")
            }

            Section {
                form.submitButton("Submit") { print("success!") }
            }
        }
    }
}

#Preview {
    ContentView()
}
