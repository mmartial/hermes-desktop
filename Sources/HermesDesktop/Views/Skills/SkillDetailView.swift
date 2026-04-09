import SwiftUI

struct SkillDetailView: View {
    let summary: SkillSummary?
    let detail: SkillDetail?
    let errorMessage: String?
    let isLoading: Bool

    private let metadataColumns = [
        GridItem(.adaptive(minimum: 180), alignment: .topLeading)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let detail {
                    headerPanel(detail)

                    if let description = detail.trimmedDescription {
                        HermesSurfacePanel(
                            title: "Description",
                            subtitle: "Frontmatter summary for the selected skill."
                        ) {
                            Text(description)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                    }

                    if !detail.tags.isEmpty || !detail.relatedSkills.isEmpty || !detail.featureBadges.isEmpty {
                        metadataPanel(detail)
                    }

                    HermesSurfacePanel(
                        title: "SKILL.md",
                        subtitle: "Full source content loaded from the remote host."
                    ) {
                        HermesInsetSurface {
                            Text(detail.markdownContent)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                    }
                } else if let summary, isLoading {
                    HermesSurfacePanel {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(summary.resolvedName)
                                .font(.title2)
                                .fontWeight(.semibold)

                            Text(summary.relativePath)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .textSelection(.enabled)

                            ProgressView("Loading skill detail…")
                                .padding(.top, 8)
                        }
                    }
                } else if let errorMessage, summary != nil {
                    HermesSurfacePanel {
                        ContentUnavailableView(
                            "Unable to load skill detail",
                            systemImage: "exclamationmark.triangle",
                            description: Text(errorMessage)
                        )
                        .frame(maxWidth: .infinity, minHeight: 320)
                    }
                } else {
                    HermesSurfacePanel {
                        ContentUnavailableView(
                            "Select a skill",
                            systemImage: "book.closed",
                            description: Text("Choose a Hermes skill from the active host to inspect its metadata and full SKILL.md.")
                        )
                        .frame(maxWidth: .infinity, minHeight: 320)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 22)
        }
    }

    private func headerPanel(_ detail: SkillDetail) -> some View {
        HermesSurfacePanel {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(detail.resolvedName)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(detail.relativePath)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .textSelection(.enabled)
                    }

                    Spacer(minLength: 12)

                    if let category = detail.category {
                        HermesBadge(text: category, tint: .secondary)
                    }
                }

                LazyVGrid(columns: metadataColumns, alignment: .leading, spacing: 14) {
                    HermesLabeledValue(
                        label: "Slug",
                        value: detail.slug,
                        isMonospaced: true
                    )

                    HermesLabeledValue(
                        label: "Category",
                        value: detail.category ?? "Root",
                        isMonospaced: detail.category != nil
                    )

                    HermesLabeledValue(
                        label: "Relative path",
                        value: detail.relativePath,
                        isMonospaced: true,
                        emphasizeValue: true
                    )

                    if let version = detail.version {
                        HermesLabeledValue(
                            label: "Version",
                            value: version,
                            isMonospaced: true
                        )
                    }
                }
            }
        }
    }

    private func metadataPanel(_ detail: SkillDetail) -> some View {
        HermesSurfacePanel(
            title: "Metadata",
            subtitle: "Optional frontmatter fields and companion directories discovered for this skill."
        ) {
            VStack(alignment: .leading, spacing: 16) {
                if !detail.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)

                        AdaptiveBadgeGrid(values: detail.tags, tint: .accentColor)
                    }
                }

                if !detail.relatedSkills.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Related skills")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)

                        AdaptiveBadgeGrid(values: detail.relatedSkills, tint: .secondary, monospaced: true)
                    }
                }

                if !detail.featureBadges.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Companion directories")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)

                        HStack(spacing: 8) {
                            ForEach(detail.featureBadges) { badge in
                                HermesBadge(text: badge.title, tint: badge.color)
                            }
                        }
                    }
                }
            }
        }
    }
}

private struct AdaptiveBadgeGrid: View {
    let values: [String]
    let tint: Color
    var monospaced = false

    private let columns = [
        GridItem(.adaptive(minimum: 90), spacing: 8, alignment: .leading)
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            ForEach(values, id: \.self) { value in
                HermesBadge(text: value, tint: tint, isMonospaced: monospaced)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
