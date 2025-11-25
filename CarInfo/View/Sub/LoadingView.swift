//
//  ProgressView.swift
//  CarInfo
//
//  Created by window1 on 11/9/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.gray)
            
            }
        }
    }
}

#Preview {
    LoadingView()
}
