//
//  PreferenceRow.swift
 
//
//  Created by Ryan on 10/18/20.
//

import SwiftUI

struct PreferencesListRow: View {
    let name: String
    let displayURL: String
    let removeAction: (_ id: UUID) -> Void
    let pinAction: (_ id: UUID) -> Void
    let id: UUID
    let isDefault: Bool
    var showPin = true

    @State var isHoveringDelete = false
    @State var isHoveringPin = false

    var hoverColor: Color {
        if isHoveringDelete { return Color.hoverRedDelete }
        else { return Color(.textColor) }
    }

    var body: some View {
        HStack(alignment: .center) {
            HStack {
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(isHoveringDelete
                                            ? hoverColor
                                            : .textNormal)
                    Text(displayURL)
                        .lineLimit(2)
                        .truncationMode(.middle)
                        .font(.prefsItemCaption)
                        .foregroundColor(isHoveringDelete
                                            ? hoverColor
                                            : .textMoreFaded)
                }
                Spacer()
                if showPin {
                    Image(systemName: isDefault
                        ? Symbols.pinned.name
                        : Symbols.unpinned.name)
                    .foregroundColor(isHoveringDelete
                                        ? hoverColor
                                        : .textMoreFaded)
                    .font(.callout)
                    .opacity(isHoveringPin || isDefault ? 1 : 0)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                    .onTapGesture { pinAction(id) }
                }
            }
            .contentShape(Rectangle())
            .onHover { newValue in
                withAnimation { isHoveringPin = newValue }
            }

            Button { removeAction(id) }
                label: {
                    Text("—")
                        .foregroundColor(isHoveringDelete
                                            ? hoverColor
                                            : .textMoreFaded)
                        .font(.callout)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 6)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { newValue in
                    withAnimation { isHoveringDelete = newValue }

                }
        }
        .brightness(isHoveringPin ? .brightenOnHover : 0)
        .padding(1)
    }
}
