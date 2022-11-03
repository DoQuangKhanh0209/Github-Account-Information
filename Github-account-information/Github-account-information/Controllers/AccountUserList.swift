//
//  AccountUserList.swift
//  Github-account-information
//
//  Created by Quang Khánh on 03/11/2022.
//

import UIKit

final class AccountUserList: UIViewController {

    private var listUser = [DomainUser]()
    private var listUserToShow = [DomainUser]()
    private var search: String = ""
    private var searching: Bool = false
    private let userRepository = UserRepositoryType()
    
    @IBOutlet private weak var tableViewUser: UITableView!
    @IBOutlet private weak var uiViewSearch: UIView!
    @IBOutlet private weak var textFieldSearch: UITextField!
    @IBOutlet private weak var searchIconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listUserAPI()
    
        tableViewUser.register(UINib(nibName: "UserInfoTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "UserInfoTableViewCell")
        tableViewUser.delegate = self
        tableViewUser.dataSource = self
        textFieldSearch.delegate = self
        searchIconImageView.layer.cornerRadius = searchIconImageView.frame.height / 2
        searchIconImageView.clipsToBounds = true
        searchIconImageView.setCornerRadius(radiusValue: 5, isTopBorder: false)
        textFieldSearch.borderStyle = .none
        
        tableViewUser.reloadData()
    }
    
    private func listUserAPI() {
        userRepository.getAllUser(urlApi: "https://api.github.com/search/users?q=abc") { [weak self] (data, error) -> (Void) in
            guard let self = self else { return }
            if let _ = error {
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.listUser = data
                    self.listUserToShow = data
                    self.tableViewUser.reloadData()
                }
            }
        }
    }
    
    @IBAction private func showFavoriteUsersAction(_ sender: Any) {
        guard let favoriteUsersViewController = storyboard?.instantiateViewController(withIdentifier: "FavoriteUsersViewController") as? FavoriteAccountUser else {
            return
        }
        self.navigationController?.pushViewController(favoriteUsersViewController, animated: true)
    }
    
    @IBAction private func deleteContentSearchAction(_ sender: Any) {
        textFieldSearch.text = ""
        listUserToShow = listUser
        tableViewUser.reloadData()
    }
}

extension AccountUserList: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text ?? "")
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
              let range = Range(range, in: oldText) else {
            return true
        }
        let newText = oldText.replacingCharacters(in: range, with: string)
        if newText.isEmpty {
            listUserToShow = listUser
        } else {
            listUserToShow = self.listUser.filter { $0.login.localizedCaseInsensitiveContains(newText) }
        }
        self.tableViewUser.reloadData()
        return true
    }
}

extension AccountUserList: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let userDetailViewController = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as? AccountUserDetails else {
            return
        }
        userDetailViewController.bindData(loginUserString: listUserToShow[indexPath.row].login)
        self.navigationController?.pushViewController(userDetailViewController, animated: true)
    }
}

extension AccountUserList: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listUserToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserInfoTableViewCell", for: indexPath) as? ItemUserTableView else {
            return UITableViewCell()
        }
        cell.bindData(user: listUserToShow[indexPath.row], isHiddenShowDetailButton: false)
        return cell
    }
}

