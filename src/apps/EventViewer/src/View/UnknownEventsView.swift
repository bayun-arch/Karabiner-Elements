import SwiftUI

struct UnknownEventsView: View {
    @ObservedObject var eventHistory = EventHistory.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            GroupBox(label: Text("Showing events that are not supported by Karabiner-Elements")) {
                VStack(alignment: .leading, spacing: 6.0) {
                    if eventHistory.unknownEventEntries.count == 0 {
                        Divider()
                        Spacer()
                    } else {
                        HStack(alignment: .center, spacing: 12.0) {
                            Button(action: {
                                eventHistory.copyToPasteboardUnknownEvents()
                            }) {
                                Label("Copy to pasteboard", systemImage: "arrow.right.doc.on.clipboard")
                            }

                            Button(action: {
                                eventHistory.clearUnknownEvents()
                            }) {
                                Label("Clear", systemImage: "clear")
                            }

                            Spacer()
                        }

                        ScrollViewReader { proxy in
                            ScrollView {
                                VStack(alignment: .leading, spacing: 0.0) {
                                    // swiftformat:disable:next unusedArguments
                                    ForEach($eventHistory.unknownEventEntries) { $entry in
                                        HStack(alignment: .center, spacing: 0) {
                                            Text(entry.eventType)
                                                .font(.title)
                                                .frame(width: 70, alignment: .leading)

                                            Spacer()

                                            VStack(alignment: .trailing, spacing: 0) {
                                                if entry.usagePage.count > 0 {
                                                    HStack(alignment: .bottom, spacing: 0) {
                                                        Text("usage page: ")
                                                            .font(.caption)
                                                        Text(entry.usagePage)
                                                    }
                                                }
                                                if entry.usage.count > 0 {
                                                    HStack(alignment: .bottom, spacing: 0) {
                                                        Text("usage: ")
                                                            .font(.caption)
                                                        Text(entry.usage)
                                                    }
                                                }
                                            }
                                            .frame(alignment: .leading)
                                        }
                                        .padding(.horizontal, 12.0)

                                        Divider().id("divider \(entry.id)")
                                    }

                                    Spacer()
                                }
                            }
                            .background(Color(NSColor.textBackgroundColor))
                            .onAppear {
                                if let last = eventHistory.unknownEventEntries.last {
                                    proxy.scrollTo("divider \(last.id)", anchor: .bottom)
                                }
                            }
                            .onChange(of: eventHistory.unknownEventEntries) { newEntries in
                                if let last = newEntries.last {
                                    proxy.scrollTo("divider \(last.id)", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .padding(6.0)
            }
        }
        .padding()
    }
}

struct UnknownEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UnknownEventsView()
    }
}
