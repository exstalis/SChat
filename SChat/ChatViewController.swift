//
//  ChatViewController.swift
//  SChat
//
//  Created by elif ece arslan on 12/21/16.
//  Copyright © 2016 KolektifLabs. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    var nickname: String!
    var chatMessages = [[String: AnyObject]]()
    var bannerLabelTimer: Timer!
    
    @IBOutlet weak var chatTableview: UITableView!
    
    @IBOutlet weak var otherUserActivityStatusLabel: UILabel!
    
    @IBOutlet weak var messageEditorTextView: UITextView!
    
    @IBOutlet weak var conBottomEditor: NSLayoutConstraint!
    
    @IBOutlet weak var newsBannerLabel: UILabel!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                configureTableView()
        configureNewsBannerLabel()
        configureOtherUserActivityLabel()
        messageEditorTextView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleKeyboardDidShowNotification(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.handleKeyboardDidHideNotification(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeGestureRecognizer.delegate = self
        view.addGestureRecognizer(swipeGestureRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: Custom Methods
    
    func configureTableView() {
        chatTableview.delegate = self
        chatTableview.dataSource = self
        chatTableview.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "chatCell")
        chatTableview.estimatedRowHeight = 90.0
        chatTableview.rowHeight = UITableViewAutomaticDimension
        chatTableview.tableFooterView = UIView(frame: CGRect.zero)
    }
    func configureNewsBannerLabel() {
        newsBannerLabel.layer.cornerRadius = 15.0
        newsBannerLabel.clipsToBounds = true
        newsBannerLabel.alpha = 0.0
    }
    func configureOtherUserActivityLabel() {
        otherUserActivityStatusLabel.isHidden = true
        otherUserActivityStatusLabel.text = ""
    }
    func handleKeyboardDidShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                conBottomEditor.constant = keyboardFrame.size.height
                view.layoutIfNeeded()
            }
        }
    }
    func handleKeyboardDidHideNotification(_ notification: Notification){
        conBottomEditor.constant = 0
        view.layoutIfNeeded()
    }
    func scrollToBottom() {
        /* nanoseconds per second * 0.1 */
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let deadline = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            if self.chatMessages.count > 0 {
                let lastRowAtIndexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                self.chatTableview.scrollToRow(at: lastRowAtIndexPath, at: .bottom, animated: true)
            }
        }
    }
    func showBannerLabelAnimated() {
        UIView.animate(withDuration: 0.75, animations: { 
            self.newsBannerLabel.alpha = 1.0
        }) { (finished) in
            self.bannerLabelTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ChatViewController.hideBannerLabelAnimated), userInfo: nil, repeats: false)
        }
    }
    
    func hideBannerLabelAnimated() {
        if bannerLabelTimer != nil {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        //completion may not be nil in the future
        UIView.animate(withDuration: 0.75, animations: { 
            self.newsBannerLabel.alpha = 0.0
        }, completion: nil)
    }
    func dismissKeyboard() {
        if messageEditorTextView.isFirstResponder {
            messageEditorTextView.resignFirstResponder()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Button Actions
    @IBAction func sendMessage(_ sender: AnyObject) {
        
    }
}

typealias ChatTableViewDataSource = ChatViewController
extension ChatTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"chatCell", for: indexPath) as! ChatCell
        return cell
    }

}

typealias ChatTableViewDelegate = ChatViewController
extension ChatTableViewDelegate: UITableViewDelegate {
    
}


typealias ChatTextViewDelegate = ChatViewController
extension ChatTextViewDelegate: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }

}

typealias ChatGestureRecognizerDelegate = ChatViewController
extension ChatGestureRecognizerDelegate: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

