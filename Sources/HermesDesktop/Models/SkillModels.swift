import Foundation

struct SkillListResponse: Codable {
    let ok: Bool
    let items: [SkillSummary]
}

struct SkillDetailResponse: Codable {
    let ok: Bool
    let item: SkillDetail
}

struct SkillSummary: Codable, Identifiable, Hashable {
    let id: String
    let slug: String
    let category: String?
    let relativePath: String
    let name: String?
    let description: String?
    let version: String?
    let tags: [String]
    let relatedSkills: [String]
    let hasReferences: Bool
    let hasScripts: Bool
    let hasTemplates: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case category
        case relativePath = "relative_path"
        case name
        case description
        case version
        case tags
        case relatedSkills = "related_skills"
        case hasReferences = "has_references"
        case hasScripts = "has_scripts"
        case hasTemplates = "has_templates"
    }

    var resolvedName: String {
        if let name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return name
        }
        return slug
    }

    var trimmedDescription: String? {
        guard let description else { return nil }
        let value = description.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }

    var featureBadges: [SkillFeatureBadge] {
        var badges: [SkillFeatureBadge] = []
        if hasReferences {
            badges.append(.references)
        }
        if hasScripts {
            badges.append(.scripts)
        }
        if hasTemplates {
            badges.append(.templates)
        }
        return badges
    }

    var resolvedCategory: String {
        guard let category,
              !category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Root"
        }
        return category
    }

    func matchesSearch(_ query: String) -> Bool {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return true }

        let normalizedQuery = trimmedQuery.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
        let haystacks = [
            resolvedName,
            resolvedCategory
        ]

        return haystacks.contains { value in
            value.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
                .localizedStandardContains(normalizedQuery)
        }
    }
}

struct SkillDetail: Codable, Identifiable, Hashable {
    let id: String
    let slug: String
    let category: String?
    let relativePath: String
    let name: String?
    let description: String?
    let version: String?
    let tags: [String]
    let relatedSkills: [String]
    let hasReferences: Bool
    let hasScripts: Bool
    let hasTemplates: Bool
    let markdownContent: String

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case category
        case relativePath = "relative_path"
        case name
        case description
        case version
        case tags
        case relatedSkills = "related_skills"
        case hasReferences = "has_references"
        case hasScripts = "has_scripts"
        case hasTemplates = "has_templates"
        case markdownContent = "markdown_content"
    }

    var resolvedName: String {
        if let name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return name
        }
        return slug
    }

    var trimmedDescription: String? {
        guard let description else { return nil }
        let value = description.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }

    var featureBadges: [SkillFeatureBadge] {
        var badges: [SkillFeatureBadge] = []
        if hasReferences {
            badges.append(.references)
        }
        if hasScripts {
            badges.append(.scripts)
        }
        if hasTemplates {
            badges.append(.templates)
        }
        return badges
    }
}

enum SkillFeatureBadge: String, Identifiable {
    case references
    case scripts
    case templates

    var id: String { rawValue }

    var title: String {
        switch self {
        case .references:
            "references"
        case .scripts:
            "scripts"
        case .templates:
            "templates"
        }
    }
}
