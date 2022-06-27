//
//  XMarkButton.swift
//  Krypton
//
//  Created by Adarsh Shukla on 29/03/22.
//

import SwiftUI

struct XMarkButton: View {
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var action: () -> () = {}
    static var previews: some View {
        XMarkButton(action: action)
    }
}
