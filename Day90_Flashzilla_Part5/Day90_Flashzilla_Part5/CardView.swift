//
//  CardView.swift
//  Day90_Flashzilla_Part5
//
//  Created by Lee McCormick on 7/11/22.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var removal: (() -> Void)? = nil
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled // Second, we need to help the system to read the answer to the cards as well as the questions. This is possible right now, but only if the user swipes around on the screen – it’s far from obvious. So, to fix this we’re going to detect whether the user has accessibility enabled on their device, and if so automatically toggle between showing the prompt and showing the answer. That is, rather than have the answer appear below the prompt we’ll switch it out and just show the answer, which will cause VoiceOver to read it out immediately.
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    /*
     iOS comes with a number of options for generating haptic feedback, and they are all available for us to use in SwiftUI. In its simplest form, this is as simple as creating an instance of one of the subclasses of UIFeedbackGenerator then triggering it when you’re ready, but for more precise control over feedback you should first call its prepare() method to give the Taptic Engine chance to warm up.
     
     There are a few different subclasses of UIFeedbackGenerator we could use, but the one we’ll use here is UINotificationFeedbackGenerator because it provides success and failure haptics that are common across iOS. Now, we could add one central instance of UINotificationFeedbackGenerator to every ContentView, but that causes a problem: ContentView gets notified whenever a card has been removed, but isn’t notified when a drag is in progress, which means we don’t have the opportunity to warm up the Taptic Engine.
     */
    @State private var feedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .white
                    : .white.opacity(1 - Double(abs(offset.width / 50))))
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? .green : .red))
                .shadow(radius: 10)
            VStack {
                if voiceOverEnabled { //We’re going to change that so the prompt and answer are shown in a single text view, with accessibilityEnabled deciding which layout is shown. Amend your code to this.
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton) // First, we need to make it clear that our cards are tappable buttons. This is as simple as adding
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    /*
                     That alone is enough to get haptics in our app, but there is always the risk that the haptic will be delayed because the Taptic Engine wasn’t ready. In this case the haptic will still play, but it could be up to maybe half a second late – enough to feel just that little bit disconnected from our user interface.
                     
                     To improve this we need to call prepare() on our haptic a little before triggering it. It is not enough to call prepare() immediately before activating it: doing so does not give the Taptic Engine enough time to warm up, so you won’t see any reduction in latency. Instead, you should call prepare() as soon as you know the haptic might be needed.
                     
                     Now, there are two helpful implementation details that you should be aware of.
                     
                     First, it’s OK to call prepare() then never triggering the effect – the system will keep the Taptic Engine ready for a few seconds then just power it down again. If you repeatedly call prepare() and never trigger it the system might start ignoring your prepare() calls until at least one effect has happened.
                     
                     Second, it’s perfectly allowable to call prepare() many times before triggering it once – prepare() doesn’t pause your app while the Taptic Engine warms up, and also doesn’t have any real performance cost when the system is already prepared.
                     
                     Putting these two together, we’re going to update our drag gesture so that prepare() is called whenever the gesture changes. This means it could be called a hundred times before the haptic is finally triggered, because it will get triggered every time the user moves their finger.
                     
                     So, modify your onChanged() closure to this:
                     */
                    feedback.prepare() // Important: Warming up the Taptic Engine helps reduce the latency between us playing the effect and it actually happening, but it also has a battery impact so the system will only stay ready for a second or two after you call prepare().
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        /*
                         The reason I’m saying this is because we added two haptic notifications to our app that will get played a lot. And while you’re testing out in small doses these haptics probably feel great – you’re making your phone buzz, and it can be really delightful. However, if you’re a serious user of this app then our haptics might hit two problems:
                         1) The user might find them annoying, because they’ll happen once every two or three seconds depending on how fast they are.
                         2) Worse, the user might become desensitized to them – they lose all usefulness either as a notification or as a little spark of delight.
                         if offset.width > 0 {
                         feedback.notificationOccurred(.success)
                         } else {
                         feedback.notificationOccurred(.error)
                         }
                         */
                        if offset.width < 0 {
                            feedback.notificationOccurred(.error)
                        }
                        removal?()
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset) // efore we’re done, I’d like to add one tiny extra change. Right now if you drag an image a little then let go we set its offset back to zero, which causes it to jump back into the center of the screen. If we attach a spring animation to our card, it will slide into the center, which I think is a much clearer indication to our user of what actually happened. To make this happen, add an animation() modifier to the end of the ZStack in CardView, directly after the onTapGesture():
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
