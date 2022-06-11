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
    
    func getMyCities(country: String, completed: @escaping CompletionBlock){
       request(request: PostMyCitiesRequest(country: country), callback: completed)
    }
    
    func getLatLonPlace(name: String, completed: @escaping CompletionBlock) {
        request(baseUrl: kOpenTripMap, request: GetPlacesLatLonRequest(name: name), callback: completed)
    }
    
    func getPlaces(lat: Double, lon: Double, completed: @escaping CompletionBlock) {
        request(baseUrl: kOpenTripMap, request: GetPlacesRequest(lat: lat, lon: lon), callback: completed)
    }
    
    func getPlacesDetail(xid: String, completed: @escaping CompletionBlock) {
        request(baseUrl: kOpenTripMap, request: GetPlacesDetailRequest(id: xid), callback: completed)
    }
    
    func detailUserRepo(user: String, parmas: Parameters, completed: @escaping CompletionBlock){
      //  getRequestPathUserClick(path: "\(user)/repos", param: parmas, callback: completed)
    }
}
