# TestFlight Deployment Guide for Chifron App

This guide will walk you through the process of building and deploying your Chifron Flutter app to Apple App Store via TestFlight using your `softdeveloper.pro` domain.

## Prerequisites

Before starting, ensure you have:

1. **Apple Developer Account** (paid membership - $99/year)
2. **Xcode** installed on your Mac (latest version recommended)
3. **Flutter** properly configured for iOS development
4. **App Store Connect** access
5. **Valid iOS Development and Distribution certificates**

## Step 1: Bundle Identifier Configuration ✅

The bundle identifier has been updated to use your domain:
- **Main App**: `pro.softdeveloper.chifron`
- **Test Target**: `pro.softdeveloper.chifron.RunnerTests`

## Step 2: App Store Connect Setup

1. **Create App in App Store Connect**:
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Click "My Apps" → "+" → "New App"
   - Fill in the details:
     - **Platforms**: iOS
     - **Name**: Chifron
     - **Primary Language**: English
     - **Bundle ID**: `pro.softdeveloper.chifron`
     - **SKU**: `chifron-ios` (unique identifier for your records)
     - **User Access**: Full Access

2. **Configure App Information**:
   - Add app description, keywords, and screenshots
   - Set up app categories and content rating
   - Configure pricing and availability

## Step 3: Code Signing Setup

1. **Open Xcode**:
   ```bash
   cd ios
   open Runner.xcworkspace
   ```

2. **Configure Signing**:
   - Select the "Runner" project in the navigator
   - Go to "Signing & Capabilities" tab
   - Ensure "Automatically manage signing" is checked
   - Select your Team (should be your Apple Developer account)
   - Verify the Bundle Identifier is `pro.softdeveloper.chifron`

3. **Verify Certificates**:
   - Xcode should automatically create/use the necessary certificates
   - If you encounter issues, go to Xcode → Preferences → Accounts
   - Select your Apple ID and click "Manage Certificates"

## Step 4: Build Configuration

1. **Update Version and Build Number**:
   - In `pubspec.yaml`, update the version:
   ```yaml
   version: 1.0.0+1  # Format: version+build_number
   ```

2. **Clean and Get Dependencies**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Generate Icons** (if not done already):
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

## Step 5: Build for Release

1. **Build iOS App**:
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select "Any iOS Device (arm64)" as the target
   - Go to Product → Archive
   - Wait for the archive process to complete

## Step 6: Upload to App Store Connect

1. **From Xcode Organizer**:
   - After archiving, Xcode will open the Organizer
   - Select your archive and click "Distribute App"
   - Choose "App Store Connect"
   - Select "Upload"
   - Follow the signing and distribution steps

2. **Alternative: Using Command Line**:
   ```bash
   # Build and upload directly
   flutter build ipa --release
   xcrun altool --upload-app --type ios --file build/ios/ipa/chifron.ipa --username "your-apple-id@email.com" --password "app-specific-password"
   ```

## Step 7: TestFlight Configuration

1. **In App Store Connect**:
   - Go to your app → TestFlight tab
   - Wait for the build to process (can take 5-30 minutes)
   - Once processed, click "Test Information" to add:
     - What to Test
     - Feedback Email
     - Build Notes

2. **Add Internal Testers**:
   - Go to "Internal Testing" section
   - Click "+" to add testers
   - Enter email addresses of your team members
   - They'll receive an email invitation to test

3. **Add External Testers** (Optional):
   - Go to "External Testing" section
   - Create a new group
   - Add testers (up to 10,000 external testers)
   - Submit for Beta App Review (required for external testing)

## Step 8: Testing Process

1. **Internal Testing**:
   - Testers receive email invitation
   - They download TestFlight app from App Store
   - Accept invitation and install your app
   - Provide feedback through TestFlight

2. **External Testing**:
   - Requires Beta App Review (24-48 hours)
   - Once approved, external testers can access
   - Great for beta testing with real users

## Step 9: Submit for App Store Review

When ready for App Store release:

1. **Complete App Store Information**:
   - Screenshots for all device sizes
   - App description and keywords
   - Privacy policy URL
   - Support URL

2. **Submit for Review**:
   - Go to "App Store" tab in App Store Connect
   - Click "Submit for Review"
   - Answer compliance questions
   - Wait for review (typically 24-48 hours)

## Troubleshooting Common Issues

### Build Issues
```bash
# Clean everything and rebuild
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter build ios --release
```

### Code Signing Issues
- Ensure your Apple Developer account is active
- Check that certificates are valid and not expired
- Verify bundle identifier matches exactly
- Try regenerating certificates in Xcode

### Upload Issues
- Check internet connection
- Verify Apple ID credentials
- Ensure app-specific password is used (not regular password)
- Check that build meets App Store requirements

### TestFlight Issues
- Wait for processing to complete (can take time)
- Ensure build version is higher than previous uploads
- Check that all required metadata is provided

## Version Management

For subsequent releases:

1. **Update Version Numbers**:
   ```yaml
   # pubspec.yaml
   version: 1.0.1+2  # Increment both version and build number
   ```

2. **Build and Upload**:
   ```bash
   flutter build ios --release
   # Archive and upload through Xcode
   ```

## Important Notes

- **Bundle ID**: `pro.softdeveloper.chifron` (cannot be changed after first upload)
- **Development Team**: Your Apple Developer account
- **Minimum iOS Version**: 12.0 (as configured)
- **Build Requirements**: Must be built on macOS with Xcode
- **Review Process**: External TestFlight testing requires Beta App Review

## Support Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [Flutter iOS Deployment](https://flutter.dev/docs/deployment/ios)
- [TestFlight User Guide](https://developer.apple.com/testflight/)

---

**Next Steps**: After successful TestFlight deployment, you can proceed to App Store submission when your app is ready for public release. 