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
