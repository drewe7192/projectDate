//
//  dbFunctions.swift
//  projectDate
//
//  Created by DotZ3R0 on 2/27/23.
//

import Foundation

import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import UIKit

//PLACE in Init liveViewModel()
//getDocs() { (success) -> Void in
//    if !success.isEmpty {
//
//        self.deleteDocs(mostIds:success)
//    }
//}


//   @Published var idsToDelete: [String] = []


//public func deleteDocs(mostIds: [String]){
//    for iidd in mostIds {
//        db.collection("cards").document(iidd).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
//    }
//}
//
//public func getDocs(completed: @escaping (_ success: [String]) -> Void){
//    db.collection("cards")
//        .limit(to: 50)
//        .addSnapshotListener {(querySnapshot, error) in
//            guard let documents = querySnapshot?.documents
//            else{
//                print("No documents")
//                return completed([])
//            }
//            self.idsToDelete = documents.map { $0["id"]! as! String }
//            print("self.idsToDelete: \(self.idsToDelete)")
//            completed(self.idsToDelete)
//        }
//}






//Place this button in the HomeView() and use it to add and delete stuff. Cant put it in the liveViewModel() init() becuase it'll run at least twice.. not sure why

//Button(action: {
////                                    viewModel.getDocs() { (success) -> Void in
////                                        if !success.isEmpty {
////
////                                            viewModel.deleteDocs(mostIds:success)
////                                        }
////                      x              }
//
// //   viewModel.bullshitAddCards()
//}) {
//    Image("googleLogo")
//        .resizable()
//        .frame(width: 35, height: 35)
//}
//.frame(width: 120, height: 50)
//.background(.white)
//.cornerRadius(15)
//.shadow(radius: 5)

//Button(action: {
//    addNewEvents()
//}) {
//    Image("googleLogo")
//        .resizable()
//        .frame(width: 35, height: 35)
//}
//.frame(width: 120, height: 50)
//.background(.white)
//.cornerRadius(15)
//.shadow(radius: 5)




