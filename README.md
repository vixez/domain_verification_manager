# Domain Verification Manager
[![pub package](https://img.shields.io/pub/v/domain_verification_manager.svg)](https://pub.dev/packages/domain_verification_manager)

This plugin exposes some of the method to check the [Android App Links verification](https://developer.android.com/training/app-links/verify-site-associations) state, by using the [DomainVerificationManager](https://developer.android.com/reference/android/content/pm/verify/domain/DomainVerificationManager) API.

:warning: This only works with Android 12 (S - API Level 31) and up. Older versions will throw an error with `WRONG_SDK_VERSION`, while other platforms will return `UnsupportedError`.

You can use `await DomainVerificationManager.isSupported` to check if the current Platform and API version is supported.

You are able to:

* Get the domains that have passed Android App Links verification (`domainStageVerified`)
* Get domains that haven't passed Android App Links verification, but the user manually associated the app (`domainStageSelected`)
* All other domains (`domainStageNone`)
* Open the app settings where the user can manually grant permission (`domainRequest`)

`await DomainVerificationManager.domainStageVerified` returns a `List<String>?`.\
`await DomainVerificationManager.domainStageSelected` returns a `List<String>?`.\
`await DomainVerificationManager.domainStageNone` returns a `List<String>?`.\
`await DomainVerificationManager.domainRequest` opens the app settings page.



