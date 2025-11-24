//
//  Copyright (c) 2025 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import Formulaire
import SwiftUI

@Observable @Formulaire
final class Person {
    var name: String = ""
    var address: Address = Address()

    var computedProperty: String { "Can't be used because it's computed" }
    let readOnlyProperty: String = "Can't be used because it's `let`"

    func validate() {
        if name.isEmpty {
            addError("Name is required", for: \.name)
        }

        validate(\.address)
    }
}

@Observable @Formulaire
final class Address {
    var addressLine1: String = ""
    var addressLine2: String = ""
    var city: String = ""
    var zipCode: String = ""

    func validate() {
        if addressLine1.isEmpty {
            addError("Address line 1 is required", for: \.addressLine1)
        }

        if city.isEmpty {
            addError("City is required", for: \.city)
        }

        if zipCode.isEmpty {
            addError("ZIP code is required", for: \.zipCode)
        }
    }
}

struct PersonForm: View {
    @State var person = Person()

    @State var success = false

    var body: some View {
        FormulaireView(editing: $person) { form in
            Section {
                form.textField(for: \.name, label: "Name")
            }

            Section {
                let scoped = form.scope(\.address)
                scoped.textField(for: \.addressLine1, label: "Address line 1")
                scoped.textField(for: \.addressLine2, label: "Address line 1")
                scoped.textField(for: \.zipCode, label: "ZIP code")
                scoped.textField(for: \.city, label: "City")
            }

            Section {
                Button("Validate") {
                    success = form.validate()

                    if !success {
                        form.focus(on: \.address)
                    }
                }
            }
        }
        .alert("Success!", isPresented: $success) {
            Button("Ok") { success = false }
        }
    }
}