//public func addNewStaticCards(){
//
//    let docRefs = db.collection("cards")
//
//    let id = UUID().uuidString;
//    docRefs.document(id).setData([
//        "id" : id,
//        "question": "Are you close to your family?",
//        "choices": ["Definitely","Kinda","Not really"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id1 = UUID().uuidString;
//    docRefs.document(id1).setData([
//        "id" : id1,
//        "question": "When do you think is the right time to say “I love you”?",
//        "choices": ["Whenever","3-5 months at least","When you talk about future plans"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id2 = UUID().uuidString;
//    docRefs.document(id2).setData([
//        "id" : id2,
//        "question": "Are you friends with your exes?",
//        "choices": ["Nope","Yes","Eh sorta"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id3 = UUID().uuidString;
//    docRefs.document(id3).setData([
//        "id" : id3,
//        "question": "Have you ever had your heart broken?",
//        "choices": ["Who hasn't","I'm heartless","Yes and it sucked"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id4 = UUID().uuidString;
//    docRefs.document(id4).setData([
//        "id" : id4,
//        "question": "Do you want children?",
//        "choices": ["Nope","Of course!","Sure"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id5 = UUID().uuidString;
//    docRefs.document(id5).setData([
//        "id" : id5,
//        "question": "Do you want to get married?",
//        "choices": ["Nope","Of course!","Sure"],
//        "categoryType": "Values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id6 = UUID().uuidString;
//    docRefs.document(id6).setData([
//        "id" : id6,
//        "question": "If you want children, how many children do you want?",
//        "choices": ["1","3+","2 is fine"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id7 = UUID().uuidString;
//    docRefs.document(id7).setData([
//        "id" : id7,
//        "question": "Would you ever go skydiving?",
//        "choices": ["Eh I guess","Already have and want to go again!","Pass I hate heights"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id8 = UUID().uuidString;
//    docRefs.document(id8).setData([
//        "id" : id8,
//        "question": "Would you Rather: Hold my hand or put your arm around my waist?",
//        "choices": ["Eh Im kinda shy","Hand","arm around waist"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id9 = UUID().uuidString;
//    docRefs.document(id9).setData([
//        "id" : id9,
//        "question": "Would you Rather: Kiss in public or kiss in private?",
//        "choices": ["Public","Private","Doesnt matter to me"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//
//
//
//    let id10 = UUID().uuidString;
//    docRefs.document(id10).setData([
//        "id" : id10,
//        "question": "Would you Rather: Go watch a movie or go watch the sunset?",
//        "choices": ["Sunset","Movie","Why not both?"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id11 = UUID().uuidString;
//    docRefs.document(id11).setData([
//        "id" : id11,
//        "question": "Would you Rather: Kiss on the cheek or kiss on the forehead?",
//        "choices": ["Cheek","Dont touch me, dont kiss me","Forehead"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id12 = UUID().uuidString;
//    docRefs.document(id12).setData([
//        "id" : id12,
//        "question": "Would you Rather: Peck on the lips or French kiss?",
//        "choices": ["French kiss of course","Peck on the lips","Baby you can have whatever you like"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id13 = UUID().uuidString;
//    docRefs.document(id13).setData([
//        "id" : id13,
//        "question": "Would you Rather: Cuddle under the stars or cuddle under a blanket?",
//        "choices": ["Neither not a fan of cuddling","Blanket","Under the stars"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id14 = UUID().uuidString;
//    docRefs.document(id4).setData([
//        "id" : id14,
//        "question": "Would you Rather: Slow dance to a romantic song or grind to a fast beat?",
//        "choices": ["Ill try slow dancing","You can find me in the Club grindin","I suck at dancing"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id15 = UUID().uuidString;
//    docRefs.document(id15).setData([
//        "id" : id15,
//        "question": "Would you Rather: Ride bikes together or take a long walk?",
//        "choices": ["Ride bikes","Eh Im not too active","Long Walk"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id16 = UUID().uuidString;
//    docRefs.document(id16).setData([
//        "id" : id16,
//        "question": "Would you Rather: Go to a photo booth or take silly selfies?",
//        "choices": ["Photo botth","Silly Selfies","Both I love taking pics of myself"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id17 = UUID().uuidString;
//    docRefs.document(id17).setData([
//        "id" : id17,
//        "question": "Would you Rather: Me cook you breakfast in bed or a candlelit dinner?",
//        "choices": ["I can cook!","Candlelit dinner","Breakfast in bed"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id18 = UUID().uuidString;
//    docRefs.document(id18).setData([
//        "id" : id18,
//        "question": "Would you Rather: Sing to me or play me a song on guitar? ",
//        "choices": ["Sing Im great at it","I can rap instead","Guitar"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id19 = UUID().uuidString;
//    docRefs.document(id19).setData([
//        "id" : id19,
//        "question": "Would you Rather: Walk on the beach with toes in the sand or take a dip in the water?",
//        "choices": ["Toes in the sand","Dip in the water","Both I love the beach!"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//    let id20 = UUID().uuidString;
//    docRefs.document(id20).setData([
//        "id" : id20,
//        "question": "Would you Rather: Go skinny dipping or dive in fully-clothed?",
//        "choices": ["Skinny Dipping","Fully-Clothed","If im drunk who knows what ill do"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id21 = UUID().uuidString;
//    docRefs.document(id21).setData([
//        "id" : id21,
//        "question": "Would you Rather: Draw pictures in the sand or make pictures out of clouds?",
//        "choices": ["Both I love the outdoors!","Pictures out of clouds","Pictures in the sand"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id22 = UUID().uuidString;
//    docRefs.document(id22).setData([
//        "id" : id22,
//        "question": "Would you Rather: Have a snowball fight or water balloon fight?",
//        "choices": ["Water balloon fight","Violence is not the answer","Snowball fight"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id23 = UUID().uuidString;
//    docRefs.document(id23).setData([
//        "id" : id23,
//        "question": "Would you Rather: Go tubing or skiing?",
//        "choices": ["Tubing","Skiing","Neither Im not very active"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id24 = UUID().uuidString;
//    docRefs.document(id24).setData([
//        "id" : id24,
//        "question": "Would you Rather: Go surfing or jetskiing?",
//        "choices": ["Jetskiing","Both I love the water!","Surfing"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id25 = UUID().uuidString;
//    docRefs.document(id25).setData([
//        "id" : id25,
//        "question": "Would you Rather: Talk to me on the phone or through text messages?",
//        "choices": ["Phone","Text","Snapchat"],
//        "categoryType": "Values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id26 = UUID().uuidString;
//    docRefs.document(id26).setData([
//        "id" : id26,
//        "question": "Would you Rather: Kiss on the first date or wait a few dates?",
//        "choices": ["Who waits? 1st date or ghost","first date is fine","Eh, lets wait a few dates"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id27 = UUID().uuidString;
//    docRefs.document(id27).setData([
//        "id" : id27,
//        "question": "Would you Rather: Watch a fireworks show or go watch a musical?",
//        "choices": ["Both I love the theater!","Musical","Fireworks"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id28 = UUID().uuidString;
//    docRefs.document(id28).setData([
//        "id" : id28,
//        "question": "Would you Rather: Go to a concert together or make music together?",
//        "choices": ["I love concerts!","Make music together means sex?","Lets make a track"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id29 = UUID().uuidString;
//    docRefs.document(id29).setData([
//        "id" : id29,
//        "question": "Would you Rather: Go hiking and Go white-water rafting?",
//        "choices": ["White-water rafting","Hiking","Eh, I prefer water over land"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//
//
//
//    let id30 = UUID().uuidString;
//    docRefs.document(id30).setData([
//        "id" : id30,
//        "question": "Would you Rather: Get smacked on the butt or kissed on the cheek?",
//        "choices": ["Kiss on cheek","Both I love the attention","Smacked on butt"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id31 = UUID().uuidString;
//    docRefs.document(id31).setData([
//        "id" : id31,
//        "question": "Would you Rather: Go camping in the mountains or have a movie night in?",
//        "choices": ["Hate the outdoors movie night it is","I can do both no problem","Love the outdoors lets go camping!"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id32 = UUID().uuidString;
//    docRefs.document(id32).setData([
//        "id" : id32,
//        "question": "Would you Rather: Go out for ice cream or make a sundae bar at home?",
//        "choices": ["I hate ice cream and sugar","Ice cream","Sundae bar"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id33 = UUID().uuidString;
//    docRefs.document(id33).setData([
//        "id" : id33,
//        "question": "Would you Rather: Go on a date with friends or just you and me?",
//        "choices": ["Just you and me","Date with friends","Both is fine"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id34 = UUID().uuidString;
//    docRefs.document(id34).setData([
//        "id" : id34,
//        "question": "Would you Rather: Drink liquor at a party with me or drink wine over dinner?",
//        "choices": ["I dont drink","Drink at party with you","Wine over dinner"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id35 = UUID().uuidString;
//    docRefs.document(id35).setData([
//        "id" : id35,
//        "question": "Would you Rather: See me in a bathing suit or in lingerie?",
//        "choices": ["Bathing Suit","Lingerie","Both"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id36 = UUID().uuidString;
//    docRefs.document(id36).setData([
//        "id" : id36,
//        "question": "Would you Rather: Dance under the moon or in a club?",
//        "choices": ["We be up in Club","Both I love to dance!","Dance under the moon"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id37 = UUID().uuidString;
//    docRefs.document(id37).setData([
//        "id" : id37,
//        "question": "Would you Rather: Cuddle with me or make out?",
//        "choices": ["Cuddle","Make out","Eh Im kinda shy"],
//        "categoryType": "littleThings",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id38 = UUID().uuidString;
//    docRefs.document(id38).setData([
//        "id" : id38,
//        "question": "Would you Rather: Cook dinner with me or have me cook dinner?",
//        "choices": ["You cook, Ill do the rest","I hate cooking","I dont cook but I'll try with you"],
//        "categoryType": "values",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//    let id39 = UUID().uuidString;
//    docRefs.document(id39).setData([
//        "id" : id39,
//        "question": "Would you Rather: Go out for fine dining or order some pizzas and soda?",
//        "choices": ["Pizza and soda","Fine dining Im boujee","Maybe something cheap but healthy"],
//        "categoryType": "personality",
//        "profileType": "",
//        "createdBy": "dotZ3r0",
//        "createdDate": Timestamp(date: Date())
//    ])
//
//
//
//
//
//
//
//
//
//
//
////    let id40 = UUID().uuidString;
////    docRefs.document(id40).setData([
////        "id" : id40,
////        "question": "Would you Rather: Go on a road trip or fly to our destination?",
////        "choices": ["Skinny Dipping","Fully-Clothed","If im drunk who knows what ill do"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id41 = UUID().uuidString;
////    docRefs.document(id41).setData([
////        "id" : id41,
////        "question": "Would you Rather: Go on a destination cruise or take a flight?",
////        "choices": ["Both I love the outdoors!","Pictures out of clouds","Pictures in the sand"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id42 = UUID().uuidString;
////    docRefs.document(id42).setData([
////        "id" : id42,
////        "question": "Would you Rather: Travel around the world or have a family?",
////        "choices": ["Water balloon fight","Violence is not the answer","Snowball fight"],
////        "categoryType": "values",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id43 = UUID().uuidString;
////    docRefs.document(id43).setData([
////        "id" : id43,
////        "question": "Would you Rather: Explore outer space or explore the depths of the oceans?",
////        "choices": ["Tubing","Skiing","Neither Im not very active"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id44 = UUID().uuidString;
////    docRefs.document(id44).setData([
////        "id" : id44,
////        "question": "Would you Rather: Buy a card or make a card?",
////        "choices": ["Jetskiing","Both I love the water!","Surfing"],
////        "categoryType": "littleThings",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id45 = UUID().uuidString;
////    docRefs.document(id45).setData([
////        "id" : id45,
////        "question": "Would you Rather: Write a love letter or write a poem?",
////        "choices": ["Phone","Text","Snapchat"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id46 = UUID().uuidString;
////    docRefs.document(id46).setData([
////        "id" : id46,
////        "question": "Would you Rather: Receive a love letter or receive a poem?",
////        "choices": ["Who waits? 1st date or ghost","first date is fine","Eh, lets wait a few dates"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id47 = UUID().uuidString;
////    docRefs.document(id47).setData([
////        "id" : id47,
////        "question": "Would you Rather: Watch a romantic comedy with me or go shopping with me?",
////        "choices": ["Both I love the theater!","Musical","Fireworks"],
////        "categoryType": "littleThings",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id48 = UUID().uuidString;
////    docRefs.document(id48).setData([
////        "id" : id48,
////        "question": "Would you Rather: Get a tan at the beach or go to a tanning salon?",
////        "choices": ["I love concerts!","Make music together means sex?","Lets make a track"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id49 = UUID().uuidString;
////    docRefs.document(id49).setData([
////        "id" : id49,
////        "question": "Would you Rather: Get a pedicure with me or get a massage with me?",
////        "choices": ["White-water rafting","Hiking","Eh, I prefer water over land"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////
////
////
////    let id50 = UUID().uuidString;
////    docRefs.document(id50).setData([
////        "id" : id50,
////        "question": "Would you Rather: Send me to a spa or give me an amazing massage?",
////        "choices": ["Kiss on cheek","Both I love the attention","Smacked on butt"],
////        "categoryType": "littleThings",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id51 = UUID().uuidString;
////    docRefs.document(id51).setData([
////        "id" : id51,
////        "question": "Would you Rather: Receive a gift bought from the store or a gift made by hand?",
////        "choices": ["Hate the outdoors movie night it is","I can do both no problem","Love the outdoors lets go camping!"],
////        "categoryType": "values",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id52 = UUID().uuidString;
////    docRefs.document(id52).setData([
////        "id" : id52,
////        "question": "Would you Rather: Accidentally say I love you when getting off the phone with your boss or Accidentally say baby when talking on the phone with your mom?",
////        "choices": ["I hate ice cream and sugar","Ice cream","Sundae bar"],
////        "categoryType": "littleThings",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id53 = UUID().uuidString;
////    docRefs.document(id53).setData([
////        "id" : id53,
////        "question": "Would you Rather: Cuddle up in front of a fireplace, or light your fire in bed?",
////        "choices": ["Just you and me","Date with friends","Both is fine"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id54 = UUID().uuidString;
////    docRefs.document(id54).setData([
////        "id" : id54,
////        "question": "Would you Rather: Wrestle naked in a pool of Jell-O or chocolate pudding?",
////        "choices": ["I dont drink","Drink at party with you","Wine over dinner"],
////        "categoryType": "littleThings",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id55 = UUID().uuidString;
////    docRefs.document(id55).setData([
////        "id" : id55,
////        "question": "Would you Rather: Make whoopee in your parents' bed or at a mattress store?",
////        "choices": ["Bathing Suit","Lingerie","Both"],
////        "categoryType": "littleThings",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id56 = UUID().uuidString;
////    docRefs.document(id56).setData([
////        "id" : id56,
////        "question": "Would you Rather: Accidentally send a dirty text to your boss or a sexy voicemail to your mom?",
////        "choices": ["We be up in Club","Both I love to dance!","Dance under the moon"],
////        "categoryType": "littleThings",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id57 = UUID().uuidString;
////    docRefs.document(id57).setData([
////        "id" : id57,
////        "question": "Would you Rather: Talk dirty to me over the phone or through text/picture messages?",
////        "choices": ["Cuddle","Make out","Eh Im kinda shy"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id58 = UUID().uuidString;
////    docRefs.document(id58).setData([
////        "id" : id58,
////        "question": "Would you Rather: Make out at the movies or in the back seat of my car?",
////        "choices": ["You cook, Ill do the rest","I hate cooking","I dont cook but I'll try with you"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
////    let id59 = UUID().uuidString;
////    docRefs.document(id59).setData([
////        "id" : id59,
////        "question": "Would you Rather: Make love on a beach or in a Jacuzzi?",
////        "choices": ["Pizza and soda","Fine dining Im boujee","Maybe something cheap but healthy"],
////        "categoryType": "personality",
////        "profileType": "",
////        "createdBy": "dotZ3r0",
////        "createdDate": Timestamp(date: Date())
////    ])
//}



