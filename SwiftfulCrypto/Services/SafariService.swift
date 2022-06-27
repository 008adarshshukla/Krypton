//
//  SafariView.swift
//  SwiftfulCrypto
//
//  Created by KANISHK VIJAYWARGIYA on 07/04/22.
//

import SwiftUI
import SafariServices

struct SafariService: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariService>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariService>) {

    }

}
