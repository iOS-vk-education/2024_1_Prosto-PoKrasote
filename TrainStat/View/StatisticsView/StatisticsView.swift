import SwiftUI

struct StatisticCard: View {
    let title: String
    let value: String
    let delta: String
    let deltaColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.white)
                }
                Spacer()
                HStack(alignment: .bottom, spacing: 4) {
                    Text(value)
                        .font(.system(size: 35, weight: .regular))
                        .foregroundColor(.white)
                    Text(delta)
                        .font(.caption)
                        .foregroundColor(deltaColor)
                        .padding(.bottom, 8)
                }
            }
            .padding(16)
        }
        .frame(width: 140, height: 140)
    }
}

struct StatisticsView: View {
    @EnvironmentObject var router: StatisticsRouter
    private let arraySectionTime = ["Day", "Month", "Year"]
    @State private var sectionSelected = 0

    var body: some View {
        ZStack {
            gradient1.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text("Progress")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                        .frame(height: 32)
                    HStack(spacing: 0) {
                        ForEach(arraySectionTime.indices, id: \.self) { idx in
                            Text(arraySectionTime[idx])
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .foregroundColor(idx == sectionSelected ? .black : .white)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    sectionSelected = idx
                                }
                                .background(
                                    Group {
                                        if idx == sectionSelected {
                                            RoundedRectangle(cornerRadius: 5)
                                                .fill(Color.white)
                                                .padding(3)
                                        }
                                    }
                                )
                        }
                    }
                    .frame(height: 32)
                    
                }

                Rectangle()
                    .frame(height: 254)
                    .foregroundColor(.white.opacity(0.3))
                HStack(spacing: 32) {
                    StatisticCard(title: "Workouts", value: "20", delta: "+2", deltaColor: .white)
                       StatisticCard(title: "Workouts", value: "20", delta: "+2", deltaColor: .white)
                                }
                .frame(maxWidth: .infinity, alignment: .center)

                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 35)
        }
    }
}




#Preview {
    StatisticsView()
}

