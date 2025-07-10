//
//  ListItem.swift
//  pokedex-ios
//
//  Created by Josua Friederichs on 09.07.25.
//

import SwiftUI

struct ListItemView: View {
    //var pokemon: Pokemon
    // TODO: Durch die Daten von der API austauschen

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Pokemon-Name")
                        .foregroundStyle(Color.white)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text("#001")
                        .foregroundStyle(Color.black.opacity(0.2))
                        .fontWeight(.semibold)
                }
                HStack {
                    VStack {
                        // TODO: Type-Text iwie auslagern!
                        Text("Typ 1")
                            .padding(3)
                            .padding(.horizontal, 6)
                            .border(.bar, width: 0)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(30)
                        Text("Typ 2")
                            .padding(3)
                            .padding(.horizontal, 6)
                            .border(.bar, width: 0)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(30)
                    }
                    .foregroundColor(Color.white)
                    .font(.caption2)
                    
                    ZStack {
                        Image("pokeball")
                            .resizable()
                            .offset(x: 35, y: 20)
                            .scaledToFit()
                            .opacity(0.08)
                    }
                }
            }
            .padding(5)
        }
        .background(Color.orange)
        .cornerRadius(12)
        .shadow(radius: 10, x: 0, y: 0)
    }
}

#Preview {
    HStack {
        ListItemView()
        ListItemView()
    }
}