//
//public func addNewEvents(){
//
//    let docRefs = db.collection("events")
//
//    let id = UUID().uuidString;
//    docRefs.document(id).setData([
//        "id" : id,
//        "title": "Event Test 3",
//        "createdDate": Timestamp(date: Date()),
//        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//        "eventDate": Timestamp(date: Date()),
//        "location": "Tampa,Fl",
//        "participants": [],
//    ])
//
//    let id2 = UUID().uuidString;
//    docRefs.document(id2).setData([
//        "id" : id2,
//        "title": "Event Test 4",
//        "createdDate": Timestamp(date: Date()),
//        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//        "eventDate": Timestamp(date: Date()),
//        "location": "Tampa,Fl",
//        "participants": [],
//    ])
//
//    let id3 = UUID().uuidString;
//    docRefs.document(id3).setData([
//        "id" : id3,
//        "title": "Event Test 5",
//        "createdDate": Timestamp(date: Date()),
//        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//        "eventDate": Timestamp(date: Date()),
//        "location": "Tampa,Fl",
//        "participants": [],
//    ])
//
//    let id4 = UUID().uuidString;
//    docRefs.document(id4).setData([
//        "id" : id4,
//        "title": "Event Test 6",
//        "createdDate": Timestamp(date: Date()),
//        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//        "eventDate": Timestamp(date: Date()),
//        "location": "Tampa,Fl",
//        "participants": [],
//    ])
//
//    let id5 = UUID().uuidString;
//    docRefs.document(id5).setData([
//        "id" : id5,
//        "title": "Event Test 7",
//        "createdDate": Timestamp(date: Date()),
//        "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
//        "eventDate": Timestamp(date: Date()),
//        "location": "Tampa,Fl",
//        "participants": [],
//    ])
//
//}
//


