import SwiftUI

@main
struct DanliuRijiApp: App {
    @StateObject private var store = DiaryStore()
    @State private var isShowingLaunchScreen = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(store)
                    .tint(.orange)

                if isShowingLaunchScreen {
                    AppLaunchView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .task {
                // Keep this brief. It is a branded handoff into the diary, not an ad screen.
                try? await Task.sleep(for: .milliseconds(900))
                withAnimation(.easeOut(duration: 0.34)) {
                    isShowingLaunchScreen = false
                }
            }
        }
    }
}

private struct AppLaunchView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasAppeared = false

    var body: some View {
        ZStack {
            Color(red: 1.0, green: 0.965, blue: 0.89)
                .ignoresSafeArea()

            launchGlow
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                brandMark
                    .scaleEffect(hasAppeared ? 1 : 0.78)
                    .opacity(hasAppeared ? 1 : 0)

                Text("蛋六日记")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(Color(red: 0.27, green: 0.19, blue: 0.12))
                    .padding(.top, 24)
                    .opacity(hasAppeared ? 1 : 0)

                Spacer()

                HStack(spacing: 6) {
                    Circle().frame(width: 5, height: 5)
                    Capsule().frame(width: 30, height: 5)
                    Circle().frame(width: 5, height: 5)
                }
                .foregroundStyle(Color.orange.opacity(0.72))
                .padding(.bottom, 54)
                .opacity(hasAppeared ? 1 : 0)
            }
            .padding(.horizontal, 32)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("蛋六日记，正在打开")
        .onAppear {
            withAnimation(reduceMotion ? .easeOut(duration: 0.2) : .spring(response: 0.62, dampingFraction: 0.72)) {
                hasAppeared = true
            }
        }
    }

    private var launchGlow: some View {
        ZStack {
            Circle()
                .fill(Color.orange.opacity(0.16))
                .frame(width: 310, height: 310)
                .blur(radius: 32)
                .offset(x: 130, y: -290)

            Circle()
                .fill(Color(red: 1.0, green: 0.75, blue: 0.35).opacity(0.16))
                .frame(width: 240, height: 240)
                .blur(radius: 24)
                .offset(x: -145, y: 315)
        }
    }

    private var brandMark: some View {
        Image("LaunchLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 128, height: 128)
            .clipShape(RoundedRectangle(cornerRadius: 29, style: .continuous))
            .shadow(color: Color.orange.opacity(0.18), radius: 20, y: 10)
            .accessibilityHidden(true)
    }
}
