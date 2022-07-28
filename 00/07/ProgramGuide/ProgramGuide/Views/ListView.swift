//
//  ListView.swift
//  ProgramGuide
//

import SwiftUI

struct ListView: View {
    var body: some View {
        List {
            ForEach(ProgramModels) { prog in
                Text(prog.id)
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
