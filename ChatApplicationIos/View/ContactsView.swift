//
//  MessagesView.swift
//  ChatApplicationIos
//
//  Created by Álvaro Antonio Suárez Quintana on 19/11/22.
//

import SwiftUI
import Firebase

class ContactsViewModel : ObservableObject {
    @Published var users = [ChatUser]()
    @State var errorMessage = ""
    @State var currentUser : String = ""
    
    init(){
        fetchAllUsers()
    }
    
    private func fetchAllUsers(){
        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
            .getDocuments { snapshotDocument, error in
                if let error = error{
                    self.errorMessage = error.localizedDescription
                    return
                }
                snapshotDocument?.documents.forEach({ snapshot in
                    let toAdd = ChatUser(data: snapshot.data())
                    self.users.append(toAdd)
                })
            }
    }
}

struct ContactsView: View {
    @State var logoutOptions : Bool = false
    @ObservedObject var vm = ContactsViewModel()
    @State var toChat : Bool = false
    @State var desiredUser : ChatUser = ChatUser(data: [FirebaseConstants.name:"", FirebaseConstants.email:"", FirebaseConstants.uid:""])
    
    var body: some View {
        NavigationView {Color(red: 0.9, green: 0.95, blue: 0.95)
                .ignoresSafeArea()
                .overlay(

                    ScrollView {

                        VStack{

                            NavigationLink("", isActive: $toChat){
                                ChatView(chatUser: desiredUser)
                            }.labelsHidden().hidden()


                            ForEach(vm.users) { user in

                                if (user.uid != FirebaseManager.shared.auth.currentUser?.uid) {
                                    Button {
                                        accessChat(clickedUser: user)
                                    } label: {
                                        HStack{
                                            Spacer()
                                            Text(user.name).font(.system(size: 23))
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color(red: 0/255, green: 101/255, blue: 106/255))
                                            Spacer()
                                        }.padding(.vertical, 15)
                                            .background(Color(red: 202/255, green: 202/255, blue: 226/255))
                                            .cornerRadius(15)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 20)

                                    }.padding(.top, 25)
                                }
                            }

                        }.frame(width: UIScreen.main.bounds.size.width)

                    }

                )
            
        }
    }
    
    private func accessChat(clickedUser: ChatUser){
        desiredUser = clickedUser
        toChat.toggle()
    }
    
}
 
struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
