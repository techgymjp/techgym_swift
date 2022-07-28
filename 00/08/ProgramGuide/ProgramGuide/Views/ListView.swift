//
//  ListView.swift
//  ProgramGuide
//

import SwiftUI

struct ListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(ProgramModels) { prog in
                    NavigationLink(destination: DetailView(programModel:prog)) {
                        Text(prog.id)
                    }
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
