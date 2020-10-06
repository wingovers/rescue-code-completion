//
//  DragDropView.swift
 
//
//  Created by Ryan on 11/1/20.
//

import SwiftUI

struct DragDropImporterView: View {
    let type: ImporterType
    @ObservedObject var vm: ImporterVM

    @State var showImporterOverlay = false

    var body: some View {
        Group {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
        }
            .foregroundColor(showImporterOverlay ? .pink : .clear)
            .opacity(showImporterOverlay ? 0.5 : 0)
        .onDrop(of: [.folder, .application, .fileURL], isTargeted: $showImporterOverlay) { providers in
            if vm.canImportFrom(providers) {
                showImporterOverlay = true
                vm.importFrom(providers, for: type)
                return true
            } else { return false }
        }
    }
}
