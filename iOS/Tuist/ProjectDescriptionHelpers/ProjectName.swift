//
//  ProjectName.swift
//  ProjectDescriptionHelpers
//
//  Created by KiWoong Hong on 3/3/24.
//

import ProjectDescription

public enum Module: CaseIterable {
    case app
    case data
    case core
    case designSystem
    case domain
    case feature
    
    public var name: String {
        switch self {
        case .app: return "App"
        case .data: return "Data"
        case .core: return "Core"
        case .designSystem: return "DesignSystem"
        case .domain: return "Domain"
        case .feature: return "Feature"
        }
    }
    
    public var bundleSuffix: String {
        switch self {
        case .data: return ".data"
        case .core: return ".core"
        case .designSystem: return ".designSystem"
        case .domain: return ".domain"
        case .feature: return ".feature"
        default: return ""
        }
    }
    
    public var hasResource: Bool {
        switch self {
        case .app, .designSystem: return true
        default: return false
        }
    }
    
    public var path: ProjectDescription.Path {
        return .relativeToRoot("traveline/" + self.name)
    }
    
    public var project: TargetDependency {
        return .project(target: self.name, path: self.path)
    }
    
}
