//
//  UserManager.swift
//  CarInfo
//
//  Created by window1 on 10/17/25.
//

import Foundation

@Observable
@MainActor

class UserManager {
    var currentUser: User?
    var currentCarStatus: [CarStatus]?
    var isRegistered: Bool = false
    var isLoading: Bool = true
    
    private let service: UserService
    
    init(service: UserService = UserService()) {
        self.service = service
    }
    
    func loadInitialData() async {
        // defer를 사용해 이 함수가 어떻게 끝나든(성공/실패) isLoading은 항상 false가 되도록 보장합니다.
        defer { self.isLoading = false }
        
        await fetchCurrentUser()
        // 현재 사용자가 확인된 경우에만 차량 상태를 불러옵니다.
        if self.currentUser != nil {
            await loadUserCarStatuses()
        }
    }
    
    func fetchCurrentUser() async {
        do {
            self.currentUser = try await service.fetchCurrentUser()
        } catch {
            print("DEBUG: Failed to fetch current user with error: \(error)")
        }
    }
    
    func loadUserCarStatuses() async {
        do {
            let cars = try await service.fetchCarStatusesForCurrentUser()
            self.currentCarStatus = cars
            self.isRegistered = !cars.isEmpty
        } catch {
            print("DEBUG: Failed to load user car statuses with error: \(error)")
            self.currentCarStatus = nil
            self.isRegistered = false
        }
    }
    
    func registrationCar(carId: String) async {
        do {
            let checkResult = try await service.registerCar(carId: carId)
            print("DEBUG: Car registration successful. Refreshing user car statuses...")
            currentCarStatus?.append(checkResult)
            await self.loadUserCarStatuses()
        } catch {
            print("DEBUG: Failed to register car with error: \(error)")
        }
    }
    
    func checkCarCodeLength(carId: String) -> Bool {
        //차량등록번호 17자리 확인
        //KMHEL13CPYA000001
        let result = (carId.count == 17)
        return result
    }
    
}
