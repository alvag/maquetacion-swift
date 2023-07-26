//
//  ContentView.swift
//  Inventory Managment
//
//  Created by Max Alva on 25/07/23.
//

import SwiftUI

struct CustomRectangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.minX, y: rect.minY)) // top-left
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // top-right
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // bottom-right
    
    // agregar puntos para dibujar la curva en la parte inferior
    let c1 = CGPoint(x: rect.midX + 50, y: rect.maxY + 20)
    let c2 = CGPoint(x: rect.midX - 50, y: rect.maxY + 20)
    
    path.addCurve(
      to: CGPoint(x: rect.minX, y: rect.maxY), // boton-left
      control1: c1,
      control2: c2
    )
    
    path.closeSubpath() // no hace falta
    return path
    
  }
}

struct ContentView: View {
  
  @State var inventories: [InventoryModel] = []
  
    var body: some View {
      ZStack(alignment: .top) {
        VStack {
          headerBackground
          Spacer()
        }
        
        navBarCustom
        
        VStack {
          Spacer().frame(height: 60)
          cardStatus
          
          sectionTitle
          
          List(inventories) { inventory in
            
            VStack(alignment: .leading, spacing: 13) {
              HStack {
                Image(systemName: inventory.icon)
                Text(inventory.type.rawValue.uppercased()).font(.system(size: 15, weight: .light))
                Spacer()
                Circle().fill(inventory.statusColor).frame(width: 10, height: 10)
                Text(inventory.status.uppercased()).font(.system(size: 15, weight: .light))
              }.foregroundColor(Color.gray)
              
              Text(inventory.title)
                .font(.system(size: 16, weight: .bold))
              
              HStack {
                Text("For").foregroundColor(.gray)
                Text(inventory.owner)
                Image(systemName: "chevron.down").font(.system(size: 13, weight: .bold))
                Spacer()
                Text(inventory.time)
              }
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .overlay(
              HStack {
                Rectangle()
                  .fill(inventory.cardColor)
                  .padding(.vertical, -20)
                  .frame(width: 5)
                Spacer()
              }.frame(maxWidth: .infinity)
            )
            .padding(.vertical, 20)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.gray.opacity(0.2), radius: 15, x: 0, y: 0)
            .padding(.vertical, 10)
            .listRowSeparator(.hidden)
            
          }
          .padding(.horizontal, 0)
          .listStyle(.plain)
          
        }
      }
      .onAppear {
        inventories = InventoryModel.getInventory()
      }
    }
  
  var sectionTitle: some View {
    HStack {
      Text("Due today")
      
      Spacer()
      
      HStack {
        Text("Sort By")
        Button {
          print("button pressend")
        } label: {
          Image(systemName: "slider.vertical.3")
        }
      }
    }
    .padding(.top, 20)
    .foregroundColor(Color.black.opacity(0.5))
    .padding(.horizontal, 20)
  }
  
  var cardStatus: some View {
    HStack {
      
      VStack(spacing: 10) {
        Text("421")
          .font(.system(size: 25, weight: .bold))
        Text("overdue")
          .font(.system(size: 15))
          .foregroundColor(Color.gray)
      }
      Spacer()
      VStack(spacing: 10) {
        Text("81")
          .font(.system(size: 25, weight: .bold))
        Text("to do")
          .font(.system(size: 15))
          .foregroundColor(Color.gray)
      }
      Spacer()
      VStack(spacing: 10) {
        Text("72")
          .font(.system(size: 25, weight: .bold))
        Text("open")
          .font(.system(size: 15))
          .foregroundColor(Color.gray)
      }
      Spacer()
      VStack(spacing: 10) {
        Text("51")
          .font(.system(size: 25, weight: .bold))
        Text("due today")
          .font(.system(size: 15))
          .foregroundColor(Color.gray)
      }
      
    }
    .padding(.horizontal, 30)
    .padding(.vertical, 20)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .shadow(color: Color.gray.opacity(0.3), radius: 15, x: 0, y: 0)
    .padding(.horizontal, 20)
  }
  
  var navBarCustom: some View {
    VStack {
      HStack {
        Button {
          print("-")
        } label: {
          Image(systemName: "line.3.horizontal")
            .font(.system(size: 25, weight: .bold))
        }.padding(.horizontal, 20)
          .padding(.vertical, 10)
        
        Spacer()
        
        Text("Inventory Managment")
          .font(.system(size: 20, weight: .bold))
        
        Button {
          print("-")
        } label: {
          Image(systemName: "plus")
            .font(.system(size: 25, weight: .bold))
        }.padding(.horizontal, 20)
          .padding(.vertical, 10)
      }.foregroundColor(Color.white)
    }
  }
  
  var headerBackground: some View {
    Rectangle()
      .fill(LinearGradient(colors: [
        Color(red: 82/255, green: 133/255, blue: 246/255),
        Color(red: 40/255, green: 92/255, blue: 222/255),
        Color(red: 40/255, green: 92/255, blue: 222/255),
      ], startPoint: .bottom, endPoint: .top))
      .frame(maxWidth: .infinity)
      .frame(height: 150)
      .mask{
        CustomRectangle()
      }
      .edgesIgnoringSafeArea(.top)
  }
}

struct InventoryModel: Identifiable {
  let id = UUID()
  let icon: String
  let statusColor: Color
  let type: `Type`
  let title: String
  let status: String
  let owner: String
  let time: String
  let cardColor: Color
  
  static func getInventory() -> [Self] {
    return [
      InventoryModel(icon: "square.stack.3d.up.fill", statusColor: .cyan, type: .asset, title: "Request for a new Apple Macbook Pro", status: "OPEN", owner: "Max Alva", time: "2m", cardColor: .cyan),
      
      InventoryModel(icon: "questionmark.circle.fill", statusColor: .green, type: .troubleshot, title: "Request for a new Apple Macbook Pro", status: "IN PROGRESS", owner: "Max Alva", time: "5m", cardColor: .orange),
      
      InventoryModel(icon: "square.stack.3d.up.fill", statusColor: .blue, type: .troubleshot, title: "Request for a new Apple Macbook Pro", status: "ACCEPTED", owner: "Max Alva", time: "7m", cardColor: .blue),
      
      InventoryModel(icon: "questionmark.circle.fill", statusColor: .green, type: .troubleshot, title: "Request for a new Apple Macbook Pro", status: "SOLVED", owner: "Max Alva", time: "2m", cardColor: .orange),
    ]
  }
  
  enum `Type`: String {
    case asset
    case troubleshot
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
