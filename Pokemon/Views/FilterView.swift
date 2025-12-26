//
//  FilterView.swift
//  Pokemon
//
//  Created by Goutham Das T on 26/12/25.
//

import SwiftUI

struct FilterView: View {
    @Binding var filterOptions: FilterOptions
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Sort By", selection: $filterOptions.sortOption) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                } header: {
                    Text("Sort")
                }

                Section {
                    FlowLayout(spacing: 8) {
                        ForEach(PokemonType.allCases) { type in
                            TypeFilterChip(
                                type: type,
                                isSelected: filterOptions.selectedTypes.contains(type),
                                onTap: {
                                    toggleType(type)
                                }
                            )
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    HStack {
                        Text("Filter by Type")
                        Spacer()
                        if !filterOptions.selectedTypes.isEmpty {
                            Text("\(filterOptions.selectedTypes.count) selected")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }

                if filterOptions.isActive {
                    Section {
                        Button(role: .destructive) {
                            filterOptions = filterOptions.reset()
                        } label: {
                            HStack {
                                Spacer()
                                Label("Clear All Filters", systemImage: "xmark.circle.fill")
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        filterOptions = filterOptions.reset()
                    }
                    .disabled(!filterOptions.isActive)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func toggleType(_ type: PokemonType) {
        if filterOptions.selectedTypes.contains(type) {
            filterOptions.selectedTypes.remove(type)
        } else {
            filterOptions.selectedTypes.insert(type)
        }
    }
}

struct TypeFilterChip: View {
    let type: PokemonType
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(type.displayName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : Color(
                    red: type.color.red,
                    green: type.color.green,
                    blue: type.color.blue
                ))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    Color(red: type.color.red, green: type.color.green, blue: type.color.blue) :
                    Color(red: type.color.red, green: type.color.green, blue: type.color.blue).opacity(0.2)
                )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            Color(red: type.color.red, green: type.color.green, blue: type.color.blue),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FilterView(filterOptions: .constant(FilterOptions()))
}
