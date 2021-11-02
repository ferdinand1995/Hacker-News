//
//  NewsListVM.swift
//  Hacker News
//
//  Created by Ferdinand on 02/11/21.
//

import Foundation
import Alamofire

class NewsListVM: ParentViewModel {

    var hackerNews: Observable<HackerNews> = Observable(HackerNews())

    func fecthAPI(_ searchQuery: String = "") {

        isLoadingStated(true)
        let parameters = ["query": searchQuery]

        AF.request("http://hn.algolia.com/api/v1/search", method: .get, parameters: parameters).responseJSON(completionHandler: { response in
            switch(response.result) {
            case .success(_):
                self.isLoadingStated(false)
                if let data = response.data {
                    do {
                        let decoder = JSONDecoder()
                        let tempHackerNews = try decoder.decode(HackerNews.self, from: data)
                        self.hackerNews.value = tempHackerNews
                    } catch let error {
                        self.onErrorBlock!((code: nil, msg: error.localizedDescription))
                    }
                }
            case .failure(let error):
                self.isLoadingStated(false)
                self.onErrorBlock!((code: response.response?.statusCode, msg: error.localizedDescription))
            }
        })
    }

    func numberOfItems() -> Int {
        return hackerNews.value.hits?.count ?? 0
    }

}
