//
//  ContentView.swift
//  Agenda
//
//  Created by Yoel Jacho on 10/1/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var email: String = ""
    @State var pass: String = ""
    
    
    @State var shouldShowRegister: Bool = false
    @State var shouldShowAgenda: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.indigo
                    .ignoresSafeArea()
                
                VStack {
                    Image("Agenda")
                        .padding(.top, 80)
                    
                    Text("Log in")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top, 20)
                    
                    Text("Email")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top,15)
                    
                    TextField("Email", text: $email)
                        .frame(height: 45)
                        .padding(.horizontal,10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                    
                    Text("Password")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 30)
                        .padding(.top,15)
                    
                    SecureField("Password", text: $pass)
                        .frame(height: 45)
                        .padding(.horizontal,10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                    
                    Spacer()

                    Button {
                        //TODO: - Login Action
                        login(email: email, pass: pass)
                    } label: {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(30)
                            .padding(.horizontal, 40)
                    }
                    .background(
                        NavigationLink(destination: AgendaView(), isActive: $shouldShowAgenda) {
                            EmptyView()
                        })
                    
                    HStack{
                        Text("Don't have an account?")
                        
                        NavigationLink {
                            RegisterView()
                        } label: {
                            Text("Register")
                            .foregroundColor(.white)
                            .frame(height: 60)
                        }
                    }

                }
            }
        }.accentColor(.white)
    }
    
    
    // MARK: - Private Methods
    
    // Llamada a la petición de NetworkHelper que pronto pasaremos a viewModel
    func login(email: String, pass: String) {
        
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/login"
        
        //params
        let dictionary: [String: Any] = [
            "user" : email,
            "pass" : pass
        ]
        
        // petición
        NetworkHelper.shared.requestProvider(url: url, params: dictionary) { data, response, error in
            if let error = error {
                onError(error: error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 200 { // esto daria ok
                    onSuccess()
                } else { // esto daria error
                    onError(error: error?.localizedDescription ?? "Request Error")
                }
            }
        }
    }
    
    func onSuccess(){
        // TODO: - Go to Agenda
        shouldShowAgenda = true
    }
    
    func onError(error: String){
        print(error)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//comentario 
