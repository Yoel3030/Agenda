//
//  AgendaView.swift
//  Agenda
//
//  Created by Yoel Jacho on 19/1/23.
//

import SwiftUI

struct EventResponseModel: Decodable{
    let name: String?
    let date: Int?
    
    enum CodingKeys: String, CodingKey{
        case name
        case date
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let date = try? values.decodeIfPresent(Int.self, forKey: .date) {
            self.date = date
        } else if let date = try? values.decodeIfPresent(String.self, forKey: .date) {
            self.date = Int(date)
        } else if let _ = try? values.decodeIfPresent(Float.self, forKey: .date) {
            self.date = nil
        } else {
            self.date = try values.decodeIfPresent(Int.self, forKey: .date)
        }
        
        self.name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct EventPresentationModel: Identifiable {
    let id = UUID()
    let name: String
    let date: Int
}


struct AgendaView: View {
    
    @State var dateSelected: Date = Date()
    @State var events: [EventPresentationModel] = []
    @State var shouldShowNewEvent = false
    
    let day = Date()
    let dateFormatter = DateFormatter()
    
    
    
    var body: some View {
        ZStack{
            Color.indigo.ignoresSafeArea()
            
            VStack{
                VStack(spacing: 10){
                    
                    Image("Agenda")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.top, 20)
                    
                    Text("Events")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .bold))
                    
                }
                .padding(.bottom, 5)
                
                ScrollView{
                    LazyVStack(spacing: 1) {
                        ForEach(events) { event in
                            HStack{
                                /*@START_MENU_TOKEN@*/Text(event.name)/*@END_MENU_TOKEN@*/
                                Spacer()
                                Text("\(event.date)")
                            }
                            .padding(.horizontal, 5)
                            .frame(height: 40)
                            .background(Color.white)
                            .cornerRadius(5)
                            .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.bottom, 5)
            }
        }
        .sheet(isPresented: $shouldShowNewEvent, content: {
            NewEventView(shouldShowNewEvent: $shouldShowNewEvent){
                getEvents()
            }
        })
        .toolbar{
            Button {
                shouldShowNewEvent = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 15))
            }
            .accentColor(.white)
        }
        .onAppear {  
            getEvents()
        }
    }
    
    
    
    // MARK: - Private Methods
    
    // Llamada a la petición de NetworkHelper que pronto pasaremos a viewModel
    func getEvents(){
        
        
        //baseUrl + endpoint
        let url = "https://superapi.netlify.app/api/db/eventos"
        
        //peticion
        NetworkHelper.shared.requestProvider(url: url, type: .GET){ data, response, error in
            if let error = error{
                onError(error: error.localizedDescription)
            } else if let data = data, let response = response as? HTTPURLResponse{
                if response.statusCode == 200 { //esto daria ok
                    onSuccess(data: data)
                } else {
                    onError(error: error?.localizedDescription ?? "Request Error")
                }
            }
        }
    }
    
    func onSuccess(data: Data){
        do{
            let eventsNotFiltered = try JSONDecoder().decode([EventResponseModel?].self, from: data)
            
            self.events = eventsNotFiltered.compactMap({ eventNotFiltered in
                guard let date = eventNotFiltered?.date else { return nil }
                
                return EventPresentationModel(name: eventNotFiltered?.name ?? "Empty name", date: date)
            })
        }catch{
            self.onError(error: error.localizedDescription)
        }
    }
    
    func onError(error: String){
        print(error)
    }
}

struct AgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaView()
    }
}
