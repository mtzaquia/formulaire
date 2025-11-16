import Foundation
import SwiftUI

@attached(member, names: named(Fields), named(__fields), named(__validator))
@attached(extension, conformances: Formulaire)
public macro Formulaire() = #externalMacro(module: "FormulaireMacros", type: "FormulaireMacro")

public protocol Formulaire: AnyObject {
    associatedtype Fields

    func validate()

    static var __fields: Fields { get }
    var __validator: Validator<Self> { get }
}

public extension Formulaire {
    func addError<V>(_ error: Error, for field: FieldPath<Self, V>) {
        let concreteField = Self.__fields[keyPath: field]
        __validator.errors[concreteField.label] = error
    }
}
