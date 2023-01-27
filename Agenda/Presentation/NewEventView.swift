//
//  NewEventView.swift
//  Agenda
//
//  Created by Yoel Jacho on 20/1/23.
//

import SwiftUI

struct NewEventView: View {
    
    @State var newDate: Date = Date()
    @State var name: String = ""
    @Binding var shouldShowNewEvent: Bool
    
    var completion: () -> () = {}
    
    var body: some View {
        ZStack{
            Color.indigo.ignoresSafeArea()
            
            VStack {
                Text("New Event")
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 20)
                
                DatePicker("", selection: $newDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .background(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 15)
                
                Text("Write the event")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 30)
                    .padding(.top,15)
                
                TextField("Event", text: $name)
                    .frame(height: 45)
                    .padding(.horizontal, 15)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 15)
                
                Spacer()
                
                Button {
                    createEvent()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(30)
                        .padding(.horizontal, 165)
                        .padding(.top, 40)
                }
            }
        }
    }
    
    private func postEvents(name: String, date: Int){
        
        
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/db/eventos"
        
        let dictionary: [String: Any ] = [
            "name" : name,
            "date" : date
        ]
        
        //peticion
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
    
    func createEvent(){
        postEvents(name: name, date: convertDateToInt(date: newDate))
    }
    
    func onSuccess(){
        completion()
        shouldShowNewEvent = false
    }
    
    func convertDateToInt(date: Date) -> Int{
        let intDate = Int(date.timeIntervalSince1970 * 1000)
        return intDate
    }
    
    func onError(error: String){
        print(error)
    }
    
}

struct NewEventView_Previews: PreviewProvider {
    static var previews: some View {
        NewEventView(shouldShowNewEvent: .constant(true))
    }
}
