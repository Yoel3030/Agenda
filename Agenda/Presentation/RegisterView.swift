//
//  RegisterView.swift
//  Agenda
//
//  Created by Yoel Jacho on 12/1/23.
//

import SwiftUI

struct RegisterView: View {
    
    // MARK: - Private Properties
    
    @State private var email: String = ""
    @State private var pass: String = ""
    
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    // MARK: - Body

    var body: some View {
        
        NavigationView {
            
            ZStack{
                Color.indigo
                    .ignoresSafeArea()
                
                VStack {
                    Image("Agenda")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.top, 20)
                    
                    Text("Register")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                        .padding(.top, 20)
                    
                    TextField("Email", text: $email)
                        .frame(height: 45)
                        .padding(.horizontal,10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.top)
                    
                    TextField("Password", text: $pass)
                        .frame(height: 45)
                        .padding(.horizontal,10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.top)
                    
                    Spacer()
                    
                    Button {
                        register(email: email, pass: pass)
                    } label: {
                        Text("Register")
                            .foregroundColor(.white)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(30)
                            .padding(.horizontal, 40)
                    }
                    
                    
                    HStack{
                        Text("Already have an account?")
                        
                        Button {
                            self.mode.wrappedValue.dismiss()
                        } label: {
                            Text("Log in")
                            .foregroundColor(.white)
                            .frame(height: 60)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    // MARK: - Private Methods
    
    // Llamada a la petición de NetworkHelper que pronto pasaremos a viewModel
    private func register(email: String, pass: String) {
        
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/register"
        
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
        //navegacion hacia atras
        mode.wrappedValue.dismiss()
    }
    
    func onError(error: String){
        print(error)
    }
}



struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
