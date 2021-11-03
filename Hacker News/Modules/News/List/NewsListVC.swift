//
//  NewsListVC.swift
//  Hacker News
//
//  Created by Ferdinand on 02/11/21.
//

import UIKit

class NewsListVC: UITableViewController {

    // MARK: Outlet Variables
    @IBOutlet var searchBar: UISearchBar!
    let viewModel = NewsListVM()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initViewModel()
    }

    // MARK: Initialize
    private func initUI() {
        tableView.register(nib: UINib(nibName: String(describing: NewsCell.self), bundle: nil), withCellClass: NewsCell.self)
        tableView.register(nib: UINib(nibName: String(describing: NewsSearchCell.self), bundle: nil), withCellClass: NewsSearchCell.self)
    }

    private func initViewModel() {
        viewModel.isLoadingStated = { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.view.makeToastActivity(.center)
                } else {
                    self.view.hideToastActivity()
                    self.tableView.reloadData()
                }
            }
        }

        viewModel.onErrorBlock = { error in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Error!", message: "Something went wrong! \(error.msg)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(alertController, animated: true)
            }
        }
        
        viewModel.fecthAPI()
    }
    
    
    // MARK: TableView Delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.numberOfItems()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let searchCell = tableView.dequeueReusableCell(withClass: NewsSearchCell.self, for: indexPath)
            searchCell.searchTextField.delegate = self
            return searchCell
        }
        
        let cell = tableView.dequeueReusableCell(withClass: NewsCell.self, for: indexPath)
        
        viewModel.hackerNews.bind { hackerNews in
            if let news = hackerNews.hits?[indexPath.item] {
                cell.titleContentLabel.text = news.title ?? "-"
                cell.subtitleContentLabel.text = news.author ?? "-"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.hackerNews.bind { [unowned self] hackerNews in
            if let news = hackerNews.hits?[indexPath.item], (news.url != nil) {
                let storyboarded = UIStoryboard(name: "Main", bundle: nil)
                let newsDetailVC = storyboarded.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
                newsDetailVC.url = news.url
                self.present(newsDetailVC, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "URL is Empty!", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true)
            }
        }
    }
}

// MARK: TextField Delegate
extension NewsListVC: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        print(textField.text ?? "")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text ?? "")
    }
}
