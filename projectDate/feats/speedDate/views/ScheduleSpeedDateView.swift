//
//  speedDateInfoView.swift
//  projectDate
//
//  Created by DotZ3R0 on 4/4/23.
//

import SwiftUI

// helps with decoding a json array
public struct Throwable<T: Decodable>: Decodable {
    public let result: Result<T,Error>
    
    public init(from decoder: Decoder) throws {
        let catching = { try T(from: decoder) }
        result = Result(catching: catching)
    }
}

struct ScheduleSpeedDateView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject var viewModel = HomeViewModel()
    
   // @State private var date = Date()
    
    var body: some View {
        ZStack{
            Color.iceBreakrrrBlue
                .ignoresSafeArea()
            VStack{
                Text("Pick a date for SpeedDate!")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                
                DatePicker(
                    "",
                    selection: $viewModel.newSpeedDate.eventDate,
                    in: Date().addingTimeInterval(200000)...
                )
                .scaleEffect(1.5)
                .labelsHidden()
                
                VStack{
                    Button(action: {
                        createSpeedDate()
                    }) {
                        Text("Schedule SpeedDate!")
                            .bold()
                            .frame(width: 300, height: 70)
                            .background(Color.mainGrey)
                            .foregroundColor(.iceBreakrrrBlue)
                            .font(.system(size: 20))
                            .cornerRadius(20)
                            .shadow(radius: 8, x: 10, y:10)
                            .opacity(viewModel.newSpeedDate.eventDate != Date() ? 1 : 0.5)
                    }
                }
                .padding(.top,50)
            }
        }
    }
    
    private func createRoom(completed: @escaping (_ roomId: String) -> Void) {
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/createRoom") else { fatalError("Missing URL") }
        
        let json: [String: Any]  = [
            "name": "room_\(UUID().uuidString)",
            "description": "This is a sample description for the room",
            "template_id": "638d9d1b2b58471af0e13f08",
            "region": "us"
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData
        urlRequest.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed("")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        //let decodedUsers = try JSONDecoder().decode(Response.self, from: data)
                        let roomId = String(data:data, encoding: .utf8)
                        viewModel.newSpeedDate.roomId = roomId!
                        completed(viewModel.newSpeedDate.roomId)
                    } catch let error {
                        completed("")
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    private func getRoomCodes(completed: @escaping (_ roomCodes: [Any]) -> Void) {
        guard let url = URL(string: "https://us-central1-projectdate-a365b.cloudfunctions.net/getRoomCodes?room_id=\(viewModel.newSpeedDate.roomId)") else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                completed([])
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedRoles = try JSONDecoder().decode(RolesModel.self, from: data)
//                        decodedRoles.roles.forEach{ x in
//                            viewModel.rolesForRoom.append(x.role)
//
//                            //print("this is the role")
//                           // print(x)
//                        }
                        viewModel.newSpeedDate.maleRoomCode = viewModel.rolesForRoom[0] as! String
                        viewModel.newSpeedDate.femaleRoomCode = viewModel.rolesForRoom[1] as! String
                        completed(viewModel.rolesForRoom)
                    } catch let error {
                        completed([])
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    private func createSpeedDate() {
        createRoom(){ (roomId) -> Void in
            if roomId != "" {
                getRoomCodes(){ (roomCodes) -> Void in
                    if !roomCodes.isEmpty {
                        viewModel.saveSpeedDate()
                        viewRouter.currentPage = .speedDateConfirmationPage
                    }
                }
            }
        }
    }
}

struct ScheduleSpeedDateView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSpeedDateView()
    }
}

