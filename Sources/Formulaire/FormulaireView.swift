//
//  FormulaireView.swift
//  Formulaire
//
//  Created by Mauricio Tremea Zaquia on 22/07/2025.
//

import Collections
import SwiftUI

@Observable @MainActor
public final class FieldTracker<F: Formulaire> {
    @ObservationIgnored
    var present = OrderedSet<F.Fields.Cases>() {
        didSet {
            print(present)
        }
    }

    init() {}
}

//public struct FieldTrackerReader<F: Formulaire, C: View>: View {
//    @Environment(FieldTracker<F>.self) private var fieldTracker
//    let builder: (FieldTracker<F>) -> C
//
//    public var body: some View {
//        builder(fieldTracker)
//    }
//
//    init(@ViewBuilder _ builder: @escaping (FieldTracker<F>) -> C) {
//        self.builder = builder
//    }
//}

public struct FormulaireView<F: Formulaire, C: View>: View {
    @Binding var object: F
    let builder: (FormulaireBuilder<F>) -> C

    @State private var checker: FormulaireChecker<F> = FormulaireChecker<F>()
    @State private var tracker: FieldTracker = FieldTracker<F>()
    @FocusState private var focus: F.Fields.Cases?

    public var body: some View {
        ScrollViewReader { proxy in
            Form {
                builder(
                    FormulaireBuilder<F>(
                        formulaire: $object,
                        checker: $checker,
                        tracker: $tracker,
                        focus: $focus
                    )
                )
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Group {
                        Button(
                            action: {
                                let currentIndex = focus.flatMap(tracker.present.firstIndex(of:))
                                guard let currentIndex, currentIndex - 1 >= 0 else { return }

                                let fieldToFocus = tracker.present[currentIndex - 1]

                                proxy.scrollTo(fieldToFocus, anchor: .top)
                                DispatchQueue.main.async {
                                    focus = fieldToFocus
                                }
                            },
                            label: {
                                Label("Previous", systemImage: "chevron.up")
                            }
                        )

                        Button(
                            action: {
                                guard let currentIndex = focus.flatMap(tracker.present.firstIndex(of:)),
                                      currentIndex + 1 < tracker.present.count
                                else { return }

                                let fieldToFocus = tracker.present[currentIndex + 1]
                                proxy.scrollTo(fieldToFocus, anchor: .bottom)

                                DispatchQueue.main.async {
                                    focus = fieldToFocus
                                }
                            },
                            label: {
                                Label("Next", systemImage: "chevron.down")
                            }
                        )

                        Color.clear.frame(maxWidth: .infinity)

                        Button(
                            action: { focus = nil },
                            label: {
                                Label("Done", systemImage: "checkmark")
                                    .labelStyle(.iconOnly)
                            }
                        )
                        .bold()
                    }
                }
            }
        }
//        .environment(tracker)
    }

    public init(
        editing object: Binding<F>,
        @ViewBuilder builder: @escaping (FormulaireBuilder<F>) -> C
    ) {
        self._object = object
        self.builder = builder
    }
}
