//
//  SnapshotView.swift
//  GatorScout
//
//  Created by Anaika Walia on 11/19/24.
//


import SwiftUI
import UIKit

struct SnapshotView<Content: View>: UIViewRepresentable {
    let content: Content
    let completion: (UIImage?) -> Void

    init(content: Content, completion: @escaping (UIImage?) -> Void) {
        self.content = content
        self.completion = completion
    }

    func makeUIView(context: Context) -> UIView {
        let hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            UIGraphicsBeginImageContextWithOptions(uiView.bounds.size, false, 0)
            uiView.drawHierarchy(in: uiView.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(image)
        }
    }
}
