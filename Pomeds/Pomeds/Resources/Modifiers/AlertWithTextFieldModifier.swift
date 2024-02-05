//
//  AlertWithTextFieldModifier.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/4/24.
//

import SwiftUI

struct AlertWithTextFieldModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var text: String
    var title: String
    var message: String?
    var placeholder: String
    var onCompleted: (String) -> Void
    var doneButtonTitle: String
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                TextField(placeholder, text: $text)
                Button(doneButtonTitle, action: { onCompleted(text) })
                Button("취소", role: .cancel, action: {})
            } message: {
                Text(message ?? "")
            }
    }
}

extension View {
    func alertWithTextField(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        text: Binding<String>,
        placeholder: String = "",
        doneButtonTitle: String,
        onCompleted: @escaping (String) -> Void) -> some View
    {
        modifier(AlertWithTextFieldModifier(isPresented: isPresented, text: text, title: title, message: message, placeholder: placeholder, onCompleted: onCompleted, doneButtonTitle: doneButtonTitle))
    }
}
