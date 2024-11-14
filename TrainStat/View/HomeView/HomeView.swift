import SwiftUI
import UIKit

struct HomeView: View {
    private let currentDate = Calendar.current.component(.day, from: Date())
    
    @State private var selectedDates = Array(repeating: false, count: 31)
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Hey, name!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(yellowColor)
                
                Text("Ready for action?")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 7)
            .padding(.horizontal, 24)
            
            VStack(alignment: .leading) {
                Text("Trainings in")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 290)
                    .foregroundColor(systemDarkBlueColor)
                    .overlay(
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(1...31, id: \.self) { day in
                                ZStack {
                                    Circle()
                                        .stroke(style: StrokeStyle(lineWidth: 2, dash: "\(currentDate)" == "\(day)" ? [8, 8] : []))
                                        .frame(width: 34, height: 34)
                                        .foregroundStyle(yellowColor)
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(.black)
                                    Text("\(day)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                            .padding(16)
                    )
                    .padding(.bottom, 30)
                
                Button(action: { print("action") }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 120)
                            .foregroundColor(yellowColor)
                        Text("Start exercise")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .font(.system(size: 30))
                    }
                }.padding(.bottom, 30)
                
                Button(action: { print("action") }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .frame(height: 69)
                            .foregroundColor(systemDarkBlueColor)
                        Text("Recent Trainings")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                    }
                }
            }
            .padding(.horizontal, 32)
            Spacer()
        }
        .background(Color.black)
    }
}

#Preview {
    HomeView()
}


