import SwiftUI

private enum Constant {
    static let bigCircleSize: CGFloat = 34
    static let smallCircleSize: CGFloat = 32
    static let startExerciseButtonHeight: CGFloat = 120
    static let recentTrainingsButtonHeight: CGFloat = 69
    static let elementSpacing: CGFloat = 15
    static let horizontalPadding: CGFloat = 24
    static let calendarHeight: CGFloat = 290
    static let pickerSize: CGSize = CGSize(width: 120, height: 100)
    static let cornerRadius: CGFloat = 20
    static let overlayPadding: CGFloat = 16
    static let buttonFontSize: CGFloat = 30
}

struct HomeView: View {
    @State private var selectedDates = Array(repeating: false, count: 31)
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    private let months = Calendar.current.monthSymbols
    
    var body: some View {
        VStack {
            header
                .padding(.horizontal, Constant.horizontalPadding)
                .padding(.bottom, 7)
            
            calendarSection
                .padding(.horizontal, Constant.horizontalPadding)
                .padding(.bottom, 30)
            
            buttonsSection
                .padding(.horizontal, Constant.horizontalPadding)
            
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    private var header: some View {
        VStack(alignment: .leading, spacing: Constant.elementSpacing) {
            Text("Hey, name!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(yellowColor)
            
            Text("Ready for action?")
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: Constant.elementSpacing) {
            monthPicker
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                .frame(height: Constant.calendarHeight)
                .foregroundColor(systemDarkBlueColor)
                .overlay(calendarGrid.padding(Constant.overlayPadding))
        }
    }
    
    private var monthPicker: some View {
        HStack {
            Text("Trainings in")
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            
            Picker("Select Month", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(months[month - 1]).tag(month)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: Constant.pickerSize.width, height: Constant.pickerSize.height)
            .background(
                RoundedRectangle(cornerRadius: Constant.cornerRadius)
                    .foregroundColor(systemDarkBlueColor)
            )
        }
    }
    
    private var calendarGrid: some View {
        LazyVGrid(columns: columns, spacing: Constant.elementSpacing) {
            ForEach(Array(generateDays().enumerated()), id: \.offset) { _, day in
                if let day = day {
                    calendarDayView(day: day)
                } else {
                    Spacer()
                }
            }
        }
    }
    
    private func calendarDayView(day: Int) -> some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 2, dash: isToday(day) ? [8, 8] : []))
                .frame(width: Constant.bigCircleSize, height: Constant.bigCircleSize)
                .foregroundStyle(yellowColor)
            Circle()
                .frame(width: Constant.smallCircleSize, height: Constant.smallCircleSize)
                .foregroundColor(.black)
            Text("\(day)")
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
    
    private var buttonsSection: some View {
        VStack(spacing: Constant.elementSpacing) {
            Button(action: { print("Start exercise tapped") }) {
                ZStack {
                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                        .frame(height: Constant.startExerciseButtonHeight)
                        .foregroundColor(yellowColor)
                    Text("Start exercise")
                        .fontWeight(.bold)
                        .font(.system(size: Constant.buttonFontSize))
                        .foregroundColor(.black)
                }
            }
            
            Button(action: { print("Recent trainings tapped") }) {
                ZStack {
                    RoundedRectangle(cornerRadius: Constant.cornerRadius)
                        .frame(height: Constant.recentTrainingsButtonHeight)
                        .foregroundColor(systemDarkBlueColor)
                    Text("Recent Trainings")
                        .fontWeight(.bold)
                        .font(.system(size: Constant.buttonFontSize))
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func generateDays() -> [Int?] {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: Calendar.current.component(.year, from: Date()), month: selectedMonth)
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }
        
        let days = Array(range)
        let firstWeekday = (calendar.component(.weekday, from: startOfMonth) + 5) % 7
        return Array(repeating: nil, count: firstWeekday) + days
    }
    
    private func isToday(_ day: Int) -> Bool {
        let today = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        return today.day == day && today.month == selectedMonth
    }
}

#Preview {
    HomeView()
}

