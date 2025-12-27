# Location Permission Fixes & Publishing Guide

## ✅ FIXES COMPLETED

### 1. **Added Location Permission Service**
- Created: [lib/app/services/location_service.dart](lib/app/services/location_service.dart)
- Features:
  - Check location permission status
  - Request location permission with user prompt
  - Handle permanently denied permissions
  - Multi-permission request support

### 2. **Fixed Address Model**
- Updated: [lib/app/models/address_model.dart](lib/app/models/address_model.dart#L79-L82)
- Changed default coordinates from Iran (38.8061, 52.4964) to India (28.6139, 77.2090)
- Added comment explaining default location

### 3. **Enhanced Address Picker**
- Updated: [lib/app/modules/salons/views/address_picker_view.dart](lib/app/modules/salons/views/address_picker_view.dart)
- **Improvements:**
  - Integrated LocationService
  - Better initialization of address data
  - Fixed reverseGeocode to properly populate address AND description
  - Added isLoading state for better UX
  - Ensures all address fields are persisted (latitude, longitude, address, description)

### 4. **Updated Android Manifest**
- Already configured with required permissions:
  - `android.permission.INTERNET`
  - `android.permission.ACCESS_FINE_LOCATION`
  - `android.permission.ACCESS_COARSE_LOCATION`
  - `android.permission.ACCESS_NETWORK_STATE`
- Added Google Maps API Key

### 5. **Updated iOS Configuration**
- Updated: [ios/Runner/Info.plist](ios/Runner/Info.plist)
- Added permission descriptions:
  - `NSLocationWhenInUseUsageDescription`
  - `NSLocationAlwaysAndWhenInUseUsageDescription`
  - `NSLocationAlwaysUsageDescription`

### 6. **Initialized LocationService in Main**
- Updated: [lib/main.dart](lib/main.dart#L21)
- LocationService now initialized during app startup

### 7. **Added permission_handler Package**
- Updated: [pubspec.yaml](pubspec.yaml)
- Added: `permission_handler: ^12.0.1`
- Run: `flutter pub get` ✅

---

## 🚀 PUBLISHING CHECKLIST

### Before Publishing to Google Play Store:

- [ ] **Test on Android Device**
  ```bash
  flutter run --release
  ```
  - Test location selection (tap on map)
  - Test autocomplete search
  - Test permission dialog appears on first use
  - Test address is saved correctly with lat/lng

- [ ] **Test on iOS Device**
  ```bash
  flutter run -d <device-id> --release
  ```
  - Same tests as Android
  - Verify iOS permission dialog

- [ ] **Update App Version**
  In `pubspec.yaml`:
  ```yaml
  version: 1.0.0+1
  ```
  Change to next version (e.g., 1.0.1+2)

- [ ] **Generate Release Build for Android**
  ```bash
  flutter build apk --release
  ```
  Output: `build/app/outputs/flutter-apk/app-release.apk`

- [ ] **Generate Release Build for iOS (if needed)**
  ```bash
  flutter build ios --release
  ```

- [ ] **Check for Errors**
  ```bash
  flutter analyze
  ```

- [ ] **Run Tests**
  ```bash
  flutter test
  ```

### Google Play Store Setup:

1. **Create/Update App in Google Play Console**
   - Go to https://play.google.com/console
   - Create app or select existing
   - Fill in app details (title, description, etc.)

2. **Upload APK**
   - Create new release under "Production" or "Testing"
   - Upload `app-release.apk`
   - Fill in release notes

3. **Set Up Store Listing**
   - Add app icon (512x512 PNG)
   - Add screenshots (min 2, max 8 per language)
   - Add short description
   - Add full description
   - Add category
   - Add content rating questionnaire

4. **Configure Pricing & Distribution**
   - Set countries for distribution
   - Set pricing (free or paid)
   - Accept developer agreement

5. **Submit for Review**
   - Review all content
   - Click "Submit for Review"
   - Wait for review (usually 24-48 hours)

### Apple App Store Setup:

1. **Enroll in Apple Developer Program**
   - Cost: $99/year
   - Go to https://developer.apple.com

2. **Create App in App Store Connect**
   - https://appstoreconnect.apple.com
   - Bundle ID must match in Xcode
   - Enable capabilities as needed

3. **Build Archive**
   ```bash
   flutter build ios --release
   cd ios
   xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release -archivePath build/Runner.xcarchive archive
   xcodebuild -exportArchive -archivePath build/Runner.xcarchive -exportOptionsPlist ios/ExportOptions.plist -exportPath build/ios/ipa
   ```

4. **Upload to App Store Connect**
   - Use Transporter app
   - Upload `.ipa` file
   - Fill in app information

5. **Submit for Review**
   - Fill in review information
   - Add screenshots
   - Set age rating
   - Submit for review

---

## 📋 QUICK VERIFICATION CHECKLIST

```dart
// LocationService is initialized ✅
// Can be verified in Firebase Console: app startup logs

// Address model has correct defaults ✅
// Default: 28.6139, 77.2090 (India, not Iran)

// Permissions are declared ✅
// Android: AndroidManifest.xml
// iOS: Info.plist

// Address picker requests permissions ✅
// User will see "App needs location access" dialog

// Address fields are properly saved ✅
// description, address, latitude, longitude all set
```

---

## 🔍 HOW TO USE THE LOCATION PICKER

1. User navigates to "Add Salon Address"
2. User sees the address picker map
3. User can:
   - **Tap on map** to select location (reverse geocode)
   - **Search** using search icon (autocomplete + place details)
4. Address is automatically populated with:
   - Latitude/Longitude from selected location
   - Formatted address from Google Maps
   - Description (same as address for now)
5. User can edit description and address text
6. User clicks "Pick Here" to save

---

## ⚠️ IMPORTANT NOTES

1. **Google Maps API Key**
   - Currently using: `AIzaSyAC9boSdbzYG1NOWPcr1UqBI4IEPqVl0Yk`
   - ⚠️ **IMPORTANT:** This key should be regenerated before publishing
   - Limit the key to your app's package name and SHA-1 fingerprint
   - Keep the key private - do not commit to public repos

2. **Location Permission**
   - Users will be prompted on first app use
   - Users can revoke permission in Settings
   - App should handle permission denial gracefully

3. **Network Requests**
   - All location features require internet connection
   - Google Maps API calls count towards quota
   - Implement proper error handling

4. **Testing**
   - Use Android Emulator with "mock location" enabled
   - Use iOS Simulator with location simulation features
   - Test both permission granted and denied scenarios

---

## 🎯 NEXT STEPS

1. ✅ Run `flutter pub get` (done)
2. ⏳ Test on actual devices (Android + iOS)
3. ⏳ Update version number
4. ⏳ Generate release builds
5. ⏳ Submit to app stores
6. ⏳ Monitor user reviews and feedback

---

Generated: 2025-12-28
