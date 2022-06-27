//
//  ChartView.swift
//  Krypton
//
//  Created by Adarsh Shukla on 06/04/22.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    private let maxY: Double
    private let minY: Double
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? [] //7D means 7 days
        maxY = data.max() ?? 0.0
        minY = data.min() ?? 0.0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60) //-7 days * 24hrs * 60mins * 60sec
    }
    /*
     count starts from 1, 2, 3 & index starts from 0, 1, 2
     count = 1 & index = 0 + 1 => 1
     1 * width / 3 => 1 * 3
     2 * 3 = 6 ...
     3 * 3 = 9
     100 * 3 = 300
     
     60,000 - max
     50,000 - min
     max-min = 10,000 - yAxis
     52,000 - data point
     52,000 - min = 52,000 - 50,000 = 2000 / yAxis = 2000 / 10,000 = 20%
     */
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            shortDateLabels.padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2)) {
                    percentage = 1
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {
                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY)) / yAxis) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    private var shortDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
