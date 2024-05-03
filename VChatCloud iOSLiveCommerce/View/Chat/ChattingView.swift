import SwiftUI
import PhotosUI
import FileProviderUI
import AlertToast
import VChatCloudSwiftSDK
import AVKit

struct ChattingView: View {
    @ObservedObject var routerViewModel: RouterViewModel
    @ObservedObject var chatroomViewModel: ChatroomViewModel
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var vChatCloud = VChatCloud.shared
    @ObservedObject var myChannel = MyChannel.shared

    @State var isShowEmoji: Bool = false
    @State var scrollProxy: ScrollViewProxy? = nil
    @State var lastViewId = UUID()
    @State var player: AVPlayer?
    @State var keyboardHeight = 0.0

    @FocusState var focusField: String?
    
    var filePath: URL? {
        guard let path = Bundle.main.path(forResource: "sample_video", ofType: "mp4") else {
            debugPrint("video not found :(")
            return nil
        }
        
        return URL(fileURLWithPath: path)
    }
    
    func hide() {
        focusField = nil
        isShowEmoji = false
    }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .ignoresSafeArea()
                .disabled(true)
                .onAppear {
                    guard let video = filePath else {
                        return
                    }
                    self.player = AVPlayer(url: video)
                    player?.play()
                    // 영상 재생 종료 시 처음부분으로 이동 후 다시 시작
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
                        self.player?.seek(to: .zero)
                        self.player?.play()
                    }
                }
            VStack(spacing: 0) {
                TitleBarView(routerViewModel: routerViewModel, chatroomViewModel: chatroomViewModel)
                    .padding(.horizontal, 15)
                    .onTapGesture(perform: hide)
                // 키보드 높이가 200작거나 이모지가 표시되지 않고 있을때만 렌더링 함
                if keyboardHeight <= 200 && !isShowEmoji {
                    Spacer()
                        .frame(maxHeight: 200 - keyboardHeight)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: hide)
                }
                ZStack {
                    Rectangle()
                        .foregroundColor(.black)
                        .mask({
                            LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top)
                        })
                        .ignoresSafeArea()
                        .onTapGesture(perform: hide)
                    VStack(spacing: 0) {
                        HStack(alignment: .bottom, spacing: 0) {
                            ChatBodyView(scrollProxy: $scrollProxy, lastViewId: $lastViewId)
                            LikeView(chatroomViewModel: chatroomViewModel)
                                .allowsHitTesting(true)
                        }
                        .padding(.horizontal, 15)
                        .mask({
                            LinearGradient(colors: [.black, .black, .black, .black, .clear], startPoint: .bottom, endPoint: .top)
                        })
                        .contentShape(Rectangle())
                        .onTapGesture(perform: hide)
                        TextFieldView(routerViewModel: routerViewModel, chatroomViewModel: chatroomViewModel, lastViewId: $lastViewId, scrollProxy: $scrollProxy, isShowEmoji: $isShowEmoji, focusField: _focusField)
                    }
                }
            }
            .toolbar(.hidden)
        }
        .background(.gray)
        .toolbar(.hidden)
        .onAppear {
            self.keyboardHeight = 0
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { noti in
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                self.keyboardHeight = height
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                self.keyboardHeight = 0
            }
        }

    }
}

struct ChattingView_Previews: PreviewProvider {
    static var previews: some View {
        ChattingView(routerViewModel: RouterViewModel(), chatroomViewModel: .MOCK, userViewModel: UserViewModel.MOCK)
            .onAppear {
                MyChannel.shared.chatlog.append(.mock)
                MyChannel.shared.myChatlog.append(.MOCK)
            }
    }
}
