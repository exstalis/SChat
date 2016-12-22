//
//  ChatCell.swift
//  SChat
//
//  Created by elif ece arslan on 12/21/16.
//  Copyright © 2016 KolektifLabs. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var chatMsgLabel: UILabel!
    
    @IBOutlet weak var msgDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
