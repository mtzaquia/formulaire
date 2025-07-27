//
//  PresencePreferenceKey.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 24/07/2025.
//

import Collections
import SwiftUI

enum PresencePreferenceKey: PreferenceKey {
    nonisolated(unsafe) static let defaultValue: OrderedSet<AnyHashable>? = nil

    static func reduce(value: inout OrderedSet<AnyHashable>?, nextValue: () -> OrderedSet<AnyHashable>?) {
        nextValue()?.forEach { value?.append($0) }
    }
}
