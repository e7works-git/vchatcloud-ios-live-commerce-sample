import SwiftUI
import AlertToast
import VChatCloudSwiftSDK

struct TextFieldView: View {
    @ObservedObject var routerViewModel: RouterViewModel
    @ObservedObject var chatroomViewModel: ChatroomViewModel
    @ObservedObject var vChatCloud = VChatCloud.shared
    @ObservedObject var myChannel = MyChannel.shared
    
    @Binding var lastViewId: UUID
    @Binding var scrollProxy: ScrollViewProxy?
    @Binding var isShowEmoji: Bool
    
    @State var input: String = ""

    @FocusState var focusField: String?
    
    var isInputEmpty: Bool {
        input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isFocused: Bool {
        focusField != nil || isShowEmoji
    }
    
    func editingChange(value: Bool) {
        if !value {
            // 메시지 작성 종료 시 키보드 내림
            focusField = nil
        } else {
            // 메시지 작성 시작 시 이모지 내림
            isShowEmoji = false
        }
    }
    
    func toggleEmoji() {
        focusField = nil
        isShowEmoji.toggle()
    }

    func sendMessage() {
        if !isInputEmpty {
            vChatCloud.channel?.sendMessage(input)
            input = ""
            self.scrollProxy?.scrollTo(lastViewId, anchor: .bottom)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                ZStack {
                    Capsule()
                        .frame(height: 30)
                        .cornerRadius(15)
                        .overlay(content: {
                            Capsule()
                                .inset(by: 1)
                                .stroke(Color(hex: 0xe3e3e3), lineWidth: 1)
                        })
                        .foregroundColor(isFocused ? .white : .clear)
                    HStack {
                        Text("실시간 채팅에 참여하세요.")
                            .font(.system(size: 14))
                            .foregroundColor(isFocused ? Color(hex: 0x999999) : Color(hex: 0xffffff, hexAlpha: 0x80))
                            .padding(.leading, 10)
                            .opacity(input.isEmpty ? 1 : 0)
                        Spacer()
                    }
                    TextField("", text: $input, onEditingChanged: editingChange)
                        .focused($focusField, equals: "inputt")
                        .foregroundColor(isFocused ? .black : .white)
                        .padding(.leading, 12)
                        .padding(.trailing, 25)
                        .frame(minHeight: 30)
                    HStack(spacing: 0) {
                        Spacer()
                        Image(isShowEmoji ? "ico_emoticon_focus" : "ico_emoticon_default")
                            .padding(.trailing, 8)
                            .onTapGesture {
                                toggleEmoji()
                            }
                    }
                }
                Image("send")
                    .colorMultiply(isInputEmpty ? Color(hex: 0xaeaeae).opacity(1) : .white)
                    .disabled(isInputEmpty)
                    .onTapGesture {
                        sendMessage()
                    }
            }
            .padding(.leading, 15)
            .padding(.trailing, 20)
            .padding(.vertical, 10)
            .background(isFocused ? Color(hex: 0xeeeeee) : .clear)
            if isShowEmoji {
                EmojiFieldView(lastViewId: $lastViewId, scrollProxy: $scrollProxy)
                    .onAppear {
                        scrollProxy?.scrollTo(lastViewId)
                    }
            }
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        @FocusState var focusField: String?
        @State var lastViewId = UUID()
        @State var scrollProxy: ScrollViewProxy? = nil
        @State var isShowEmoji = false
        
        TextFieldView(routerViewModel: .init(), chatroomViewModel: .MOCK, lastViewId: $lastViewId, scrollProxy: $scrollProxy, isShowEmoji: $isShowEmoji)
            .background(.black)
    }
}
