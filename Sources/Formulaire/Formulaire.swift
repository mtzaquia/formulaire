import Foundation
import SwiftUI

@attached(member, names: named(Fields), named(__fields))
@attached(extension, conformances: Formulaire)
public macro Formulaire() = #externalMacro(module: "FormulaireMacros", type: "FormulaireMacro")

public protocol FieldsProtocol {
    associatedtype Cases: Hashable
}

public protocol Formulaire: AnyObject {
    associatedtype Fields: FieldsProtocol

    func validate(checker: FormulaireChecker<Fields>)

    static var __fields: Fields { get }
}

public extension Formulaire {
    func validate(checker: FormulaireChecker<Fields>) {}
}
