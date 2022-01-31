//
//  ContactListViewModel.swift
//  ContactList
//
//  Created by Lyvennitha on 31/01/22.
//

import Foundation

class ContactListViewModel{
    let model = ContactListModelAPI()
    func getContactList(onResponse: @escaping (Result<ContactResponse, Error>) -> ()){
        model.getLatestContact { result in
            switch result{
            case .success(let data):
                onResponse(.success(data))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}
