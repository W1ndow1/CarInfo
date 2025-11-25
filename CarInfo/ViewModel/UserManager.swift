//
//  UserManager.swift
//  CarInfo
//
//  Created by window1 on 10/17/25.
//

import Foundation

@Observable

class UserManager {
    var currentUser: User?
    var currentCarId: String?
    var currentCarStatus: [CarStatus]?
    
    private let service: UserService
    
    init(service: UserService = UserService()) {
        self.service = service
        Task {
            await fetchCurrentUser()
            await loadUserCarStatus()
        }
    }
    
    func fetchCurrentUser() async {
        do {
            self.currentUser = try await service.fetchCurrentUser()
        } catch {
            print("DEBUG: Failed to fetch current user with error: \(error)")
        }
    }
    
    func loadUserCarStatus() async {
        do {
            let cars = try await service.fetchCarStatusesForCurrentUser()
            self.currentCarStatus = cars
            self.currentCarId = cars.first?.id

        } catch {
            print("DEBUG: Failed to load user car statuses with error: \(error)")
            self.currentCarStatus = nil
        }
    }
    
    func registrationCar(carId: String) async {
        do {
            let checkResult = try await service.registerCar(carId: carId)
            print("DEBUG: Car registration successful. Refreshing user car statuses...")
            currentCarStatus?.append(checkResult)
        } catch {
            print("DEBUG: Failed to register car with error: \(error)")
        }
    }
    
    //차량등록번호 17자리 확인
    func checkCarCodeLength(carId: String) -> Bool {
        //KMHEL13CPYA000001
        let result = (carId.count == 17)
        return result
    }
    
}
