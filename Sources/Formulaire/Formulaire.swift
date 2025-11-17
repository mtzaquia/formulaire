import Foundation
import SwiftUI

@attached(member, names: named(Fields), named(__fields), named(__validator))
@attached(extension, conformances: Formulaire)
/// A macro that allows a class to be used as the subject of a ``FormulaireView``.
public macro Formulaire() = #externalMacro(module: "FormulaireMacros", type: "FormulaireMacro")

/// The protocol allowing a class to be used as the subject of a ``FormulaireView``.
/// - Important: You don't confirm to this protocol directly, instead, use the ``Formulaire()`` macro.
public protocol Formulaire: AnyObject {
    /// A function implementing validation logic for this subject.
    ///
    /// You can use ``addError(_:for:)`` to tag fields with errors, and/or ``validate(_:)`` on nested subjects to reuse their individual validation logic.
    ///
    /// ```swift
    /// @Observable @Formulaire
    /// final class MyForm {
    ///   var name: String
    ///   var address: Address
    ///
    ///   func validate() {
    ///     if name.isEmpty {
    ///       addError(RequiredFieldMissing(), for: \.name)
    ///     }
    ///  
    ///     validate(\.address)
    ///   }
    /// }
    /// ```
    func validate()

    associatedtype Fields

    /// **[Internal use]** You do not interact with this property directly.
    static var __fields: Fields { get }

    /// **[Internal use]** You do not interact with this property directly.
    var __validator: Validator<Self> { get }
}
