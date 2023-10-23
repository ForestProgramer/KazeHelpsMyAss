//
//  ResultSearchTableViewCell.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 17.10.2023.
//

import UIKit

class ResultSearchTableViewCell: UITableViewCell {

    var labelCell : UILabel = {
        let label = UILabel()
        label.textColor = .black
       return label
    }()
    static let identifier = "ResultSearchTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        labelCell.frame = CGRect(x: 5, y: 5, width: 150, height: 42)
        contentView.addSubview(labelCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setUpText(text : String){
        labelCell.text = text
    }

}
