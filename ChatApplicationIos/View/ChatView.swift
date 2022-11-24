//
//  ChatView.swift
//  ChatApplicationIos
//
//  Created by Álvaro Antonio Suárez Quintana on 19/11/22.
//

import SwiftUI
import Firebase 

class ChatModelView : ObservableObject {
    @State var errorMessage : String = ""
    let chatUser : ChatUser?
    @Published var chatLog = [ChatMessage]()
    
    init (chatUser: ChatUser){
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    func handleSend(messageToSend : String){
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else{ return }
        
        let documentFrom = FirebaseManager.shared.firestore.collection(FirebaseConstants.chats).document(fromId).collection(toId).document()
        
        let documentTo = FirebaseManager.shared.firestore.collection(FirebaseConstants.chats).document(toId).collection(fromId).document()
        
        let messageData = [FirebaseConstants.message : messageToSend, FirebaseConstants.from:fromId, FirebaseConstants.to:toId, FirebaseConstants.timestamp:Timestamp()] as [String : Any]
        
        documentFrom.setData(messageData)
        documentTo.setData(messageData)
        
    }
    
    private func fetchMessages() {
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        guard let toId = chatUser?.uid else{ return }
        
        if toId == "" || toId == nil{
            return
        }
        
        if fromId == "" || fromId == nil{
            return
        }
        
        FirebaseManager.shared.firestore.collection(FirebaseConstants.chats)
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.chatLog.removeAll()
                querySnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let documentId = snapshot.documentID
                    self.chatLog.append(.init(documentID: documentId, data: data))
                })
            }
    }
    
}

struct ChatView : View {
    let chatUser : ChatUser?
    @State var textToSend : String = ""
    @ObservedObject var cm : ChatModelView
    
    init (chatUser : ChatUser){
        self.chatUser = chatUser
        cm = ChatModelView(chatUser: chatUser)
    }
    
    var body: some View {
        VStack{
            
            ScrollView{
                
                ForEach (cm.chatLog){ chatMessage in
                    if chatMessage.from == FirebaseManager.shared.auth.currentUser?.uid{
                        HStack{
                            Spacer()
                            HStack{
                                Text(chatMessage.message)
                                    .foregroundColor(.white)
                            }.padding()
                                .background(.blue)
                                .cornerRadius(100)
                                .padding(.horizontal, 5)
                        }
                    }
                    
                    else{
                        HStack{
                            HStack{
                                Text(chatMessage.message)
                                    .foregroundColor(.black)
                            }.padding()
                                .background(.white)
                                .cornerRadius(100)
                                .padding(.horizontal, 5)
                            Spacer()
                        }
                    }
                }
                
                
                HStack{ Spacer() }
                
                
            }.background(Color(red: 0.8, green: 0.85, blue: 0.85))
                .padding(.vertical, 0.5)
            
            HStack{
                TextField("No seas tímid@", text: $textToSend)
                Button{
                    cm.handleSend(messageToSend: textToSend)
                    textToSend = ""
                }label: {
                    Text("enviar")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(.blue)
                        .cornerRadius(100)
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .font(.system(size: 15))
                }
            }.padding()
            
        }.navigationTitle(chatUser?.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let testUser = ChatUser(data: [FirebaseConstants.name:"Walter White", FirebaseConstants.email:"xd", FirebaseConstants.uid:"idprueba"])
        
        NavigationView{
            ChatView(chatUser: testUser)
        }
    }
}
