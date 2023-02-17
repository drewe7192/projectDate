////
////  TitleView.swift
////  projectDate
////
////  Created by dotZ3R0 on 11/6/22.
////
//
//import SwiftUI
//
//struct TitleView: View {
//    @StateObject var viewRouter = ViewRouter.shared
//    @State var showSignInView = false
//    @State var showSignUpView = false
//    
//    var body: some View {
//        NavigationView{
//            GeometryReader{geoReader in
//                ZStack{
//                    //Background Color
//                    LinearGradient(gradient: Gradient(colors: [.teal, .teal, .pink]), startPoint: .top, endPoint: .bottom)
//                        .ignoresSafeArea()
//                    
//                    VStack{
//                        logo
//                        Spacer()
//                            .frame(height: 70)
//                        buttons
//                    }
//                }.position(x: geoReader.frame(in: .local).midX , y: geoReader.frame(in: .local).midY )
//            }
//        }
//    }
//    
//    private var logo: some View {
//        VStack{
//            LogoView()
//            
//            VStack(spacing: 20){
//                Text("Logo Title")
//                    .font(.title.bold())
//                
//                Text("Short app description  gdfsgdf gfd gfsd gfd gf g  gfd gfd gdf gdf g")
//                    .font(.title2)
//                    .multilineTextAlignment(.center)
//            }
//        }
//        .padding()
//    }
//    
//    private var buttons: some View {
//        VStack{
//            // These navLinks provides padding.. cant be avoided it seems
//            NavigationLink(destination: SignInView(), isActive: $showSignInView) {}
//            NavigationLink(destination: SignUpView(), isActive: $showSignUpView) {}
//            
//            Button(action: {
//                showSignInView = true
//            }) {
//                Text("Sign In")
//                    .bold()
//                    .foregroundColor(.black)
//                    .frame(width: 350, height: 60)
//                    .background(.white)
//                    .cornerRadius(15)
//                    .shadow(radius: 5)
//            }
//            
//            Spacer()
//                .frame(height: 20)
//           
//            
//            Button(action: {
//                showSignUpView = true
//            }) {
//                Text("Sign Up")
//                    .bold()
//                    .foregroundColor(.white)
//                    .frame(width: 350, height: 60)
//                    .shadow(radius: 5)
//                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(.white, lineWidth: 2))
//            }
//           
//        }
//    }
//}
//
//struct TitleView_Previews: PreviewProvider {
//    static var previews: some View {
//        TitleView()
//    }
//}
