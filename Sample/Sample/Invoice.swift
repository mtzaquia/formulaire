//
//  Invoice.swift
//  Sample
//
//  Created by Mauricio Tremea Zaquia on 18/11/2025.
//

import Formulaire
import Foundation
import SwiftUI

@Observable @Formulaire
final class Invoice: CustomStringConvertible {
    var number: Int = 1
    var date: Date = Date()
    var client: Client?
//    var items: IdentifiedArrayOf<InvoiceItem> = []

    func validate() {
        if number < 1 {
            addError("Number must be greater than zero.", for: \.number)
        }

        if client == nil {
            addError("A client is required.", for: \.client)
        }

        validate(\.client)

//        if items.isEmpty {
//            addError("At least one item is required.", for: \.items)
//        }

//        validate(\.items)
    }

    var description: String {
        "Invoice"
        + "\n - \(number)"
        + "\n - \(date)"
        + "\n - \(client)"
//        + "\n - \(items)"
    }
}

@Observable @Formulaire
final class InvoiceItem: Identifiable {
    var id: String = UUID().uuidString

    var summary: String = ""
    var description: String = ""
    var amount: Decimal = .zero

    func validate() {
        if summary.isEmpty {
            addError("The summary must not be empty.", for: \.summary)
        }
    }
}

@Observable @Formulaire
final class Client: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String = ""

    func validate() {
        if name.isEmpty {
            addError("A name is required.", for: \.name)
        }
    }
}

func == (lhs: Client, rhs: Client) -> Bool {
    lhs.id == rhs.id
}

extension Hashable where Self: Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct InvoiceForm: View {
    @State var invoice = Invoice()

    let sampleClients: [Client] = [
        { let c1 = Client(); c1.name = "Sample 1"; return c1 }(),
        { let c2 = Client(); c2.name = "Sample 2"; return c2 }(),
        { let c3 = Client(); c3.name = "Sample 3"; return c3 }(),
    ]

    @State var hasErrors = false

    var body: some View {
        FormulaireView(editing: $invoice) { form in
            Section {
                form.stepper(for: \.number, label: "Invoice number")
                form.control(for: \.date, focusable: false) { builder in
                    VStack {
                        DatePicker("Date", selection: builder.$value, displayedComponents: .date)

                        if let error = builder.error {
                            Text(error.localizedDescription)
                                .foregroundStyle(.red)
                        }
                    }
                }
                form.control(for: \.client, focusable: false) { builder in
                    VStack(alignment: .leading) {
                        Picker("Client", selection: builder.$value) {
                            if builder.value == nil {
                                Text("Pick...")
                                    .tag(nil as Client?)
                            }
                            ForEach(sampleClients) { client in
                                Text(client.name)
                                    .tag(client as Client?)
                            }
                        }

                        if let error = builder.error {
                            Text(error.localizedDescription)
                                .foregroundStyle(.red)
                        }
                    }

                    if builder.value != nil {
                        Button(
                            action: { builder.value = nil },
                            label: {
                                Label("Clear", systemImage: "xmark.circle")
                            }
                        )
                    }
                }

            }

//            Section {
//                forEach(form: form)
//
//                Button("Add") {
//                    invoice.items.append(.init())
//                }
//            }

            Section {
                LabeledContent("Has errors", value: hasErrors ? "Yes" : "No")
                Button("Validate") {
                    hasErrors = !form.validate()
                }
            }
        }
    }

    @ViewBuilder
    func forEach(form: FormulaireBuilder<Invoice>) -> some View {
//        ForEach(invoice.items) { item in
//            form.textField(for: \.[items: item.id].summary, label: "Summary")
//        }
//        .onDelete { offsets in
//            invoice.items.remove(atOffsets: offsets)
//        }
    }
}
