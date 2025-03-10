import SwiftUI
import CasePaths

extension Home {
    struct TabGeometry: Equatable {
        let id: CategoryTab.Tab
        let frame: CGRect
    }
    
    struct CategoryTab: Identifiable {
        let id: Tab
        
        enum Tab: String, CaseIterable {
            case research = "Research"
            case development = "Development"
            case analytics = "Analytics"
            case audience = "Audience"
            case content = "Content"
            case settings = "Settings"
            case help = "Help"
        }
    }
} 