//
//  ColorPickerComponent.swift
//  Glyptis
//
//  Created by Pablo Garcia-Dev on 25/11/25.
//

import SwiftUI

struct ColorPickerComponent: View {
    @State var selectedHexID: Int?
    @Binding var selectedColor: Color
    
    var beehiveSize: CGFloat = 16

    var body: some View {
        let overlap = beehiveSize * (0.866-1)
        
        VStack {
            VStack {
                Text("Alterar Cor")
                    .font(.largeTitle)
            }
            Spacer()
            VStack {
                VStack(spacing: 0){
                     HStack(spacing: overlap) {
                         ForEach(ColorPalete.line1) { hexColor in
                             Hexagon(
                                 id: hexColor.id,
                                 isSelected: selectedHexID == hexColor.id,
                                 hexagonColor: hexColor.color
                             ) {
                                 selectedColor = hexColor.color
                                 selectedHexID = hexColor.id
                             }
                             .frame(width: beehiveSize, height: beehiveSize)
                         }
                     }
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line2) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -5) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line3) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -10) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line4) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -15) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line5) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -20) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line6) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -25) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line7) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -30) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line8) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -35) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line9) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -40) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line10) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -45) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line11) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -50) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line12) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -55) // line (1) * 5
                    
                    HStack(spacing: overlap) {
                        ForEach(ColorPalete.line13) { hexColor in
                            Hexagon(
                                id: hexColor.id,
                                isSelected: selectedHexID == hexColor.id,
                                hexagonColor: hexColor.color
                            ) {
                                selectedColor = hexColor.color
                                selectedHexID = hexColor.id
                            }
                            .frame(width: beehiveSize, height: beehiveSize)
                        }
                    }
                     .offset(y: -60) // line (1) * 5
                 }
             }
             .frame(height: beehiveSize * 4) // * line num
             
             HStack {
                 VStack {
                     HStack(spacing: overlap) {
                         ForEach(ColorPalete.line2) { hexColor in
                             Hexagon(
                                 id: hexColor.id,
                                 isSelected: selectedHexID == hexColor.id,
                                 hexagonColor: hexColor.color
                             ) {
                                 selectedColor = hexColor.color
                                 selectedHexID = hexColor.id
                             }
                             .frame(width: beehiveSize, height: beehiveSize)
                         }
                     }
                      .offset(y: 8) // line (1) * 5
                     
                     HStack(spacing: overlap) {
                         ForEach(ColorPalete.line1) { hexColor in
                             Hexagon(
                                 id: hexColor.id,
                                 isSelected: selectedHexID == hexColor.id,
                                 hexagonColor: hexColor.color
                             ) {
                                 selectedColor = hexColor.color
                                 selectedHexID = hexColor.id
                             }
                             .frame(width: beehiveSize, height: beehiveSize)
                         }
                     }
                      .offset(y: -5) // line (1) * 5
                 }

                 RootHexagon()
                     .frame(width: 28, height: 28)
                     .foregroundColor(selectedColor)
             }
             .padding()
             .frame(width: 300, height: 50)
        }
        .frame(width: 300, height: 300)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        

    }
}

#Preview {
    ColorPickerComponent(selectedHexID: 3, selectedColor: .constant(.red))
}

