// This test uses swift-macro-testing (or MacroTesting) to verify the actual expansion of FormulaireMacro.
// It does not simulate; it asserts macro expansion output.
import MacroTesting
import SwiftSyntaxMacros
import Testing
import FormulaireMacros

@Suite(
    .macros(
        ["Formulaire": FormulaireMacro.self],
        record: .all
    )
)
struct FormulaireMacrosTests {
    @Test func testAllKeyPathsExpansion() {
        assertMacro {
            """
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
            }
            """
        } diagnostics: {
            """

            """
        } expansion: {
            #"""
            @Observable
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

                static var __allFields: [FormulaireField<Self>] {
                    [
                        FormulaireField(label: "name", keyPath: \Self.name),
                                FormulaireField(label: "age", keyPath: \Self.age),
                                FormulaireField(label: "hasCar", keyPath: \Self.hasCar),
                                FormulaireField(label: "addressLine1", keyPath: \Self.addressLine1),
                                FormulaireField(label: "addressLine2", keyPath: \Self.addressLine2),
                                FormulaireField(label: "city", keyPath: \Self.city),
                                FormulaireField(label: "zipCode", keyPath: \Self.zipCode)
                    ]
                }
            }

            extension MyFormObject: Formulaire {
            }
            """#
        }
    }
}
