//
//  NetworkService.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 28/09/22.
//

import Foundation

class NetworkService {
    var search: Search?
    let url = "http://salomat.tj"
    
    func fetchData(urlString: String, completion: @escaping(Result<ProdsOfTheDay, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(ProdsOfTheDay.self, from: data)
                    //print(urlData)
                    urlData.prods_of_the_day?.forEach { value in
                        switch value.prod_rating_average {
                        case .int(let intValue):
                            print(intValue, "intvalue")
                        case .string(let stringValue):
                            print(stringValue, "stringvalue")
                        }
                    }
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func fetchFromApi(urlString: String, completion: @escaping(Result<CategoriesForMainPage, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(CategoriesForMainPage.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func fetchUserData(urlString: String, completion: @escaping(Result<LoginData, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(LoginData.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func fetchBlogsData(urlString: String, completion: @escaping(Result<Blog, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(Blog.self, from: data)
                    //print(urlData)
             
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func fetchBanners(urlString: String, completion: @escaping(Result<MainSliders, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(MainSliders.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func show(urlString: String, completion: @escaping(Result<Show, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(Show.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func productShow(urlString: String, completion: @escaping(Result<ProductsShow, Error>) -> Void) {
    
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    print(url, "url")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(ProductsShow.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func category(urlString: String, completion: @escaping(Result<Category, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            //print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(Category.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func search(urlString: String, completion: @escaping(Result<Search, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(Search.self, from: data)
                    print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    
    func notif(urlString: String, completion: @escaping(Result<NotificationData, Error>) -> Void) {
        
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(NotificationData.self, from: data)
                    print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func sales(urlString: String, completion: @escaping(Result<Sales, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(Sales.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func login(urlString: String, completion: @escaping(Result<LoginData, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(LoginData.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func favorites(urlString: String, completion: @escaping(Result<FavoritesData, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(FavoritesData.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func getUserData(urlString: String, completion: @escaping(Result<Token, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        var request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(Token.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func getPromocode(urlString: String, completion: @escaping(Result<Promocode, Error>) -> Void) {
        guard let url = URL(string: url + urlString) else {return}
        var request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(Promocode.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func order(urlString: String, completion: @escaping(Result<OrdersData, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        var request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(OrdersData.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func mainCategories(urlString: String, completion: @escaping(Result<CategoriesProducts, Error>) -> Void) {
    
        
        guard let url = URL(string: url + urlString) else {return}
        var request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            print(url)
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {return}
                do {
                    let urlData = try JSONDecoder().decode(CategoriesProducts.self, from: data)
                    //print(urlData)
                    completion(.success(urlData))
                }catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}
