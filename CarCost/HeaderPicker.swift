//
//  HeaderPicker.swift
//  CarCost
//
//  Created by macbook on 29.01.2023.
//

import SwiftUI

struct HeaderPicker: View {
    let sections : [String]
    @Binding var selectedSection: String
    
    var body: some View {
        Picker("", selection: $selectedSection, content: {
            ForEach(self.sections, id: \.self, content: {
                Text($0)
            })
        })
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct HeaderPicker_Previews: PreviewProvider {
    static var previews: some View {
        HeaderPicker(sections: ["All", "Fuel", "Service", "Other"], selectedSection: Binding.constant("Fuel"))
    }
}
