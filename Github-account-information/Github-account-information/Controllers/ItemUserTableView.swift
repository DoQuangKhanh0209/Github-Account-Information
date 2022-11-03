//
//  ItemUserTableView.swift
//  Github-account-information
//
//  Created by Quang Khánh on 03/11/2022.
//

import UIKit
import CoreData

class ItemUserTableView: UITableViewCell {
    
    private var network = APIService.shareDataAPI
    
    @IBOutlet private weak var uiView: UIView!
    @IBOutlet private weak var btnDetailUser: UIImageView!
    @IBOutlet private weak var txtLinkUser: UILabel!
    @IBOutlet private weak var txtNameUser: UILabel!
    @IBOutlet private weak var imgUser: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        uiView.dropShadow(color: .black, offSet: .zero, radius: 3)
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        imgUser.clipsToBounds = true
        selectionStyle = .none
    }

    func bindData(user: DomainUser, isHiddenShowDetailButton: Bool) {
        self.network.getImageUser(imageURL: (user.avatarUrl)) { [weak self] (data, error)  in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                self.imgUser.image = UIImage(data: data)
            }
        }
        if (isHiddenShowDetailButton) {
            btnDetailUser.isHidden = true
        }
        txtNameUser.text = user.login
        txtLinkUser.text = user.htmlUrl
    }
    
    func bindDataFromCoreData(_ user: NSManagedObject) {
        let avatar = (user.value(forKey: "avatarUrl") as? String) ?? ""
        self.network.getImageUser(imageURL: avatar) { [weak self] (data, error)  in
            guard let self = self else { return }
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                self.imgUser.image = UIImage(data: data)
            }
        }
        txtNameUser.text = (user.value(forKey: "login") as? String) ?? ""
        txtLinkUser.text = (user.value(forKey: "htmlUrl") as? String) ?? ""
    }
}
extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.2, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.cornerRadius = 20
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1
    }
}
