//
//  Sidebar View.swift
//  Cork
//
//  Created by David Bureš on 14.02.2023.
//

import SwiftUI

struct SidebarView: View
{
    @EnvironmentObject var brewData: BrewDataStorage
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var availableTaps: AvailableTaps
    
    @EnvironmentObject var selectedPackageInfo: SelectedPackageInfo

    var body: some View
    {
        List
        {
            Section("Installed Formulae")
            {
                if !appState.isLoadingFormulae
                {
                    ForEach(brewData.installedFormulae)
                    { formula in
                        NavigationLink
                        {
                            PackageDetailView(package: formula, packageInfo: selectedPackageInfo)
                        } label: {
                            PackageListItem(packageItem: formula)
                        }
                        .contextMenu
                        {
                            Button {
                                Task{
                                    try await uninstallSelectedPackage(package: formula, brewData: brewData, appState: appState)
                                }
                            } label: {
                                Text("Uninstall Formula")
                            }

                        }
                    }
                }
                else
                {
                    ProgressView()
                }
            }
            
            Section("Installed Casks")
            {
                if !appState.isLoadingCasks
                {
                    ForEach(brewData.installedCasks)
                    { cask in
                        NavigationLink {
                            PackageDetailView(package: cask, packageInfo: selectedPackageInfo)
                        } label: {
                            PackageListItem(packageItem: cask)
                        }
                        .contextMenu
                        {
                            Button {
                                Task
                                {
                                    try await uninstallSelectedPackage(package: cask, brewData: brewData, appState: appState)
                                }
                            } label: {
                                Text("Uninstall Cask")
                            }

                        }

                    }
                }
                else
                {
                    ProgressView()
                }
            }
            
            Section("Tapped Taps")
            {
                if availableTaps.tappedTaps.count != 0
                {
                    ForEach(availableTaps.tappedTaps)
                    { tap in
                        Text(tap.name)
                    }
                }
                else
                {
                    ProgressView()
                }
            }
        }
        .listStyle(.sidebar)
    }
}
