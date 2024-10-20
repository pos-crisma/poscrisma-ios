import ProjectDescription

let project = Project(
  name: "Poscrisma",
  settings: .settings(configurations: [
    .debug(name: "Debug", xcconfig: "./xcconfigs/Poscrisma-Project.xcconfig"), 
    .release(name: "Release", xcconfig: "./xcconfigs/Poscrisma-Project.xcconfig"), 
  ]),
  targets: [
    .target( 
      name: "Poscrisma", 
      destinations: .iOS, 
      product: .app,
      bundleId: "org.poscrisma.poscrisma",
      deploymentTargets: .iOS("17.0"),
      sources: ["Poscrisma/**"],
      resources: [
        "Poscrisma/Resources/Assets.xcassets/**",
        "Poscrisma/Resources/Preview Content/**"
      ], 
      entitlements: "Poscrisma/Poscrisma.entitlements",
      dependencies: [
        .external(name: "Epoxy"),               // Epoxy from epoxy-ios
        .external(name: "Dependencies"),        // Dependencies from swift-dependencies
        .external(name: "DependenciesMacros"),  // DependenciesMacros from swift-dependencies
        .external(name: "SwiftNavigation"),     // SwiftNavigation from swift-navigation
        .external(name: "AppKitNavigation"),    // AppKitNavigation from swift-navigation
        .external(name: "SwiftUINavigation"),   // SwiftUINavigation from swift-navigation
        .external(name: "UIKitNavigation"),     // UIKitNavigation from swift-navigation
        .external(name: "SnapKit"),
        .external(name: "Supabase")
      ],
      settings: .settings(configurations: [
        .debug(name: "Debug", xcconfig: "./xcconfigs/Poscrisma.xcconfig"), 
        .release(name: "Release", xcconfig: "./xcconfigs/Poscrisma.xcconfig"), 
      ])
    ),
    .target(
      name: "PoscrismaTests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: "org.poscrisma.poscrisma.unitTest",
      sources: ["Poscrisma/**"],
      dependencies: [
          .target(name: "Poscrisma")
      ]
    ),
    .target(
      name: "PoscrismaUITests",
      destinations: .iOS,
      product: .uiTests,
      bundleId: "org.poscrisma.poscrisma.uiTests",
      sources: ["PoscrismaUITests/**"],
      dependencies: [
          .target(name: "Poscrisma")
      ]
    ),
  ]
)
