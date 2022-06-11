//
//  APIClient+Ext.swift
//  SearchRepositories+Mvvm
//
//  Created by Apple on 2/23/21.
//

import Alamofire

extension APIClient {
    func getCities(country: String, completed: @escaping CompletionBlock){
       request(request: PostCitiesRequest(country: country), callback: completed)
    }
    
    func searchUser(completed: @escaping CompletionBlock) {
      //  getRequestPath(path: "proPlayers", callback: completed)
    }
    
    func detailUserRepo(user: String, parmas: Parameters, completed: @escaping CompletionBlock){
      //  getRequestPathUserClick(path: "\(user)/repos", param: parmas, callback: completed)
    }
}
