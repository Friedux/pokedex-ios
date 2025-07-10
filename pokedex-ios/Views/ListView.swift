//
//  ListView.swift
//  pokedex-ios
//
//  Created by Josua Friederichs on 09.07.25.
//

import SwiftUI

struct ListView: View {
    private let mainColor = Color.white  // TODO: Add Darkmode
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 2)

    var body: some View {
        ZStack {
            ScrollView {
                mainColor.ignoresSafeArea()
                VStack {
                    HStack {
                        Text("Pokedex")
                            .font(.title)
                            .padding(.leading, 15)
                        Spacer()
                        Image("pokeball")
                            .frame(width: 50, height: 50)
                            .offset(x: 40, y: -50)
                            .scaledToFit()
                            .opacity(0.1)
                    }
                    HStack {
                        LazyVGrid(
                            columns: gridItems,
                            spacing: 15
                        ) {
                            ForEach((1...20), id: \.self) { _ in
                                ListItemView()
                                    .padding(.horizontal, 2)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }
        }
    }
}

#Preview {
    ListView()
}
