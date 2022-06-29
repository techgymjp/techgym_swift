//
//  APIService.swift
//  VocabularyBook
//

import Foundation


class APIService {
    //MARK: - 翻訳
    let TRANSLATE_API_KEY = "自分のAPIキーをここに入れます"   //翻訳APIキー
    
    func translateFromJA(query: String, language:String) async -> ResponceTranslateModel? {
        let requestData = RequestTranslateModel(q: query, source: "ja", target: language)
        
        let urlstr = String(format: "https://translation.googleapis.com/language/translate/v2?key=%@", TRANSLATE_API_KEY )
        var urlRequest = makeRequest(api: urlstr)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(requestData)
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let result =  try? JSONDecoder().decode(ResponceTranslateModel.self, from: data)
            return result
        } catch {
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - 画像検索
    let SEARCH_API_KEY = "自分のAPIキーをここに入れます" //検索エンジン キー
    let SEARCH_ID = "自分の検索エンジンIDをここに入れます" //検索エンジン ID
    
    func searchCustom(query: String) async -> ResponceCustomSearchModel? {
        let urlstr = String(format: "https://www.googleapis.com/customsearch/v1?num=1&searchType=image&key=%@&cx=%@&q=%@", SEARCH_API_KEY, SEARCH_ID, query )
        var urlRequest = makeRequest(api: urlstr)
        urlRequest.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            return try? JSONDecoder().decode(ResponceCustomSearchModel.self, from: data)
        } catch {
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - ダウンロード
    func downloadFile(url: URL) async -> URL? {
        do {
            let (fileURL, _) = try await URLSession.shared.download(from: url)
            return fileURL
        } catch {
            NSLog(error.localizedDescription)
            return nil
        }
    }
    
    
    func makeRequest(api:String) -> URLRequest
    {
        let encodedAPI = api.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
        let apiUrl  = URL(string: encodedAPI)!
        
        var request = URLRequest(url:apiUrl)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpShouldHandleCookies = false
        
        return request
    }
}

