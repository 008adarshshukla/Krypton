//
//  String.swift
//  Krypton
//
//  Created by Adarsh Shukla on 07/04/22.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
