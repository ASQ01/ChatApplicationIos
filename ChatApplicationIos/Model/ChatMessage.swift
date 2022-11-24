//
//  ChatMessage.swift
//  ChatApplicationIos
//
//  Created by Álvaro Antonio Suárez Quintana on 19/11/22.
//

import Foundation

struct ChatMessage : Identifiable{
    let message, from, to, documentID : String
    
    var id : String { documentID }
    
    init(documentID: String, data: [String : Any]){
        self.documentID = documentID
        self.from = data["from"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.to = data["to"] as? String ?? ""
    }
}
