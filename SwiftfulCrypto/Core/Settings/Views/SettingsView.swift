//
//  SettingsView.swift
//  Krypton
//
//  Created by Adarsh Shukla on 08/04/22.
//

import SwiftUI

struct LinkModel: Identifiable {
    let id = UUID().uuidString
    let link: URL
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismissMode
    
    @State var selectedModel: LinkModel? = nil
    
    let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    
    let slackURL = URL(string: "https://app.slack.com/client/TC836KNQK/CC8B9LEVB")! //force unwrapping
    let uiTool = URL(string: "https://kanishkvijaywargiya.github.io/uicolorpicker.github.io/")!
    let personalURL = URL(string: "https://www.nicksarno.com")!
    let defaultURL = URL(string: "https://www.google.com")!
    
    var body: some View {
        NavigationView {
            ZStack {
                //background layer
                Color.theme.background.ignoresSafeArea()
                
                //content layer
                List {
                    swiftfulThinkingSection
                    coinGeckoSection
                    developerSection
                    applicationSection
                        
                }
                .listRowBackground(Color.theme.background.opacity(0.5))
            }
            .font(.headline)
            .fullScreenCover(item: $selectedModel) { SafariService(url: $0.link) }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(action: {
                        HapticManager.instance.notification(type: .success)
                        HapticManager.instance.impact(style: .heavy)
                        dismissMode()
                    })
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}

extension SettingsView {
    private var swiftfulThinkingSection: some View {
        Section(header: Text("Swiftful Thinking")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @swiftfulThinking course on YouTube. It uses MVVM Architecture, Combine and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
                        
            Text("Subscribe on YouTube 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: youtubeURL)
                }
            
            Text("Support his coffee addiction ☕️")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: coffeeURL)
                }
        }
    }
    private var coinGeckoSection: some View {
        Section(header: Text("coinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Text("Visit CoinGecko 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: coingeckoURL)
                }
        }
    }
    private var developerSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Kanishk Vijaywargiya. It uses SwiftUI and is written 100% in Swift. The projects benefits from multi-threading, publishers/subscribers and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Text("Visit Website 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: personalURL)
                }
        }
    }
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Text("Terms of Service 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: defaultURL)
                }
            Text("Privacy Policy 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: defaultURL)
                }
            Text("Company Website 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: defaultURL)
                }
            Text("Learn More 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: defaultURL)
                }
            Text("Join our Slack Channel! 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: slackURL)
                }
            Text("Cool Color Picker for Cool Designers 🥳")
                .foregroundColor(.blue)
                .onTapGesture {
                    HapticManager.instance.notification(type: .success)
                    HapticManager.instance.impact(style: .heavy)
                    selectedModel = LinkModel(link: uiTool)
                }
        }
    }
}
