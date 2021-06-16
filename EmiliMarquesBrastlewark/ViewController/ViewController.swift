//
//  ViewController.swift
//  EmiliMarquesBrastlewark
//
//  Created by Emili Marques on 16/06/2021.
//

import UIKit
import Foundation
import GameKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //Parte 1
        // En esta parte le pedimos al archivo que lo lea
        let path = Bundle.main.path(forResource: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe)
        
        //Parte 2
        // En esta otra parte le pedimos al archivo que lo muestre por pantalla.
        guard let gnomo = Bundle.main.path(forResource: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data", ofType: "json") else { return }

        let url = URL(fileURLWithPath: gnomo)

        do {

            let data = try Data(contentsOf: url)

            let json = try JSON(data: data)

        } catch {

            print(error)
        }

        
    }

    
}

//Parte 3
//Leeemos el arcvhivo JSON
private func readJson() {
    do {
        if let file = Bundle.main.url(forResource: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data", withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any] {
               
                print(object)
            } else if let object = json as? [Any] {
              
                print(object)
            } else {
                print("JSON is invalid")
            }
        } else {
            print("no file")
        }
    } catch {
        print(error.localizedDescription)
    }
}

//Parte 4
//Mostramos el documento JSON

func getDataFromURLJson() {
    // Get url for file
    guard let fileUrl = Bundle.main.url(forResource: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data", withExtension: "json") else {
        print("File could not be located at the given url")
        return
    }

    do {
        let data = try Data(contentsOf: fileUrl)

        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            print("Could not cast JSON content as a Dictionary<String, Any>")
            return
        }

        print(dictionary)
    } catch {
        print("Error: \(error)")
    }
}

//Parte 5
//Aqui mostramos como carga el archivo
class BrastlewarkLoader {
    typealias Handler = (Result<Article, Error>) -> Void

    private let cache = Cache<Article.ID, Article>()

    func loadArticle(withID id: Article.ID,
                     then handler: @escaping Handler) {
        if let cached = cache[id] {
            return handler(.success(cached))
        }

        performLoading { [weak self] result in
            let article = try? result.get()
            article.map { self?.cache[id] = $0 }
            handler(result)
        }
    }
}

//Parte 6
//En esta parte mostramos la cache del archivo JSON

final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()

    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }

    func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }

    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
        
        let cache = NSCache<NSString, ExpensiveObjectClass>()
        let myObject: ExpensiveObjectClass

        if let cachedVersion = cache.object(forKey: "CachedObject") {
           
            myObject = cachedVersion
        } else {
            myObject = ExpensiveObjectClass()
            cache.setObject(myObject, forKey: "CachedObject")
        }
 
    }
}
