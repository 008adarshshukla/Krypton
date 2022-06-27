//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by KANISHK VIJAYWARGIYA on 05/04/22.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription: Bool = false
    @State var websiteLink: Bool = false
    @State var redditLink: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ChartView(coin: vm.coin).padding(.vertical)
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    
                    descriptionSection
                    
                    overviewGrid
                    
                    additionalTitle
                    Divider()
                    additionalGrid
                    
                    websiteSection
                }
                .padding()
            }
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItems
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            HapticManager.instance.notification(type: .success)
                            HapticManager.instance.impact(style: .heavy)
                            showFullDescription.toggle()
                        }
                    }) {
                        Text(showFullDescription ? "Less" : "Read more...")
                            .font(.caption).bold()
                            .padding(.vertical, 4)
                    }
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    private var additionalTitle: some View {
        Text("Additional Detail")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var additionalGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if
                let websiteString = vm.websiteURL,
                let url = URL(string: websiteString) {
                Text("Website")
                    .onTapGesture {
                        HapticManager.instance.notification(type: .success)
                        HapticManager.instance.impact(style: .heavy)
                        websiteLink.toggle()
                    }
                    .fullScreenCover(isPresented: $websiteLink) {
                        SafariService(url: url)
                    }
            }
            
            if
                let redditString = vm.redditURL,
                let url = URL(string: redditString) {
                Text("Reddit")
                    .onTapGesture {
                        HapticManager.instance.notification(type: .success)
                        HapticManager.instance.impact(style: .heavy)
                        redditLink.toggle()
                    }
                    .fullScreenCover(isPresented: $redditLink) {
                        SafariService(url: url)
                    }
            }
        }
        .foregroundColor(.blue)
        .frame(maxWidth:. infinity, alignment: .leading)
        .font(.headline)
    }
}

/* when this dosen't work
 @StateObject var vm = DetailViewModel(coin: <#T##CoinModel#>)
 let coin: CoinModel
 
 both these statements are getting initialize at the same time. So this is not possible to pass in vm.
 So use init() {...}
 init(coin: CoinModel) {
 ----- _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
 print("initializing the detail view for \(coin.name)")
 }
 */

/*
 @Binding var coin: CoinModel?
 
 init(coin: Binding<CoinModel?>) {
 self._coin = coin
 print("initializing the detail view for \(String(describing: coin.wrappedValue?.name))")
 }
 
 struct DetailView_Previews: PreviewProvider {
 static var previews: some View {
 DetailView(coin: .constant(dev.coin))
 }
 }
 
 */
