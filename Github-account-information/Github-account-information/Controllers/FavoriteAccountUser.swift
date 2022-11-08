//
//  FavoriteAccountUser.swift
//  Github-account-information
//
//  Created by Quang Khánh on 03/11/2022.
//

import UIKit
import CoreData

class FavoriteAccountUser: UIViewController {
    
    @IBAction func backButtonFavorite(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    

    @IBOutlet private weak var tableViewFavorite: UITableView!
    
    private var listFavoriteAccount = [NSManagedObject]()
    private let coreData = CoreData.shareData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewFavorite.register(UINib(nibName: "UserInfoTableViewCell", bundle: nil),forCellReuseIdentifier:"UserInfoTableViewCell")
        tableViewFavorite.delegate = self
        tableViewFavorite.dataSource = self
        tableViewFavorite.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        coreData.getFavoriteUserList { items, error in
            guard error == nil else {
                print("Could not fetch. \(String(describing: error))")
                return
            }
            self.listFavoriteAccount = items
            self.tableViewFavorite.reloadData()
        }
    }
}

extension FavoriteAccountUser: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFavoriteAccount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as? ItemUserTableView else {
            return UITableViewCell()
        }
        let user = listFavoriteAccount[indexPath.row]
        cell.bindDataFromCoreData(user)
        return cell
    }
}

extension FavoriteAccountUser: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let userDetailVC = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as? AccountUserDetails else {
            return
        }
        userDetailVC.bindData(loginUserString: listFavoriteAccount[indexPath.row].value(forKey: "login") as! String)
        self.navigationController?.pushViewController(userDetailVC, animated: true)
    }
}
