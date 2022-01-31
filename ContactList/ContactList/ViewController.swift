//
//  ViewController.swift
//  ContactList
//
//  Created by Lyvennitha on 30/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactListData: ContactResponse?
    typealias UserDataSource = UITableViewDiffableDataSource<Int, ContactResponseElement>
    typealias UserSnapshot = NSDiffableDataSourceSnapshot<Int, ContactResponseElement>

    let viewModel = ContactListViewModel()
    var dataSource : UserDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        // Do any additional setup after loading the view.
        getContactList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
    }


}

extension ViewController{
    private func configureDataSource(){
        dataSource = UserDataSource(tableView: tableView, cellProvider: { (tbl, indexPath, data) -> UITableViewCell? in
            let cell = tbl.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ContactListCell
            cell?.tileText?.text = data.title
            if data.view == true{
                cell?.detailView.isHidden = false
            }else{
                cell?.detailView.isHidden = true
            }
            DispatchQueue.global(qos: .userInitiated).async{
                cell?.titleImage.downloaded(from: data.url ?? "", contentMode: .scaleAspectFit)
                cell?.detailImg.downloaded(from: data.thumbnailURL ?? "", contentMode: .scaleAspectFit)
            }
            return cell
        })
    }
    
    
    
    private func createSnapshot(data: ContactResponse){
        var snapShot = UserSnapshot()
        snapShot.appendSections([0])
        snapShot.appendItems(data)
        dataSource.apply(snapShot)
        
    }
    
    func update(with list: ContactResponse, animate: Bool = false) {
        var snapshot =  UserSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot, animatingDifferences: animate)
        
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contactListData?[indexPath.row].view = true
        self.update(with: self.contactListData!)
        //        guard let selectedContact = dataSource.itemIdentifier(for: indexPath) else {
        //            tableView.deselectRow(at: indexPath, animated: true)
        //            return
        //        }
        //        var testingItem = selectedContact
        //        testingItem.view = true
        //        var newSnapshot = dataSource.snapshot()
        //        //DispatchQueue.main.async {
        ////            newSnapshot.insertItems([testingItem], beforeItem: selectedContact)
        ////            newSnapshot.deleteItems([selectedContact])
        //            newSnapshot.reloadItems([selectedContact])
        //       // }
        //
        //        dataSource.apply(newSnapshot)
    }
}

extension ViewController{
    func getContactList(){
        viewModel.getContactList { result in
            switch result{
            case .success(let data):
                self.contactListData = data
                self.createSnapshot(data: self.contactListData!)
                print(data.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


class ContactListCell: UITableViewCell{
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var tileText: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var viewMoreBtn: UIButton!
    @IBOutlet weak var detailImg: UIImageView!
    @IBOutlet weak var detailView: UIView!
}


