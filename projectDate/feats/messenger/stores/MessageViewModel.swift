//
//  MessageViewModel.swift
//  projectDate
//
//  Created by DotZ3R0 on 3/31/23.
//

import Foundation
import FirebaseFirestore

class MessageViewModel: ObservableObject {
    @Published private(set) var messages: [MessageModel] = []
    @Published private(set) var lastMessageId = ""
    @Published public var messageThreads: [MessageThreadModel] = []
    
    let db = Firestore.firestore()
    
    public func getMessages(messageIds: [String]) {
        db.collection("messages")
            .whereField("id", in: messageIds)
            .addSnapshotListener { QuerySnapshot, error in
            guard let documents = QuerySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            self.messages = documents.compactMap {document -> MessageModel? in
                do {
                    return try document.data(as: MessageModel.self)
                } catch {
                    print("Error decoding document into Message: \(error)")
                    return nil
                }
            }
            self.messages.sort {$0.timeStamp < $1.timeStamp}
            
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
        }
    }
    
    public func sendMessage(text: String) {
        do{
            let newMessage = MessageModel(id: "\(UUID())", received: false, text: text, timeStamp: Date())
            
            try db.collection("messages").document().setData(from: newMessage)
        } catch {
            print("Error adding message to Firestore: \(error)")
        }
    }
    
    public func getMessageThreads() {
        db.collection("messageThreads")
            //.whereField("id", in: threadIds)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting messageThreads: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        //                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        if !data.isEmpty{
                            let messageThread = MessageThreadModel(id: data["id"] as? String ?? "", profileId: data["profileId"] as? String ?? "", messageIds: data["messageIds"] as? [String] ?? [])

                            self.messageThreads.append(messageThread)

                        }
                    }
                }
            }
    }
}
