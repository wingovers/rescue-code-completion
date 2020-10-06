//
//  DeleteOptionsListView.swift
//  Rescue Code Completion
//
//  Created by Ryan on 11/4/20.
//

import SwiftUI

struct DeleteOptionsListView: View {
    @ObservedObject var vm: DeleteOptionsListVM

    @State var hoveringDeletePermanently = false
    @State var hoveringMoveToTrash = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker(selection: optionDeletePermanently,
                       label: EmptyView()) {
                    Text(vm.deletePermanentlyText)
                        .padding(.leading, 5)
                        .tag(true)
                        .brightness(hoveringDeletePermanently
                                        ? .brightenOnHover
                                        : 0)
                        .onHover { hoveringDeletePermanently = $0 }
                    Text(vm.moveToTrashText)
                        .padding(.leading, 5)
                        .tag(false)
                        .brightness(hoveringMoveToTrash ? 0.15 : 0)
                        .onHover { hoveringMoveToTrash = $0 }

                }
                .pickerStyle(InlinePickerStyle())
                HStack { Spacer() }
            }.padding(.horizontal)
        }
        .padding(.top, 8)
    }

    var optionDeletePermanently: Binding<Bool> {
        Binding<Bool>(
            get: { vm.deletesPermanently },
            set: { newValue in withAnimation { vm.setShouldDeletePermanently(to: newValue) } }
        )
    }
}
