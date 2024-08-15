//
//  MultipeerView.swift
//  WBSenior
//
//  Created by Вадим on 15.08.2024.
//

import SwiftUI

struct MultipeerView: View {
    @StateObject
    private var multipeerManager = MultipeerManager()
    
    @State
    private var newMessage = ""
    
    var body: some View {
        VStack {
            List(multipeerManager.messages, id: \.self) { message in
                Text(message)
            }
            
            HStack {
                TextField("Enter message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    multipeerManager.send(message: newMessage)
                    newMessage = ""
                }) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
