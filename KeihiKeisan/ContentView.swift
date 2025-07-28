//
//  ContentView.swift
//  KeihiKeisan
//
//  Created by KOJI OSAKI on 2025/07/16.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            completion(granted)
        }
    }
}

func scheduleMonthlyNotification() {
    let center = UNUserNotificationCenter.current()

    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            let content = UNMutableNotificationContent()
            content.title = "毎月のお知らせ"
            content.body = "14日になりました！経費を入力しお父さんに送信しましょう！"
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.day = 14 // 毎月15日に通知
            dateComponents.hour = 10 // 午前10時に通知
            dateComponents.minute = 00

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(identifier: "monthlyNotification", content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print("通知のスケジュールに失敗しました: \(error)")
                } else {
                    print("通知が正常にスケジュールされました")
                }
            }
        } else if let error = error {
            print("通知の許可をリクエストできませんでした: \(error)")
        }
    }
}

struct ContentView: View {
    @AppStorage("busV") var busV = 0
    @AppStorage("engV") var engV = 0
    @AppStorage("eatV") var eatV = 0
    @AppStorage("eatC") var eatC = 0
    @AppStorage("cycV") var cycV = 0
    @AppStorage("dsV") var dsV = 0
    @AppStorage("otherV") var otherV = 0
    @AppStorage("total") var total = 0
    @State private var isPresented = false
    @State private var otherInput = ""
    let frontGradientView: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [.yellow, .red]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    let backGradientView: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [.red, .blue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    var body: some View {
        ZStack {
            Image(.wall)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            VStack {
                HStack {
                    Text("毎月計算機")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(width: 230, height: 10)

                    Button {
                        busV = 0
                        engV = 0
                        eatV = 0
                        cycV = 0
                        dsV = 0
                        otherV = 0
                    } label: {
                        Text("リセット")
                            .bold()
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(
                    Rectangle()
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(width: 2000, height: 130)
                        .ignoresSafeArea()
                )

                HStack {
                    VStack {
                        Button {
                            busV += 660
                        } label: {
                            Text("バス代")
                                .foregroundStyle(.black)
                                .frame(width: 180, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        // ぼかし効果
                                        .foregroundStyle(.ultraThinMaterial)
                                        // ドロップシャドウで立体感を表現
                                        .shadow(color: .init(white: 0.4, opacity: 0.4), radius: 5, x: 0, y: 0)
                                )
                                .overlay(
                                    // strokeでガラスの縁を表現
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.init(white: 1, opacity: 0.5), lineWidth: 1)
                                )
                                .font(.title)
                        }
                        Menu {
                            Picker("今月の回数を選んでください", selection: $eatV) {
                                Text("週１")
                                    .tag(2000)
                                Text("週２")
                                    .tag(4000)
                                Text("週３")
                                    .tag(6000)
                                Text("週４")
                                    .tag(8000)
                                Text("週５")
                                    .tag(10000)
                            }
                        } label: {
                            Text("食費")
                                .frame(width: 180, height: 100)
                                .foregroundStyle(.black)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(.ultraThinMaterial)
                                        // ドロップシャドウで立体感を表現
                                        .shadow(color: .init(white: 0.4, opacity: 0.4), radius: 5, x: 0, y: 0)
                                )
                                .overlay(
                                    // strokeでガラスの縁を表現
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.init(white: 1, opacity: 0.5), lineWidth: 1)
                                )
                                .font(.title)
                        }
                    }
                    VStack {
                        Menu {
                            Picker("今月の回数を選んでください", selection: $engV) {
                                Text("１２回未満")
                                    .tag(0)
                                Text("１２回以上")
                                    .tag(3500)
                                Text("２０回以上")
                                    .tag(7000)
                            }
                        } label: {
                            Text("英会話")
                                .foregroundStyle(.black)
                                .frame(width: 180, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        // ぼかし効果
                                        // .ultraThinMaterialはiOS15から対応
                                        .foregroundStyle(.ultraThinMaterial)
                                        // ドロップシャドウで立体感を表現
                                        .shadow(color: .init(white: 0.4, opacity: 0.4), radius: 5, x: 0, y: 0)
                                )
                                .overlay(
                                    // strokeでガラスの縁を表現
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.init(white: 1, opacity: 0.5), lineWidth: 1)
                                )
                                .font(.title)
                        }
                        Button {
                            cycV += 1100
                        } label: {
                            Text("駐輪場代")
                                .frame(width: 180, height: 100)
                                .foregroundStyle(.black)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(.ultraThinMaterial)
                                        // ドロップシャドウで立体感を表現
                                        .shadow(color: .init(white: 0.4, opacity: 0.4), radius: 5, x: 0, y: 0)
                                )
                                .overlay(
                                    // strokeでガラスの縁を表現
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.init(white: 1, opacity: 0.5), lineWidth: 1)
                                )
                                .font(.title)
                        }
                    }
                }
                HStack {
                    VStack {
                        Button {
                            dsV = 8000
                        } label: {
                            Text("車校")
                                .foregroundStyle(.black)
                                .frame(width: 180, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(.ultraThinMaterial)
                                        // ドロップシャドウで立体感を表現
                                        .shadow(color: .init(white: 0.4, opacity: 0.4), radius: 5, x: 0, y: 0)
                                )
                                .overlay(
                                    // strokeでガラスの縁を表現
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.init(white: 1, opacity: 0.5), lineWidth: 1)
                                )
                                .font(.title)
                        }
                    }
                    VStack {
                        Button {
                            isPresented = true
                        } label: {
                            Text("その他")
                                .foregroundStyle(.black)
                                .frame(width: 180, height: 100)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        // ぼかし効果
                                        // .ultraThinMaterialはiOS15から対応
                                        .foregroundStyle(.ultraThinMaterial)
                                        // ドロップシャドウで立体感を表現
                                        .shadow(color: .init(white: 0.4, opacity: 0.4), radius: 5, x: 0, y: 0)
                                )
                                .overlay(
                                    // strokeでガラスの縁を表現
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.init(white: 1, opacity: 0.5), lineWidth: 1)
                                )
                                .font(.title)
                        }
                        .alert("金額を入力してください", isPresented: $isPresented) {
                            TextField("例) 1000", text: $otherInput)
                            Button("OK") {
                                if let value = Int(otherInput) {
                                    otherV += value
                                } else {
                                    // 数値変換失敗時の処理（例：0にする or 無視）
                                    otherV = 0
                                }
                            }
                            Button("キャンセル", role: .cancel) { }
                        }
                    }
                }
                Spacer()
                Text("計算結果")
                    .font(.title)
                    .frame(width: 180, height: 45)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            // ぼかし効果
                            // .ultraThinMaterialはiOS15から対応
                            .foregroundStyle(.ultraThinMaterial)
                            // ドロップシャドウで立体感を表現
                            .shadow(color: .init(white: 0.4, opacity: 0.4), radius: 5, x: 0, y: 0)
                    )

                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(width: 360, height: 300)
                    .cornerRadius(40)
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.gray, lineWidth: 2)
                            Text("バス代:　　　　\(busV)円\n英会話:　　　　\(engV)円\n食費:　　　　　\(eatV)円\n駐輪場代:　   　 \(cycV)円\n自動車学校代:  -\(dsV)円\nその他:　   　　 \(otherV)円\n-------------------------\n合計: 　   　　　\(busV + engV + eatV + cycV - dsV + otherV)円")
                                .font(.title)
                                .foregroundStyle(.black)
                                .frame(alignment: .leading)
                                .textSelection(.enabled)
                        }
                    )
            }
        }
        .onAppear {
            scheduleMonthlyNotification()
        }
    }
}

#Preview {
    ContentView()
}
