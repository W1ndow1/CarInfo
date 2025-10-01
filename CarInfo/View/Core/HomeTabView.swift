//
//  Untitled.swift
//  CarInfo
//
//  Created by window1 on 9/19/25.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        HStack {
            TabView(content: {
                ControlView()
                    .tag(0)
                    .tabItem({
                        Label("제어", systemImage: "car.side")
                    })
                LocationTrackerView()
                    .tag(1)
                    .tabItem({
                        Label("탐색", systemImage: "map")
                    })
                
                Text("안녕하세요")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.black)
                    .tabItem({
                        Label("설정", systemImage: "gear")
                    })
            })
            
            
        }
    }
}

#Preview {
    HomeTabView()
}
