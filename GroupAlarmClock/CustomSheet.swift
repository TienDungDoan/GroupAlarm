//
//  CustomSheet.swift
//  GroupAlarmClock
//
//  Created by Tien Dung Doan on 2/5/26.
//

import SwiftUI

struct CustomSheet<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()

                content
                    .frame(
                        height: geo.size.height - 20
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
                    .shadow(radius: 10)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
