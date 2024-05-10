//
//  EventEditView.swift
//  APCDigital SwiftUI
//
//  Created by Shin Inaba on 2024/05/09.
//

import SwiftUI

struct EventEditView: View {
    @State var title: String = ""
    
    var body: some View {
        Form {
            TextField("Title", text: self.$title)
        }
    }
}

#Preview {
    EventEditView()
}
