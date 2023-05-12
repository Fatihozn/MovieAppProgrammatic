//
//  FavoriteScreenViewModel.swift
//  BigMoviesAppProgrammatic
//
//  Created by Fatih Özen on 2.05.2023.
//

import Foundation

protocol FavoriteScreenViewModelProtocol {
    var view: FavoriteScreenProtocol? { get set }
    
    func viewDidLoad()
    func viewWillApear()
    func getDetail(id: Int, control: String)
}

final class FavoriteScreenViewModel {
    
    weak var view: FavoriteScreenProtocol?
    private var service = MovieService()
    var favList = [MovieResult]()
    var controlList = [String]()
}

extension FavoriteScreenViewModel: FavoriteScreenViewModelProtocol {
    
    func viewDidLoad() {
        view?.configVC()
        view?.configCollectionView()
    }
    
    func viewWillApear() {
        getList()
    }
    
    private func getList() {
        getDataList { (dataList, controlList) in
            favList.removeAll()
            print(controlList)
            self.controlList = controlList
            for data in dataList {
                do {
                    let movieResult = try JSONDecoder().decode(MovieResult.self, from: data)
                    favList.append(movieResult)
                    view?.reloadCollectionView()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    private func getDataList(completion: ([Data],[String]) -> ()) {
        let d = UserDefaults.standard
        if let dataList = d.array(forKey: "favList") as? [Data], let controlList = d.array(forKey: "control") as? [String] {
            completion(dataList,controlList)
        }
        view?.reloadCollectionView()
        
    }
    
    func getDetail(id: Int, control: String) {
        var url = ""
        print(control)
        if control == "tv" {
             url = APIURLs.getDetailTV(id: id)
        } else {
             url = APIURLs.getDetail(id: id)
        }
        service.downloadDetail(url: url,id: id) { [weak self] (returnedDetail, data) in
            guard let self = self else { return }
            guard let returnedDetail = returnedDetail else { return }
            
            self.view?.navigateToDetail(movie: returnedDetail, data: data, control: control)
        }
    }
}
