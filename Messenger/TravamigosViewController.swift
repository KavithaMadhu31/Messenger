
import UIKit
import MessengerKit

class TravamigosViewController: MSGMessengerViewController {
    
    let Userrequest = User(displayName: "Kavitha", avatar: #imageLiteral(resourceName: "steve228uk"), avatarUrl: nil, isSender: true)
    
    let Sophiaresponse = User(displayName: "Lincy", avatar: #imageLiteral(resourceName: "timi"), avatarUrl: nil, isSender: false)
    
    var id = 100
    
    override var style: MSGMessengerStyle {
        let style = MessengerKit.Styles.travamigos

        return style
    }
    
    
    lazy var messages: [[MSGMessage]] = {
        return [
//            [
//                MSGMessage(id: 1, body: .emoji("🐙💦🔫"), user: Sophiaresponse, sentAt: Date()),
//                ],
//            [
//                MSGMessage(id: 2, body: .text("Yeah sure, gimme 5"), user: Userrequest, sentAt: Date()),
//                MSGMessage(id: 3, body: .text("Okay ready when you are"), user: Userrequest, sentAt: Date())
//            ],
//            [
//                MSGMessage(id: 4, body: .text("Awesome 😁"), user: Sophiaresponse, sentAt: Date()),
//                ],
//            [
//                MSGMessage(id: 5, body: .text("Ugh, gotta sit through these two…"), user: Userrequest, sentAt: Date()),
//               
//                ],
//            [
//                MSGMessage(id: 6, body: .text("Every. Single. Time."), user: Sophiaresponse, sentAt: Date()),
//                ],
//            [
//                MSGMessage(id: 7, body: .emoji("🙄😭"), user: Userrequest, sentAt: Date())
//            ]
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SofiaPersonalAssistant"
        
        dataSource = self
        delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.scrollToBottom(animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          //  self.setUsersTyping([self.tim])
        }
        
    }
    
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        id += 1
        
        let body: MSGMessageBody = (inputView.message.containsOnlyEmoji && inputView.message.count < 5) ? .emoji(inputView.message) : .text(inputView.message)
        
        let message = MSGMessage(id: id, body: body, user: Userrequest, sentAt: Date())
        insert(message)
    responsefunction()
        inputView.resignFirstResponder()
    }
    func responsefunction()  {
        id += 1
        
       
        let body: MSGMessageBody = .text("hi how may i help u")
        let message = MSGMessage(id: id, body: body, user: Sophiaresponse, sentAt: Date())
        insert(message)
        
    }
    override func insert(_ message: MSGMessage) {
        
        collectionView.performBatchUpdates({
            if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                self.messages[self.messages.count - 1].append(message)
                
                let sectionIndex = self.messages.count - 1
                let itemIndex = self.messages[sectionIndex].count - 1
                self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                
            } else {
                self.messages.append([message])
                let sectionIndex = self.messages.count - 1
                self.collectionView.insertSections([sectionIndex])
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: true)
            self.collectionView.layoutTypingLabelIfNeeded()
        })
        
    }
    
    override func insert(_ messages: [MSGMessage], callback: (() -> Void)? = nil) {
        
        collectionView.performBatchUpdates({
            for message in messages {
                if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                    self.messages[self.messages.count - 1].append(message)
                    
                    let sectionIndex = self.messages.count - 1
                    let itemIndex = self.messages[sectionIndex].count - 1
                    self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                    
                } else {
                    self.messages.append([message])
                    let sectionIndex = self.messages.count - 1
                    self.collectionView.insertSections([sectionIndex])
                }
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: false)
           // self.collectionView.layoutTypingLabelIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                callback?()
            }
        })
        
    }
    
}


// MARK: - MSGDataSource

extension TravamigosViewController: MSGDataSource {
    
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return "Just now"
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }
    
}

// MARK: - MSGDelegate

extension TravamigosViewController: MSGDelegate {
    
    func linkTapped(url: URL) {
        print("Link tapped:", url)
    }
    
    func avatarTapped(for user: MSGUser) {
        print("Avatar tapped:", user)
    }
    
    func tapReceived(for message: MSGMessage) {
        print("Tapped: ", message)
    }
    
    func longPressReceieved(for message: MSGMessage) {
        print("Long press:", message)
    }
    
    func shouldDisplaySafari(for url: URL) -> Bool {
        return true
    }
    
    func shouldOpen(url: URL) -> Bool {
        return true
    }
    
}
