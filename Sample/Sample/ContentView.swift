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


import Formulaire
import SwiftUI

struct ContentView: View {
    @State var object = MyFormObject(
        name: "",
        age: 0,
        hasCar: false,
        licensePlate: "",
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

                if object.hasCar {
//                    form.control(for: \.hasCar, focusable: false) { builder in
//                        HStack {
//                            Toggle(isOn: builder.$value) {
//                                Text("YEAH!")
//                            }
//
//                            Text(builder.error?.localizedDescription ?? "NO ERROR!")
//                                .foregroundStyle(builder.error == nil ? .black : .red)
//                        }
//                    }
                    form.textField(for: \.licensePlate, label: "License plate")
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
                Text("Yolo")
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
