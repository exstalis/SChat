//
//  HomeViewController.swift
//  SChat
//
//  Created by elif ece arslan on 12/21/16.
//  Copyright © 2016 KolektifLabs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableview: UITableView!

    var users = [[String: AnyObject]]()
    var nickname: String!
        var configurationOK = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !configurationOK {
            configureTableView()
            configurationOK = !configurationOK
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if nickname == nil {
            getNickname()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UINib (nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "usercell")
        tableview.isHidden = true
        tableview.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func getNickname() {
        let alertController = UIAlertController(title: "Chat", message: "type your nickname", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: nil)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let textField = alertController.textFields?[0]
            if textField?.text?.characters.count == 0 {
                self.getNickname()
            }else {
                self.nickname = textField?.text
                SocketIOManager.sharedInstance.connectServerWithNickname(self.nickname, completionHandler: { (userList) in
                    DispatchQueue.main.async {
                        if userList != nil {
                            self.users = userList
                            self.tableview.reloadData()
                            self.tableview.isHidden = false
                        }
                    }
                })
            }
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Button Actions
    
    @IBAction func onExitChat(_ sender: UIBarButtonItem) {
        SocketIOManager.sharedInstance.exitChatWithNickname(nickname: nickname) { 
            DispatchQueue.main.async {
                self.nickname = nil
                self.users.removeAll()
                self.tableview.isHidden = true
                self.getNickname()
            }
        }
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "joinChat" {
                let chatController = segue.destination as! ChatViewController
                chatController.nickname = nickname
                
            }
        }
    }
}

typealias TableViewDelegate = HomeViewController
typealias TableViewDataSource = HomeViewController
extension TableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"usercell", for: indexPath) as! UserCell
        cell.textLabel?.text = users[indexPath.row]["nickname"] as? String
        cell.detailTextLabel?.text = (users[indexPath.row]["isConnected"] as! Bool) ? "Online" : "Offline"
        cell.detailTextLabel?.textColor = (users[indexPath.row]["isConnected"] as! Bool) ? UIColor.green : UIColor.red
        return cell
    }
}
extension TableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
}
