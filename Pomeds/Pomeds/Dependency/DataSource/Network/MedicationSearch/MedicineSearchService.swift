//
//  MedicineSearchService.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/31/24.
//

import Combine
import Foundation

import Alamofire

struct MedicineSearchService {
    typealias MedicineName = String
    static let shared = MedicineSearchService()
    private let combineApiHelper = CombineApiHelper()
    
    private init() {}
    
    func getMedicine(requset: MedicineName) async throws -> AnyPublisher<MedicationResponse, APIError> {
        
        let url = ServiceKey.serviceUrl
        let requestParameter = try MedicationRequest(serviceKey: ServiceKey.key, pageNo: 1, numOfRows: 10, itemName: requset).asParameter()
        
        let dataRequest = AF.request(
            url,
            method: .get,
            parameters: requestParameter,
            headers: nil
        )
        return combineApiHelper.run(dataRequest)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}

// 1. Error 타입 정의
enum APIError: Error {
    case http(ErrorData)
    case unknown
}
 
// 2. ErrorData 안에 들어갈 정보 선언
struct ErrorData: Codable {
    var statusCode: Int
    var message: String
    var error: String?
}
 
struct CombineApiHelper {
    // 4. Resonse 선언
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
 
    func run<T: Decodable>(_ request: DataRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, APIError> {
        return request.validate().publishData(emptyResponseCodes: [200, 204, 205]).tryMap { result -> Response<T> in
            if let error = result.error {
                if let errorData = result.data {
                    let value = try decoder.decode(ErrorData.self, from: errorData)
                    throw APIError.http(value)
                }
                else {
                    throw error
                }
            }
            if let data = result.data {
            // 응답이 성공이고 result가 있을 때
                let value = try decoder.decode(T.self, from: data)
                return Response(value: value, response: result.response!)
            } else {
            // 응답이 성공이고 result가 없을 때 Empty를 리턴
                return Response(value: Empty.emptyValue() as! T, response: result.response!)
            }
        }
        .mapError({ (error) -> APIError in
            if let apiError = error as? APIError {
                return apiError
            } else {
                return .unknown
            }
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
