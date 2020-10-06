//
//  ImporterViews.swift
 
//
//  Created by Ryan on 10/19/20.
//

import SwiftUI



struct ImporterView: View {
    let type: ImporterType
    @ObservedObject var vm: ImporterVM

    @State var showImporter = false
    var showTipText: Bool {
        switch type {
            case .Xcode: return vm.showAppsTipText
            case .directories: return vm.showDirectoriesTipText
            case .projects: return vm.showProjectsTipText
        }
    }

    var body: some View {
        Button { showImporter.toggle() }
            label: { buttonLabel }
            .buttonStyle(PlainButtonStyle())
            .onHover { hovering in
                withAnimation { isHovering = hovering }
            }
            .fileImporter(isPresented: $showImporter,
                          allowedContentTypes: type == .Xcode ? [.application] : [.folder],
                          allowsMultipleSelection: false) {
                vm.add(type: type, $0)
            }

    }

    @State var isHovering = false
    @State var shouldAnimateHelpTip = false

    var buttonLabel: some View {
        Image(systemName: vm.addButtonSymbol)
            .foregroundColor(isHovering
                                ? .hoverBlue
                                : .textMoreFaded
                                )
            .font(isHovering
                    ? .prefsItemHeader
                    : .prefsItemCaption
            )
            .padding(.trailing, 6)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
            .background(ImporterHelpTipAnimation(animate: $shouldAnimateHelpTip,
                                                 hovering: $isHovering),
                        alignment: .center)
            .onAppear { shouldAnimateHelpTip = showTipText }
            .onChange(of: showTipText) { shouldAnimateHelpTip = $0 }
    }
}

