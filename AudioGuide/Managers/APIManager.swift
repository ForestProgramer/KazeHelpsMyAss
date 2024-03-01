//
//  APIManager.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 31.10.2023.
//

import Foundation
import UIKit

struct ApiResponse: Decodable {
    let data: ApiData?
    let message: String?
    let subscriptions: [String]?
}

struct ApiData: Decodable {
    let bearerToken: String?
    let provider: String?
    let bearerTokenExp: Int?
}


final class APIManager{
    static let shared = APIManager()
    private init() { }
    
    //MARK: Ініціалізація id_device
    func initUser(idDevice: String, completion: @escaping (Result<Void, NSError>) -> Void) {
        let url = "https://devapi.test.vn.ua/api/en/user/init"
        
        guard let serviceUrl = URL(string: url) else {
            completion(.failure(NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let parameters: [String: Any] = [
            "id_device": idDevice
        ]
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            completion(.failure(error as NSError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error as NSError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid Response"])))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                // Обробка відповіді при успішному ініціалізації
                completion(.success(()))
            case 422:
                completion(.failure(NSError(domain: "YourDomain", code: 422, userInfo: [NSLocalizedDescriptionKey: "Validation Error"])))
            case 409:
                completion(.failure(NSError(domain: "YourDomain", code: 409, userInfo: [NSLocalizedDescriptionKey: "User Already Exists"])))
            case 404:
                completion(.failure(NSError(domain: "YourDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Subscription Not Found"])))
            case 500:
                completion(.failure(NSError(domain: "YourDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Database Insertion Error"])))
            default:
                completion(.failure(NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])))
            }
        }
        
