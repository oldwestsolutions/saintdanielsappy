import SwiftUI

struct Theme {
    static let primaryColor = Color(red: 0.133, green: 0.231, blue: 0.157) // Dark green
    static let secondaryColor = Color(red: 0.71, green: 0.612, blue: 0.318) // Gold
    static let backgroundColor = Color(red: 0.859, green: 0.835, blue: 0.808) // Beige
    static let cardBackgroundColor = Color.white
    
    struct Typography {
        static let titleFont = Font.custom("Georgia", size: 32).weight(.bold)
        static let headlineFont = Font.custom("Georgia", size: 24).weight(.semibold)
        static let bodyFont = Font.system(size: 16)
        static let captionFont = Font.system(size: 14)
    }
    
    struct Button {
        static let primaryStyle: some View {
            RoundedRectangle(cornerRadius: 8)
                .fill(secondaryColor)
        }
        
        static let secondaryStyle: some View {
            RoundedRectangle(cornerRadius: 8)
                .stroke(secondaryColor, lineWidth: 1)
        }
    }
    
    struct Card {
        static let style: some View {
            RoundedRectangle(cornerRadius: 12)
                .fill(cardBackgroundColor)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct RoyalButton: View {
    let title: String
    let action: () -> Void
    let isPrimary: Bool
    
    init(_ title: String, isPrimary: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isPrimary = isPrimary
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundColor(isPrimary ? .white : Theme.secondaryColor)
                .background(isPrimary ? Theme.secondaryColor : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Theme.secondaryColor, lineWidth: isPrimary ? 0 : 1)
                )
                .cornerRadius(8)
        }
    }
}

struct RoyalCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Theme.Card.style)
    }
} 