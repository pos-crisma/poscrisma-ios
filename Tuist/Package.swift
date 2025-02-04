// swift-tools-version: 5.10
import PackageDescription

#if TUIST
  import ProjectDescription

  let packageSettings = PackageSettings(
    productTypes: [:]
  )
#endif

let package = Package(
  name: "Poscrisma",
  dependencies: [
    // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
    .package(url: "https://github.com/pointfreeco/swift-perception", from: "1.3.5"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.9"),
    .package(url: "https://github.com/pointfreeco/swift-navigation", from: "2.2.0"),
    .package(url: "https://github.com/airbnb/epoxy-ios", branch: "master"),
    .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
    .package(url: "https://github.com/supabase/supabase-swift.git", from: "2.20.2"),
    .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "8.0.0"),
    .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.5.0")
  ]
)