        task.resume()
    }
    
    //MARK: реєстрація юзерів в api
    func registerUser(idDevice: String,email: String, password: String, completion: @escaping (Error?) -> Void) {
        // Створіть URL для запиту
        if let url = URL(string: "https://devapi.test.vn.ua/api/en/user/register") {
            // Створіть запит
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Створіть об'єкт JSON для передачі даних
            let parameters: [String: Any] = [
                "id_device": idDevice,
                "email": email,
                "password": password
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(error)
                print("ERROR : \(error)")
                return
            }
            
            // Встановіть заголовки для JSON-запиту
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Виконайте запит
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                // Обробка відповіді від сервера
                if let httpResponse = response as? HTTPURLResponse {
                    if (200..<300).contains(httpResponse.statusCode) {
                        // Успішний запит, користувач зареєстрований
                        completion(nil)
                        print("Користувач зареєстрований успішно")
                    } else {
                        // Помилка під час реєстрації, ви можете обробити відповідь сервера
                        completion(NSError(domain: "AudioGuide", code: httpResponse.statusCode, userInfo: nil))
                    }
                }
            }
            
            task.resume()
        }
    }
    //MARK: Верифікація юезра (код)
    func verifyUser(idDevice: String, email: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
        // URL вашого API для верифікації користувача
        let verifyURLString = "https://devapi.test.vn.ua/api/en/email/verify"
        guard let verifyURL = URL(string: verifyURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Параметри запиту
        var request = URLRequest(url: verifyURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "email": email,
            "code": code
        ]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = requestData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Розпарсити відповідь
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        // Верифікація пройшла успішно
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let jsonData = json["data"] as? [String : Any],
                           let message = jsonData["message"] as? String {
                            completion(.success(message))
                        }else {
                            completion(.failure(NSError(domain: "Invalid JSON response", code: -1, userInfo: nil)))
                        }
                    } else if statusCode == 404 {
                        // Користувача не знайдено
                        completion(.failure(NSError(domain: "User not found", code: statusCode, userInfo: nil)))
                    } else if statusCode == 422 {
                        // Помилка валідації вхідних даних
                        completion(.failure(NSError(domain: "Invalid input", code: statusCode, userInfo: nil)))
                    } else {
                        // Код не співпадає або помилка верифікації
                        completion(.failure(NSError(domain: "Invalid core or error", code: statusCode, userInfo: nil)))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
    
    //MARK: Повторне надсилання коду
    func resendVerificationCode(idDevice : String, email: String, completion: @escaping (Result<String, Error>) -> Void) {
        // URL вашого API для повторного надсилання коду на email
        let resendURLString = "https://devapi.test.vn.ua/api/en/email/verify/resend"
        guard let resendURL = URL(string: resendURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Параметри запиту
        var request = URLRequest(url: resendURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "email": email
        ]
        
        do {
            let requestData = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = requestData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Розпарсити відповідь
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        // Код верифікації надіслано успішно
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let message = json["message"] as? String {
                            completion(.success(message))
                        }else {
                            completion(.failure(NSError(domain: "Invalid JSON response", code: -1, userInfo: nil)))
                        }
                    } else if statusCode == 404 {
                        // Користувача не знайдено
                        completion(.failure(NSError(domain: "User not found", code: statusCode, userInfo: nil)))
                    } else if statusCode == 409 {
                        // Користувач вже був верифікований раніше
                        completion(.failure(NSError(domain: "User already verified", code: statusCode, userInfo: nil)))
                    } else {
                        // Інша помилка
                        completion(.failure(NSError(domain: "Resend failed", code: statusCode, userInfo: nil)))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                }
            }catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    ///Функція логіну юзера в додатку
    func loginUser(idDevice: String , email: String, password: String, remember: String, completion: @escaping (Result<String, Error>) -> Void) {
        // URL вашого API для логіну користувача
        let loginURLString = "https://devapi.test.vn.ua/api/en/user/login"
        guard let loginURL = URL(string: loginURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Параметри запиту
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "email": email,
            "password": password,
            "remember": remember
        ]
        print("Parametrs : \(parameters)")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            do {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                    switch statusCode{
                    case 200:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let data = json["data"] as? [String : Any],
                           let message = data["message"] as? String,
                           let bearData = data["data"] as? [String : Any],
                           let bearToken = bearData["bearerToken"] as? String,
                           let provider = bearData["provider"] as? String,
                           let bearerTokenExp = bearData["bearerTokenExp"] as? Int
                        {
                            UserDefaults.userBearerToken = bearToken
                            completion(.success("Vocabulary success : \(message).\nBearToken : \(bearToken)\nProvider : \(provider)\nBearerTokenExp: \(bearerTokenExp) "))
                        }else{
                            completion(.failure(NSError(domain: "Invalid JSON Responce", code: statusCode, userInfo: nil)))
                        }
                    case 422:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                           let error = json["error"] as? String{
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                    case 400:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                           let error = json["error"] as? String{
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                    case 401:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                           let error = json["error"] as? String{
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                    case 403:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                           let error = json["error"] as? String{
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                    case 451:
                        print("Enter in 451")
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
                           let error = json["error"] as? [String : Any],
                           let errorCode = error["error"] as? String,
                           let oldIdDevice = error["old_id_device"] as? String{
                            completion(.failure(NSError(domain: errorCode, code: statusCode, userInfo: ["old_id_device": oldIdDevice])))
                        }
                    default:
                        completion(.failure(NSError(domain: "Unexpected error", code: statusCode, userInfo: nil)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    ///google and facebook auth
    func loginWithSocialMedia(idDevice: String, accessToken: String?, authCode: String?, type: String, email: String?, password: String?, remember: String?, subscription: String?, completion: @escaping (Result<String, Error>) -> Void) {
        // URL вашого API для логіну через соціальні мережі
        let loginURLString = "https://devapi.test.vn.ua/api/en/user/auth"
        guard let loginURL = URL(string: loginURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Параметри запиту
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var parameters: [String: Any] = [
            "id_device": idDevice,
            "type": type,
            "remember" : remember == nil ? 0 : 1
        ]
        
        if let accessToken = accessToken {
            parameters["accessToken"] = accessToken
        }
        if let authCode = authCode {
            parameters["auth_code"] = authCode
        }
        
        if let password = password {
            parameters["password"] = password
        }
        if let email = email {
            parameters["email"] = email
        }
        
        if let subscription = subscription {
            parameters["subscription"] = subscription
        }
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    switch statusCode {
                    case 200:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let loginData = json["data"] as? [String: Any],
                           let message = loginData["message"] as? String,
                           let bearToken = loginData["data"] as? [String : Any],
                           let bearerToken = bearToken["bearerToken"] as? String,
                           let provider = bearToken["provider"] as? String,
                           let bearerTokenExp = bearToken["bearerTokenExp"] as? Int{
                            completion(.success("message: \(message), bearerToken: \(bearerToken), provider: \(provider), bearerTokenExp: \(bearerTokenExp), subscription:"))
                            UserDefaults.userBearerToken = bearerToken
                        }else{
                            completion(.failure(NSError(domain: "Invalid JSON Responce", code: statusCode, userInfo: nil)))
                        }
                    case 201:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let jsonData = json["data"] as? [String : Any],
                           let message = jsonData["message"] as? String{
                            completion(.success(message))
                        }else{
                            completion(.failure(NSError(domain: "Invalid JSON Responce", code: statusCode, userInfo: nil)))
                        }
                    case 422, 406, 404, 400, 401, 403:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = json["error"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                    case 451:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let errorData = json["error"] as? [String : Any],
                           let error = errorData["error"] as? String,
                           let oldIdDevice = errorData["old_id_device"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: ["old_id_device": oldIdDevice])))
                        }
                    default:
                        completion(.failure(NSError(domain: "Unexpected error", code: statusCode, userInfo: nil)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    
    ///Функція лог-ауту юзера з додатку
    func logOut(deviceID: String, bearerToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let logoutURL = URL(string: "https://devapi.test.vn.ua/api/en/user/logout") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: logoutURL)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = ["id_device": deviceID]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(.success(()))
            } else {
                let errorMessage = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                completion(.failure(NSError(domain: errorMessage, code: httpResponse.statusCode, userInfo: nil)))
            }
        }
        
        task.resume()
    }

    
    /// Функція надсилання коду на email користувача для відновлення паролю акаунта користувача
    func passwordRemind(idDevice : String,email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // URL вашого API для відправки коду верифікації на email
        let remindURLString = "https://devapi.test.vn.ua/api/en/user/passwordRemind"
        guard let remindURL = URL(string: remindURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Створити запит POST
        var request = URLRequest(url: remindURL)
        request.httpMethod = "POST"
        
        // Створити JSON-дані для відправки
        let requestData: [String: Any] = [
            "id_device": idDevice,
            "email": email
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else {
            completion(.failure(NSError(domain: "Invalid request data", code: -1, userInfo: nil)))
            return
        }
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // Код верифікації успішно відправлено
                    completion(.success(()))
                } else if statusCode == 422 {
                    // Помилка валідації вхідних даних
                    completion(.failure(NSError(domain: "Validation error", code: statusCode, userInfo: nil)))
                } else if statusCode == 404 {
                    // Користувача не знайдено
                    completion(.failure(NSError(domain: "User not found", code: statusCode, userInfo: nil)))
                } else {
                    // Інша помилка
                    completion(.failure(NSError(domain: "Remind password failed", code: statusCode, userInfo: nil)))
                }
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
            }
        }
        
        task.resume()
    }
    func verifyCode(idDevice: String, email: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
        // URL вашого API для перевірки коду
        let verifyCodeURLString = "https://devapi.test.vn.ua/api/en/user/code/verify"
        guard let verifyCodeURL = URL(string: verifyCodeURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Параметри запиту
        var request = URLRequest(url: verifyCodeURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "email": email,
            "code": code
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    switch statusCode {
                    case 200:
                        completion(.success("Verification code is valid"))
                    case 422, 404, 401, 500:
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = json["error"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                    default:
                        completion(.failure(NSError(domain: "Unexpected error", code: statusCode, userInfo: nil)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    /// Функція яка надсилає новий пароль на API, якщо код вірний і email існує
    func passwordChange(idDevice : String, email: String, password: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // URL вашого API для зміни пароля користувача
        let changePasswordURLString = "https://devapi.test.vn.ua/api/en/user/passwordChange"
        guard let changePasswordURL = URL(string: changePasswordURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Створити запит POST
        var request = URLRequest(url: changePasswordURL)
        request.httpMethod = "POST"
        
        // Створити JSON-дані для відправки
        let requestData: [String: Any] = ["id_device": idDevice, "email": email, "password": password, "code": code]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestData) else {
            completion(.failure(NSError(domain: "Invalid request data", code: -1, userInfo: nil)))
            return
        }
        
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // Пароль успішно змінено
                    completion(.success(()))
                } else if statusCode == 422 {
                    // Помилка валідації вхідних даних
                    completion(.failure(NSError(domain: "Validation error", code: statusCode, userInfo: nil)))
                } else if statusCode == 404 {
                    // Користувача не знайдено
                    completion(.failure(NSError(domain: "User not found", code: statusCode, userInfo: nil)))
                } else if statusCode == 401 {
                    // Код верифікації не збігається
                    completion(.failure(NSError(domain: "Verification code mismatch", code: statusCode, userInfo: nil)))
                } else {
                    // Інша помилка
                    completion(.failure(NSError(domain: "Change password failed", code: statusCode, userInfo: nil)))
                }
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
            }
        }
        
        task.resume()
    }
    
    /// reInitDevice
    func reInitDevice(idDevice: String, oldIdDevice: String, completion: @escaping (Result<String, Error>) -> Void) {
        // URL вашого API для reInitDevice
        let reInitDeviceURLString = "https://devapi.test.vn.ua/api/en/user/reInitDevice"
        guard let reInitDeviceURL = URL(string: reInitDeviceURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Параметри запиту
        var request = URLRequest(url: reInitDeviceURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "old_id_device": oldIdDevice
        ]
        print("Parameters: \(parameters)")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    switch statusCode {
                    case 200:
                        // Успішний відгук
                        completion(.success("Verification code sent to user's email"))
                        
                    case 422:
                        // Помилка валідації вхідних даних
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = json["error"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                        
                    case 404:
                        // Користувач не знайдений
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = json["error"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                        
                    case 500:
                        // Проблема з БД
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = json["error"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                        
                    default:
                        // Неочікувана помилка
                        completion(.failure(NSError(domain: "Unexpected error", code: statusCode, userInfo: nil)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    ///підтвердження нового idDevice
    func confirmNewDeviceId(idDevice: String, oldIdDevice: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
        // URL вашого API для confirmNewDeviceId
        let confirmNewDeviceIdURLString = "https://devapi.test.vn.ua/api/en/user/reInitDeviceSet"
        guard let confirmNewDeviceIdURL = URL(string: confirmNewDeviceIdURLString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Параметри запиту
        var request = URLRequest(url: confirmNewDeviceIdURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "old_id_device": oldIdDevice,
            "code": code
        ]
        print("Parameters: \(parameters)")
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    switch statusCode {
                    case 200:
                        // Успішний відгук
                        completion(.success("User's id_device changed successfully"))
                        
                    case 422:
                        // Помилка валідації вхідних даних
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = json["error"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                        
                    case 404:
                        // Користувач не знайдений
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = json["error"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                        
                    case 500:
                        // Проблема з БД
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let error = json["error"] as? String {
                            completion(.failure(NSError(domain: error, code: statusCode, userInfo: nil)))
                        }
                        
                    default:
                        // Неочікувана помилка
                        completion(.failure(NSError(domain: "Unexpected error", code: statusCode, userInfo: nil)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func getPoints(idDevice: String, orderFilter: String = "rating", sortType: String = "desc", itemsPerPage: Int = 10,with page: Int? = nil, completion: @escaping (Result<PointsResponceData, Error>) -> Void) {
        let urlString: String
        if let page = page {
            urlString = "https://devapi.test.vn.ua/api/en/points/getAllPoints?page=\(page)"
        } else {
            urlString = "https://devapi.test.vn.ua/api/en/points/getAllPoints"
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "order_by": orderFilter,
            "sort": sortType,
            "perPage": itemsPerPage
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PointsModelResponce.self, from: data)
                completion(.success(response.data))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    func getTours(idDevice: String, orderBy: String = "rating", sort: String = "desc", perPage: Int = 10,with page: Int? = nil, completion: @escaping (Result<TourData, Error>) -> Void) {
        let urlString: String
        if let page = page {
            urlString = "https://devapi.test.vn.ua/api/en/tours/getTours?page=\(page)"
        } else {
            urlString = "https://devapi.test.vn.ua/api/en/tours/getTours"
        }
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "order_by": orderBy,
            "sort": sort,
            "perPage": perPage
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(TourResponse.self, from: data)
                completion(.success(decodedData.data))
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    func getSearchResults<T: Codable>(idDevice: String,
                                      keywords: String,
                                      orderBy: OrderBy,
                                      sort: Sort,
                                      typeFilter: TypeFilter,
                                      mode: Mode,
                                      responseType: T.Type,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        // URL для запиту
        guard let url = URL(string: "https://devapi.test.vn.ua/api/en/search") else {
            print("Invalid URL")
            return
        }
        
        // Параметри запиту
        let parameters: [String: Any] = [
            "id_device": idDevice,
            "keywords": keywords,
            "order_by": orderBy.rawValue,
            "sort": sort.rawValue,
            "type_filter": typeFilter.rawValue,
            "mode": mode.rawValue
        ]
        
        // Створення запиту
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Встановлення JSON відправлення
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
            completion(.failure(error))
            return
        }
        
        // Виконання запиту
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(.failure(error ?? NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            do {
                // Декодування отриманих даних
                let searchResponse = try JSONDecoder().decode(SearchResponseModel<T>.self, from: data)
                completion(.success(searchResponse.data))
            } catch {
                print("Error decoding JSON: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
