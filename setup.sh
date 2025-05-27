#!/bin/bash
set -e

echo "Starting setup script for Flutter (version 3.29.2) and Android SDK..."

# --- Install Dependencies (if needed) ---
echo "Updating package lists..."
sudo apt update

echo "Installing required dependencies..."
sudo apt install -y curl git unzip  libsqlite3-0 libsqlite3-dev

# --- Install Flutter Version 3.29.2 ---
echo "Downloading Flutter SDK version 3.29.2..."
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git --depth 1 --branch 3.29.2
else
  echo "Flutter SDK already exists. Attempting to checkout version 3.29.2..."
  cd flutter
  git checkout 3.29.2
  cd ..
fi

echo "Adding Flutter to PATH..."
mkdir /tools
export PATH="$PATH:/tools/flutter/bin"
echo export PATH="$PATH:/tools/flutter/bin" >> $HOME/.bashrc
export PATH="$PATH:/tools/flutter/.pub-cache/bin" # Add pub global executables to PATH
echo export PATH="$PATH:/tools/flutter/.pub-cache/bin" >> $HOME/.bashrc
echo "Flutter version:"
flutter --version

# --- Install Android SDK ---
echo "Downloading and installing Android SDK command-line tools..."
if [ ! -d "android-sdk-cmdline-tools" ]; then
  wget https://dl.google.com/android/repository/commandlinetools-linux-11310580_latest.zip -O android-cmdline-tools.zip
  unzip android-cmdline-tools.zip -d android-sdk-cmdline-tools
  rm android-cmdline-tools.zip
else
  echo "Android SDK command-line tools already exist."
fi

export ANDROID_HOME=/tools/android-sdk-cmdline-tools
echo export ANDROID_HOME=/tools/android-sdk-cmdline-tools >> $HOME/.bashrc
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator"
echo export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator" >> $HOME/.bashrc

echo "Accepting Android SDK licenses..."
yes | sdkmanager --sdk_root="$ANDROID_HOME" --licenses

# --- Install necessary Android SDK components ---
echo "Installing required Android SDK components..."
sdkmanager --sdk_root="$ANDROID_HOME" "platforms;android-34" "build-tools;34.0.0" # Adjust versions as needed
sdkmanager --sdk_root="$ANDROID_HOME" "emulator" "platform-tools"

# --- Verify setup ---
echo "Verifying Flutter installation..."
flutter doctor

echo "Verifying Android SDK setup..."
adb version
emulator -list-avds # This might require further setup of AVDs

echo "Setup script completed."