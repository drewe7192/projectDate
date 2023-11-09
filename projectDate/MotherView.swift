//
//  MotherView.swift
//  projectDate
//
//  Created by dotZ3R0 on 9/4/22.
//

import SwiftUI

struct MotherView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var tabSelection = 1
    @State private var timeRemaining = 10
    @State private var showAlert: Bool = false
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //Change the menuBar color to white
    init() {
        UITabBar.appearance().backgroundColor = UIColor.darkGray
    }
    
    var body: some View {
        GeometryReader{geoReader in
            switch viewRouter.currentPage {
            case .homePage :
                TabView(selection: $tabSelection) {
                    //                    LiveView(tabSelection: $tabSelection, showAlert: $showAlert)
                    //                        .tabItem{
                    //                            Label("Live", systemImage: "livephoto")
                    //                        }.tag(1)
                    //                        .onReceive(timer) { time in
                    //                            if timeRemaining > 0 && tabSelection == 1 {
                    //                                timeRemaining -= 1
                    //                            }else if timeRemaining == 0 && tabSelection == 1 {
                    //                                showAlert = true
                    //                                timeRemaining += 10
                    //                            }
                    //                        }
                    //                    EventsView()
                    //                        .tabItem{
                    //                            Label("Events", systemImage: "calendar")
                    //                        }.tag(2)
                    //                    MessageHomeView()
                    //                        .tabItem{
                    //                            Label("Discover", systemImage: "globe")
                    //                        }.tag(4)
                    SettingsView()
                        .tabItem{
                            Label("Settings", systemImage: "gearshape")
                        }.tag(2)
                }
                .frame(height: geoReader.size.height * 1.07)
                
            case .signUpPage :
                SignUpView()
            case .signInPage:
                SignInView()
            case .confirmationPage:
                ConfirmationView(confirmationText: "New card Created")
            case .failedPage:
                FailedView()
            case .scheduleSpeedDatePage:
                ScheduleSpeedDateView()
            case .speedDateConfirmationPage:
                ConfirmationView(confirmationText: "SpeedDate created!")
            case .speedDateEndedPage:
                SpeedDateEndedPage()
            }
        }
    }
    
    struct MotherView_Previews: PreviewProvider {
        static var previews: some View {
            MotherView().environmentObject(ViewRouter())
        }
    }
    
}
