//
//  CustomCell.swift
//  IOS ДЗ 8
//
//  Created by Bekpayev Dias on 03.07.2023.
//

import UIKit
import SnapKit

class CustomCell: UITableViewCell {
    let myLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupScene()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(labelText: String, indentationLevel: Int) {
        myLabel.text = labelText
        myLabel.snp.updateConstraints {
            $0.left.equalToSuperview().inset(25 + indentationLevel * 25)
            $0.top.bottom.equalToSuperview().inset(25)
        }
    }
    
    private func setupScene() {
        contentView.addSubview(myLabel)
    }
    
    private func makeConstraints() {
        myLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(25)
            $0.left.equalToSuperview().inset(25)
        }
    }
}
