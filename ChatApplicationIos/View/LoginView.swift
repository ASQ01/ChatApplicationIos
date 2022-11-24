//
//  ContentView.swift
//  ChatApplicationIos
//
//  Created by Álvaro Antonio Suárez Quintana on 18/11/22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var loggin : Bool = true
    @State var statusMessage : String = ""
    @State var email : String = ""
    @State var password : String = ""
    @State var name : String = ""
    @State var toContacts : Bool = false
    
    var body: some View {
        NavigationView {
            Color(red: 0.9, green: 0.95, blue: 0.95).ignoresSafeArea()
                .overlay(
                    
                    ScrollView {
                        VStack{
                            
                            NavigationLink(
                                destination: ContactsView()
                                    .navigationBarTitle("")
                                    .navigationBarHidden(true),
                                isActive: $toContacts
                            ) {
                                EmptyView()
                            }
                            
                            Picker(selection: $loggin, label: Text("Picker")){
                                Text("Inicar sesión")
                                    .tag(true)
                                Text("Registrarse")
                                    .tag(false)
                            }.pickerStyle(.segmented)
                            .padding()
                            
                            if loggin {
                                
                                TextField("Email: ", text: $email).textInputAutocapitalization(.never)
                                    .padding()
                                    .background(.white)
                                    .padding(.bottom, 15)
                                    .padding(.top, 15)
                                SecureField("Contraseña: ", text: $password).textInputAutocapitalization(.never)
                                    .padding()
                                    .background(.white)
                                Button{
                                    handleButton()
                                }label: {
                                    HStack{
                                        Spacer()
                                        Text("Iniciar sesión")
                                        Spacer()
                                    }.padding(.vertical, 10)
                                        .background(Color(red: 1, green: 0.5, blue: 1))
                                        .cornerRadius(100)
                                        .foregroundColor(.white).padding(.horizontal, 100)
                                    
                                }.padding(.top, 25)
                                
                                Text(statusMessage)
                                
                            }
                            
                            else {
                                
                                TextField("Nombre: ", text: $name).textInputAutocapitalization(.never)
                                    .padding()
                                    .background(.white)
                                    .padding(.top, 15)
                                
                                TextField("Email: ", text: $email).textInputAutocapitalization(.never)
                                    .padding()
                                    .background(.white)
                                    .padding(.bottom, 15)
                                    .padding(.top, 15)
                                
                                SecureField("Contraseña: ", text: $password).textInputAutocapitalization(.never)
                                    .padding()
                                    .background(.white)
                                
                                Button{
                                    handleButton()
                                } label: {
                                    HStack{
                                        Spacer()
                                        Text("Crear cuenta")
                                        Spacer()
                                    }.padding(.vertical, 10)
                                        .background(Color(red: 1, green: 0.5, blue: 1)).foregroundColor(.white)
                                        .cornerRadius(100)
                                        .padding(.horizontal, 100)
                                    
                                }.padding(.top, 25)
                                
                                Text(statusMessage)
                            }
                            
                            
                        }.padding()
                        
                        
                    }.navigationTitle(loggin ? "Inicia Sesión" : "Regístrate")
                
                )
        }
    }
    
    private func handleButton() {
        if loggin {
            logToAccount()
        }else{
            createAccount()
        }
    }
    
    private func logToAccount () {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, err in
            if let err = err {
                statusMessage = "\(err)"
                return
            }
            statusMessage = "Se ha iniciado sesión"
            toContacts.toggle()
        }
    }
    
    private func createAccount () {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result, err in
            if let err = err {
                statusMessage = "\(err)"
                return
            }
            statusMessage = "Usuario creado satisfactoriamente"
            storeUser()
            toContacts.toggle()
        }
    }
    
    private func storeUser(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        FirebaseManager.shared.firestore.collection(FirebaseConstants.users).document(uid).setData([FirebaseConstants.name:name, FirebaseConstants.email:email, FirebaseConstants.uid:uid])
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
