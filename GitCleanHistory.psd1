#
# Module manifest for GitCleanHistory
#

@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'Clean-GitHistory.ps1'

    # Version number of this module.
    ModuleVersion = '2.0.1'

    # ID used to uniquely identify this module
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'

    # Author of this module
    Author = 'goliathuy'

    # Company or vendor of this module
    CompanyName = 'Unknown'

    # Copyright statement for this module
    Copyright = '(c) 2025 goliathuy. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'A PowerShell tool for safely removing sensitive text from Git repository history. Removes accidentally committed secrets, proprietary information, or any sensitive data from all commits with comprehensive backup and validation features.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Functions to export from this module
    FunctionsToExport = @()

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module
    AliasesToExport = @()

    # List of all files packaged with this module
    FileList = @('Clean-GitHistory.ps1', 'Test-GitHistoryCleaner.ps1', 'README.md', 'CHANGELOG.md', 'EXAMPLES.md', 'LICENSE')

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module to aid in module discovery
            Tags = @('Git', 'Security', 'Cleanup', 'History', 'Sensitive-Data', 'DevOps', 'Version-Control')

            # A URL to the license for this module
            LicenseUri = 'https://github.com/goliathuy/gitCleanHistory/blob/master/LICENSE'

            # A URL to the main website for this project
            ProjectUri = 'https://github.com/goliathuy/gitCleanHistory'

            # A URL to an icon representing this module
            # IconUri = ''

            # Release notes for this version of the module
            ReleaseNotes = 'v2.0.1: Critical fix for git filter-branch implementation with automated testing validation'

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()
        }
    }
}
